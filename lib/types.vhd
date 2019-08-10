library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is

  type DELAY_T is array(natural range <>) of std_logic;
  subtype REG_T is std_logic_vector(15 downto 0);
  
end package types;
