library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port(
    -- clock and reset lines
    clk : in std_logic;
    rst : in std_logic;
    -- control signal
    ctrl : in std_logic_vector(2 downto 0);
    -- A and B registers
    A : in std_logic_vector(7 downto 0);
    B : in std_logic_vector(7 downto 0);
    -- output
    Y : in std_logic_vector(7 downto 0)
  );
end entity alu;

architecture rtl of alu is

begin

  process(clk)
  begin

    if rising_edge(clk) then

      if rst='1' then

        Y <= (others => '0');

      else

        case ctrl is
          when "000" =>
            Y <= A;
          when "001" =>
            Y <= B;
          when "010" =>
            Y <= std_logic_vector(signed(A) + to_signed(1, A'length));
          when "011" =>
            Y <= std_logic_vector(signed(B) + to_signed(1, B'length));
          when "100" =>
            Y <= std_logic_vector(signed(A) + signed(B));
          when "101" =>
            Y <= std_logic_vector(signed(A) - signed(B));
          when "110" =>
            Y <= A and B;
          when "111" =>
            Y <= A or B;
        end case;

      end if;
    
    end if;
  end process;
end architecture rtl;
