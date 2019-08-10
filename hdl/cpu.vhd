library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpulib;
use cpulib.helpers.all;

entity cpu is
  port(
    clk : std_logic;
    rst : std_logic;
    EXTIN : std_logic_vector(7 downto 0);
    EXTOUT : std_logic_vector(7 downto 0)
  );
end entity cpu;

architecture rtl of cpu is

  type FETCH_EXECUTE_CYCLE_T is (FETCH, DECODE, EXECUTE, INCR);
  signal FE_STATE : FETCH_EXECUTE_CYCLE_T; -- Fetch-Execute cycle state

  signal A : std_logic_vector(7 downto 0); -- 1 byte general-purpose register
  signal B : std_logic_vector(7 downto 0); -- 1 byte general-purpose register
  signal PC : std_logic_vector(7 downto 0); -- Program Counter
  signal LOAD : std_logic_vector(7 downto 0); -- load register

  signal B_SELECTED : std_logic_vector(7 downto 0); -- selected B input
  signal C_BUS : std_logic_vector(7 downto 0); -- ALU output bus

  signal alu_en : std_logic; -- alu enable
  signal alu_ctrl : std_logic_vector(2 downto 0); -- alu control bits
  signal alu_ready : std_logic; -- alu completed operation

  signal cu_en : std_logic; -- tell the control unit to fetch and decode next instruction
  signal cu_ready : std_logic; -- control unit ready

  signal jmpc : std_logic; -- jump control 
  signal reg_write_sel : std_logic_vector(1 downto 0);
  signal b_sel : std_logic_vector(1 downto 0);

begin

  inst_ctrlunit : entity work.cu
  port map(
    clk => clk,
    rst => rst,
    fetch => cu_en,
    PC => PC,
    ready => cu_ready,
    jmpc => jmpc,
    addr_or_load => LOAD,
    alu_code => alu_ctrl,
    reg_sel => reg_write_sel,
    b_sel => b_sel
  );

  inst_alu : entity work.alu
  port map(
    clk => clk,
    rst => rst,
    en => alu_en,
    ctrl => alu_ctrl,
    A => A,
    B => B_SELECTED,
    C => C_BUS,
    alu_ready => alu_ready
  );

  process(clk)
  begin

    if rising_edge(clk) then
      if rst='1' then

        -- synchronous reset
        FE_STATE <= FETCH;
        cu_en <= '0';

      else

        case FE_STATE is
          when FETCH =>
            --
            if cu_en='0' then
              cu_en <= '1';
            else
              cu_en <= '0';
              FE_STATE <= DECODE;
            end if;

          when DECODE =>
            -- wait for control unit to finish decoding instruction
            if cu_ready='1' then
              case b_sel is
                when "00" =>
                  B_SELECTED <= B;
                when "01" =>
                  B_SELECTED <= PC;
                when "10" =>
                  B_SELECTED <= LOAD;
                when others =>
                  B_SELECTED <= EXTIN;
              end case;
              alu_en <= '1';
              FE_STATE <= EXECUTE;
            end if;

          when EXECUTE =>
            -- execute instruction
            if alu_ready then
              case reg_write_sel is
                when "00" =>
                  A <= C_BUS;
                when "01" =>
                  B <= C_BUS;
                when "10" =>
                  PC <= C_BUS;
                when "11" =>
                  EXTOUT <= C_BUS;
              end case;
              FE_STATE <= INCR;
            end if;

          when INCR =>
            --
            if jmpc='1' then
              PC <= LOAD;
            else
              PC <= PC + 1;
            end if;
            FE_STATE <= FETCH;
        end case;

      end if;
    end if;
  end process;
end architecture rtl;
