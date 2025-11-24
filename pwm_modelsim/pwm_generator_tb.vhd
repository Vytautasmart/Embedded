library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_generator_tb is
end pwm_generator_tb;

architecture Behavioral of pwm_generator_tb is

signal clk:`` STD_LOGIC;
signal dac_data: out STD_LOGIC;

component pwm_genertator
  Port (clk: STD_LOGIC; dac_data: out STD_LOGIC);
end component;



begin

dut: pwm_generator port map (clk => clk, dac_data => dac_data);
    --------------------------------------------------------------------
    -- Clock generation (50 MHz assumed ? 20 ns period)
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <='1';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
        -- End simulation

end Behavioral;