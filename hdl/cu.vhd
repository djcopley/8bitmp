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

    opcompl : out std_logic; -- data valid flag
    jmpc : out std_logic;
    addr_or_load : out std_logic_vector(7 downto 0);
    alu_code : out std_logic_vector(2 downto 0);
    reg_sel : out std_logic_vector(1 downto 0);
    b_sel : out std_logic_vector(1 downto 0)
  );
end entity cu;

architecture rtl of cu is

  -- i_ prefix stands for internal
  signal i_addr_sel : std_logic_vector(7 downto 0); -- selected address
  signal i_rd_en : std_logic; -- read enable
  signal i_opcompl : std_logic; -- operation complete

  signal i_MIR : std_logic_vector(15 downto 0); -- internal registerd memory instruction register

  alias i_jmpc is i_MIR(15); -- jump select
  alias i_addr_or_load is i_MIR(14 downto 7); -- represents address if jmpc='1' else number to be loaded in reg
  alias i_alu_code is i_MIR(6 downto 4);
  alias i_reg_sel is i_MIR(3 downto 2);
  alias i_b_sel is i_MIR(1 downto 0);

begin

  opcompl <= i_opcompl;
  jmpc <= i_jmpc;
  addr_or_load <= i_addr_or_load;
  alu_code <= i_alu_code;
  reg_sel <= i_reg_sel;
  b_sel <= i_b_sel;

  inst_progmem : entity work.progmem
  generic map(
    ADDR_BITS => 8
  )
  port map(
    clk => clk,
    rst => rst,
    addr => i_addr_sel,
    wr_en => '0',
    din => (others => '0'),
    rd_en => i_rd_en,
    opcompl => i_opcompl,
    dout => i_MIR
  );

  process(clk)
  begin

    if rising_edge(clk) then

      if rst='1' then

        i_addr_sel <= (others => '0');
        i_rd_en <= '0';

      else


        if fetch='1' then

          i_rd_en <= '1';

          case i_jmpc is
            when '0' =>
              i_addr_sel <= PC;
            when others =>
              i_addr_sel <= i_addr_or_load;
          end case;

        else
          
          i_rd_en <= '0';
        
        end if;

      end if;
    end if;
  end process;

end architecture rtl;
