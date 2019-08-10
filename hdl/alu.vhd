library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port(
    -- clock and reset lines
    clk : in std_logic;
    rst : in std_logic;
    -- control signals
    en : in std_logic;
    ctrl : in std_logic_vector(3 downto 0);
    -- A and B registers
    A : in std_logic_vector(7 downto 0);
    B : in std_logic_vector(7 downto 0);
    -- output
    ready : out std_logic;
    C : out std_logic_vector(7 downto 0)
  );
end entity alu;

architecture rtl of alu is

begin

  process(clk)
  begin

    if rising_edge(clk) then

      if rst='1' then

        C <= (others => '0');
        ready <= '0';

      else

        if en='1' then
          
          case ctrl is
            when "000" =>
              C <= A;
            when "001" =>
              C <= B;
            when "010" =>
              C <= std_logic_vector(signed(A) + to_signed(1, A'length));
            when "011" =>
              C <= std_logic_vector(signed(B) + to_signed(1, B'length));
            when "100" =>
              C <= std_logic_vector(signed(A) + signed(B));
            when "101" =>
              C <= std_logic_vector(signed(A) - signed(B));
            when "110" =>
              C <= A and B;
            when "111" =>
              C <= A or B;
          end case;
          
          ready <= '1';
        
        else
          
          ready <= '0';
        
        end if;

      end if;
    end if;
  end process;
end architecture rtl;
