library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpulib;
use cpulib.helpers.all;

entity progmem is
  generic(
    ADDR_BITS : positive
  );
  port(
    clk : in std_logic;
    rst : in std_logic;
    addr : in std_logic_vector(ADDR_BITS-1 downto 0);
    wr_en : in std_logic; -- write enable
    din : in std_logic_vector(15 downto 0);
    rd_en : in std_logic; -- read enable
    opcompl : out std_logic;
    dout : out std_logic_vector(15 downto 0)
  );
end entity progmem;

architecture rtl of progmem is

  type ram_t is array(0 to 2**ADDR_BITS - 1) of std_logic_vector(15 downto 0); -- word-addressable
  signal ram : ram_t;

begin

  read : process(clk)
  begin

    if rising_edge(clk) then
      
      if rst='1' then

        dout <= (others => '0');
        opcompl <= '0';

      else

        if rd_en='1' then

          dout <= ram(slv2index(addr));
          opcompl <= '1';

        else

          opcompl <= '0';

        end if;

      end if;
    end if;
  end process;

  write : process(clk)
  begin
    
    if rising_edge(clk) then
      
      if rst='1' then

        ram <= (others => (others => '0'));

      else

        if wr_en='1' then
          
          ram(slv2index(addr)) <= din;

        end if;

      end if;
    end if;
  end process;

end architecture rtl;

