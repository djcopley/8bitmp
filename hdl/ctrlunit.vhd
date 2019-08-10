library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpulib;
use cpulib.helpers.all;
use cpulib.types.all;
use cpulib.constants.all;

entity ctrlunit is
  port(
    clk : in std_logic;
    rst : in std_logic;
    ext_input : in std_logic_vector(7 downto 0); -- external input
    out_reg : out std_logic_vector(7 downto 0)
  );
end entity ctrlunit;

architecture rtl of ctrlunit is

  signal A_REG : std_logic_vector(7 downto 0); -- A register
  signal B_REG : std_logic_vector(7 downto 0); -- B register
  signal B_SELECTED : std_logic_vector(7 downto 0); -- selected B signal
  signal PC : std_logic_vector(7 downto 0); -- Program counter
  signal MBR : std_logic_vector(7 downto 0); -- Memory Byte Register

  signal MPC : std_logic_vector(4 downto 0); -- MicroProgram counter
  signal MIR : std_logic_vector(15 downto 0); -- Memory Instruction Register

  signal res_reg_sel : std_logic_vector(2 downto 0); -- Where to write alu result
  signal alu_result : std_logic_vector(7 downto 0); -- ALU Result

  alias b_sel is MIR(1 downto 0); -- b bus select lines
  alias reg_wr is MIR(6 downto 2); -- register write lines
  alias alu_ctrl is MIR(9 downto 7); -- alu control lines
  alias jmpc is MIR(10); -- jump control line 
  alias addr is MIR(15 downto 11); -- address lines

begin

  inst_alu : entity work.alu
  port map(
    clk => clk,
    rst => rst,
    ctrl => alu_ctrl,
    A => A_REG,
    B => B_SELECTED,
    Y => alu_result
  );

  inst_progmem : entity work.progmem
  generic map(
    ADDR_BITS => 5
  )
  port map(
    clk => clk,
    rst => rst,
    rw => '0',
    addr => MPC,
    wr_en => '0',
    din => (others => '0'),
    rd_en => rd_en,
    dout => MIR
  );

  process(clk)
  begin

    if rising_edge(clk) then

      if rst = '1' then

        A_REG <= (others => '0');
        B_REG <= (others => '0');
        B_SELECTED <= (others => '0');
        PC <= (others => '0');
        MBR <= (others => '0');

        MPC <= (others => '0');
        MIR <= (others => '0');

        out_reg <= (others => '0');

      else

        -- MPC select
        case jmpc is
          when '0' =>
            MPC <= addr;
          when others =>
            MPC <= MBR;
        end case;

        -- B bus select
        case b_sel is
          when "00" =>
            B_SELECTED <= B_REG;
          when "01" =>
            B_SELECTED <= MBR;
          when "10" =>
            B_SELECTED <= PC;
          when others =>
            B_SELECTED <= ext_input;
        end case;

      end if;

    end if;
  end process;
end architecture rtl;
