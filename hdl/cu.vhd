library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpulib;
use cpulib.helpers.all;
use cpulib.types.all;
use cpulib.constants.all;

entity cu is
  port(
    clk : in std_logic;
    rst : in std_logic;

    fetch : in std_logic; -- fetch next instruction flag
    PC : in std_logic_vector(7 downto 0);

    ready : out std_logic; -- data valid flag
    jmpc : out std_logic;
    addr_or_load : out std_logic_vector(6 downto 0);
    alu_code : out std_logic_vector(2 downto 0);
    reg_sel : out std_logic_vector(2 downto 0);
    b_sel : out std_logic_vector(1 downto 0)
  );
end entity cu;

architecture rtl of cu is

  signal _addr_sel : std_logic_vector(6 downto 0); -- selected address
  signal _rd_en : std_logic;

  signal _MIR : std_logic_vector(15 downto 0); -- internal registerd memory instruction register

  alias _jmpc is _MIR(15); -- jump select
  alias _addr_or_load is _MIR(14 downto 8); -- represents address if jmpc='1' else number to be loaded in reg
  alias _alu_code is _MIR(7 downto 5);
  alias _reg_sel is _MIR(4 downto 2);
  alias _b_sel is _MIR(1 downto 0);

begin

  jmpc <= _jmpc;
  addr_or_load <= _addr_or_load;
  alu_code <= _alu_code;
  reg_sel <= _reg_sel;
  b_sel <= _b_sel;

  inst_progmem : entity work.progmem
  generic map(
    ADDR_BITS => 8
  )
  port map(
    clk => clk,
    rst => rst,
    addr => _addr_sel,
    wr_en => '0',
    din => (others => '0'),
    rd_en => _rd_en,
    ready => ready,
    dout => _MIR
  );

  process(clk)
  begin

    if rising_edge(clk) then

      if rst = '1' then

        _MIR <= (others => '0');
        _addr_sel <= (others => '0');
        _rd_en <= '0';

      else


        if fetch='1' then

          _rd_en <= '1';

          case jmpc is
            when "0" =>
              _addr_sel <= PC;
            when others =>
              _addr_sel <= _addr_or_load;
          end case;

				else

					_rd_en <= '0';

        end if;

      end if;
    end if;
  end process;

end architecture rtl;
