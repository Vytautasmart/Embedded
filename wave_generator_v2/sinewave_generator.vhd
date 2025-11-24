library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sinewave_generator is
    Port (
        clk         : in  STD_LOGIC;
        wave_out_hex: out std_logic_vector(7 downto 0);
        sw          : in  STD_LOGIC_VECTOR(3 downto 0);
		  sseg0, sseg1, sseg2, sseg3, sseg4 : out std_logic_vector(7 downto 0)
    );
end sinewave_generator;





architecture Behavioral of sinewave_generator is

component ssegDecoder is port
	(
		binaryIn	 : in std_logic_vector(3 downto 0);
		ssegOut	 : out std_logic_vector(7 downto 0)
	);
end component;

	-- Array computed using MatLAB
    type wave_array is array (0 to 31) of INTEGER;
    constant wave : wave_array := (
        128,153,178,200,220,236,247,254,255,251,242,228,211,189,166,140,
        115,89,66,44,27,13,4,0,1,8,19,35,55,77,102,127
    );

    type state_type is (UPDATE_VALUE, HOLD);
    signal current_state : state_type := UPDATE_VALUE;

    signal holdVal : integer;
	 signal dig0, dig1, dig2, dig3 , dig4 : std_logic_vector(3 downto 0);

begin

	ssegTensTh  : ssegDecoder port map (binaryIn => dig4, ssegOut => sseg4);
	ssegTh  : ssegDecoder port map (binaryIn => dig3, ssegOut => sseg3);
	ssegHunds : ssegDecoder port map (binaryIn => dig2, ssegOut => sseg2);
	ssegTens  : ssegDecoder port map (binaryIn => dig1, ssegOut => sseg1);
	ssegOnes  : ssegDecoder port map (binaryIn => dig0, ssegOut => sseg0);

    process(clk)
        variable i     : INTEGER range 0 to 31 := 0;
        variable count : INTEGER range 0 to 156249 := 0;
    begin
        if rising_edge(clk) then

            case current_state is

                when UPDATE_VALUE =>
					 -- wave_out_hex is converted from an integer value to a 8-bit
					 -- standart logic vector for the TLC7524CN to read
                    wave_out_hex <= std_logic_vector(to_unsigned(wave(i), 8));

                    if i = 31 then
                        i := 0;
                    else
                        i := i + 1;
                    end if;

                    count := 0;
                    current_state <= HOLD;

                when HOLD =>
					 -- holdVal holds the amount of clock cycles needed to wait before 
					 -- iterating to the next discreticised value of the array
                    if count >= holdVal then
                        current_state <= UPDATE_VALUE;
                    else
                        count := count + 1;
                    end if;

            end case;

        end if;
    end process;

process(sw)

	begin	
	
    -- Switch-based frequency selection
   if sw(2) = '1' then holdVal <= 156;  -- 10 kHz
			dig4 <= "0001";	-- 1
			dig3 <= "0000";	-- 0
			dig2 <= "0000";	-- 0
			dig1 <= "0000";   -- 0
			dig0 <= "0000";   -- 0
    elsif sw(1) = '1' then holdVal <= 1562; -- 1 kHz
			dig4 <= "0000";	-- 0
			dig3 <= "0001";	-- 1
			dig2 <= "0000";	-- 0
			dig1 <= "0000";   -- 0
			dig0 <= "0000";   -- 0
    elsif sw(0) = '1' then holdVal <= 15625; -- 100 Hz
			dig4 <= "0000";	-- 0
			dig3 <= "0000";	-- 0
			dig2 <= "0001";   -- 1
			dig1 <= "0000";   -- 0
			dig0 <= "0000";   -- 0
    else holdVal <= 156249; 						-- 10 Hz
			dig4 <= "0000";	-- 0
			dig3 <= "0000";	-- 0
			dig2 <= "0000";   -- 0
			dig1 <= "0001";   -- 1
			dig0 <= "0000";   -- 0 
    end if;
end process;


end Behavioral;
