library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end entity cpu_tb;

architecture behav of cpu_tb is

  constant CLK_PERIOD : time := 10 ns;
  
  signal clk, rst : std_logic;

begin

  inst_cpu : entity work.cpu
  port map(
    clk => clk,
    rst => rst,
    EXTIN => (others => '0'),
    EXTOUT => open
  );

  clkgen : process
  begin
    clk <= '1', '0' after CLK_PERIOD / 2;
    wait for CLK_PERIOD;
  end process;

  rstproc : process
  begin
    rst <= '1';
    wait for 10 * CLK_PERIOD;
    rst <= '0';
    wait;
  end process;

end architecture behav;

