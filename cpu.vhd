library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpulib;

entity cpu is
  port(
    clk : in std_logic;
    rst : in std_logic;
    extin : in std_logic_vector(7 downto 0); -- external input
    extout : out std_logic_vector(7 downto 0) -- cpu output
  );
end entity cpu;

architecture rtl of cpu is

  -- Subtypes
  subtype BYTE_REG is std_logic_vector(7 downto 0);
  subtype WORD_REG is std_logic_vector(15 downto 0);

  -- Registers
  signal A : BYTE_REG; -- A general-purpose register
  signal B : BYTE_REG; -- B general-purpose register
  signal PC : BYTE_REG; -- Program Counter
  signal MBR : BYTE_REG; -- Memory Byte Register

begin

end architecture rtl;

