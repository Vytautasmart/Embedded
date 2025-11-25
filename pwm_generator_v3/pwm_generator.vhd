library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity pwm_generator is
   Port (
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       duty_cycle : in INTEGER range 0 to 100; -- Duty cycle percentage
       pwm_out : out STD_LOGIC_VECTOR(7 downto 0)
   );
end pwm_generator;



architecture Behavioral of pwm_generator is



   signal counter : integer := 0;
begin
   process(clk, reset)
   begin
       if reset = '1' then
           counter <= 0;
           pwm_out <= "00000000";
       elsif rising_edge(clk) then
           if counter < duty_cycle then
               pwm_out <= "11111111";
           else
               pwm_out <= "00000000";
           end if;
           if counter = 100 then -- Full cycle (adjust as needed)
               counter <= 0;
           else
               counter <= counter + 1;
           end if;
       end if;
   end process;
end Behavioral;