library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpulib;
use cpulib.helpers.all;
use cpulib.types.all;
use cpulib.constants.all;

entity cpu is
  port(
    clk : in std_logic;
    rst : in std_logic
  );
end entity cpu;

architecture rtl of cpu is

begin

end architecture rtl;

