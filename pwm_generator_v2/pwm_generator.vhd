library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_generator is
  Port (
    clk     : in  STD_LOGIC;
    --rst     : in  STD_LOGIC;
    sw      : in  STD_LOGIC_VECTOR(3 downto 0); -- duty select switches
    pwm_out : out STD_LOGIC_VECTOR(7 downto 0);
	 sseg0, sseg1, sseg2 : out std_logic_vector(7 downto 0)
  );
end pwm_generator;

architecture Behavioral of pwm_generator is

	component ssegDecoder
	port
	(
		binaryIn	 : in std_logic_vector(3 downto 0);
		ssegOut	 : out std_logic_vector(7 downto 0)
	);
   end component;	

  constant period : integer := 50000;  -- 50 MHz / 1 kHz

  -- Precomputed duty counts
  constant DUTY_100 : integer := 50000;
  constant DUTY_75  : integer := 37500;
  constant DUTY_50  : integer := 25000;
  constant DUTY_25  : integer := 12500;
  constant DUTY_00  : integer := 0;
  --count signal declaratotions
  signal dig0, dig1, dig2 : std_logic_vector(3 downto 0);
  -- PWM counter and duty select declarations
  signal counter_pwm    : integer range 0 to period - 1 := 0;
  signal duty_count_sel : integer range 0 to period := DUTY_00; -- default 00%
  signal pwm_bit : std_logic := '0';

begin

ssegHunds : ssegDecoder port map(binaryIn => dig2, ssegOut => sseg2);
ssegTens  : ssegDecoder port map(binaryIn => dig1, ssegOut => sseg1);
ssegOnes  : ssegDecoder port map(binaryIn => dig0, ssegOut => sseg0);


  -- Duty selection logic (combinational)
  -- Priority: 100% > 75% > 50% > 25%

  process(sw)
  begin
    if sw(3) = '1' then
      duty_count_sel <= DUTY_100;
			dig2 <= "0001";   -- 1
			dig1 <= "0000";   -- 0
			dig0 <= "0000";   -- 0
    elsif sw(2) = '1' then
      duty_count_sel <= DUTY_75;
			dig2 <= "0000";
			dig1 <= "0111";   -- 7
			dig0 <= "0101";   -- 5
    elsif sw(1) = '1' then
      duty_count_sel <= DUTY_50;
			dig2 <= "0000";
			dig1 <= "0101";   -- 5
			dig0 <= "0000";   -- 0
    elsif sw(0) = '1' then
      duty_count_sel <= DUTY_25;
			dig2 <= "0000";
			dig1 <= "0010";   -- 2
			dig0 <= "0101";   -- 5
    else
      duty_count_sel <= DUTY_00; -- fallback if no switch pressed
			dig2 <= "0000";
			dig1 <= "0000";   -- 
			dig0 <= "0000";   -- 0
    end if;
  end process;

  
  -- PWM counter

  process(clk)
  begin
   -- if rst = '0' then
     -- counter_pwm <= 0;
    if rising_edge(clk) then
      if counter_pwm < period - 1 then
        counter_pwm <= counter_pwm + 1;
      else
        counter_pwm <= 0;
      end if;
    end if;
  end process;



  pwm_bit <= '1' when counter_pwm < duty_count_sel else '0';
  
  pwm_out <= (others => pwm_bit);
  
  
end Behavioral;
