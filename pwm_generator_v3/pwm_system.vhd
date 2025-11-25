library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--------------------------------------------------------------
-- TOP LEVEL: PWM SYSTEM WITH CLOCK DIVIDER
--------------------------------------------------------------
entity pwm_system is
    Port (
        clk_in      : in  STD_LOGIC;   -- 50 MHz input clock from board
        reset       : in  STD_LOGIC;
        duty_cycle  : in  INTEGER range 0 to 100; -- Set PWM duty (%)
        pwm_out     : out STD_LOGIC
    );
end pwm_system;

architecture Structural of pwm_system is

    -- Internal signals
    signal slow_clk : STD_LOGIC;

begin

    --------------------------------------------------------------
    -- CLOCK DIVIDER INSTANCE
    --------------------------------------------------------------
    DIVIDER_INST : entity work.clock_divider
        port map (
            clk_in  => clk_in,
            reset   => reset,
            clk_out => slow_clk
        );

    --------------------------------------------------------------
    -- PWM GENERATOR INSTANCE
    --------------------------------------------------------------
    PWM_INST : entity work.pwm_generator
        port map (
            clk        => slow_clk,    -- uses divided clock
            reset      => reset,
            duty_cycle => duty_cycle,
            pwm_out    => pwm_out
        );

end Structural;
