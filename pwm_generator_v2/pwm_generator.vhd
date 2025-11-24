library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_generator is
  Port (
    clk     : in  STD_LOGIC;
    --rst     : in  STD_LOGIC;
    sw      : in  STD_LOGIC_VECTOR(3 downto 0); -- duty select switches
    pwm_out : out STD_LOGIC_VECTOR(7 downto 0)
  );
end pwm_generator;

architecture Behavioral of pwm_generator is

  constant period : integer := 125;  -- 50 MHz / 400 kHz

  -- Precomputed duty counts
  constant DUTY_100 : integer := 125;
  constant DUTY_75  : integer := 94;
  constant DUTY_50  : integer := 62;
  constant DUTY_25  : integer := 31;

  signal counter_pwm    : integer range 0 to period := 0;
  signal duty_count_sel : integer range 0 to period := DUTY_50; -- default 50%
  signal pwm_bit        : std_logic := '0';

begin


  -- Duty selection logic (combinational)
  -- Priority: 100% > 75% > 50% > 25%

  process(sw)
  begin
    if sw(3) = '1' then
      duty_count_sel <= DUTY_100;
    elsif sw(2) = '1' then
      duty_count_sel <= DUTY_75;
    elsif sw(1) = '1' then
      duty_count_sel <= DUTY_50;
    elsif sw(0) = '1' then
      duty_count_sel <= DUTY_25;
    else
      duty_count_sel <= DUTY_50; -- fallback if no switch pressed
    end if;
  end process;

  
  -- PWM counter

  process(clk)
  begin
   -- if rst = '0' then
     -- counter_pwm <= 0;
    if rising_edge(clk) then
      if counter_pwm < period then
        counter_pwm <= counter_pwm + 1;
      else
        counter_pwm <= 0;
      end if;
    end if;
  end process;


  pwm_out <= "11111111" when counter_pwm < duty_count_sel else "00000000";
  
  

end Behavioral;
