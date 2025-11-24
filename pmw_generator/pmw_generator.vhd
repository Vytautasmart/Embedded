library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pmw_generator is
    Port (
        clk       : in  STD_LOGIC;      -- System clock
        switches  : in  STD_LOGIC_VECTOR(3 downto 0); -- Duty cycle switches
        pwm_out   : out STD_LOGIC;      -- Digital PWM output
        dac_data  : out STD_LOGIC_VECTOR(7 downto 0) -- 8-bit output to TLC7524C
    );
end pmw_generator;

architecture Behavioral of pmw_generator is

    signal counter : unsigned(7 downto 0) := (others => '0');
    signal duty    : unsigned(7 downto 0);
    
begin

    --------------------------------------------------------------------
    -- Duty cycle logic based on switches
    --------------------------------------------------------------------
    process (switches)
    begin
        case switches is
            when "0001" => duty <= to_unsigned(64, 8);   -- 25%
            when "0010" => duty <= to_unsigned(128, 8);  -- 50%
            when "0011" => duty <= to_unsigned(192, 8);  -- 75%
            when "0100" => duty <= to_unsigned(255, 8);  -- 100%
            when others => duty <= to_unsigned(128, 8);  -- Default 50%
        end case;
    end process;
    
    --------------------------------------------------------------------
    -- 8-bit PWM counter
    --------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;
    
    --------------------------------------------------------------------
    -- Compare counter to duty cycle and generate PWM
    --------------------------------------------------------------------
    pwm_out <= '1' when counter < duty else '0';

    --------------------------------------------------------------------
    -- Output to DAC (digital value representing duty cycle)
    --------------------------------------------------------------------
    dac_data <= std_logic_vector(duty);

end Behavioral;
