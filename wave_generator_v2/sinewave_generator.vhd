library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sinewave_generator is
    Port (
        clk         : in  STD_LOGIC;
        wave_out_hex: out std_logic_vector(7 downto 0);
        sw          : in  STD_LOGIC_VECTOR(3 downto 0)
    );
end sinewave_generator;

architecture Behavioral of sinewave_generator is

    type wave_array is array (0 to 31) of INTEGER;
    constant wave : wave_array := (
        128,153,178,200,220,236,247,254,255,251,242,228,211,189,166,140,
        115,89,66,44,27,13,4,0,1,8,19,35,55,77,102,127
    );

    type state_type is (UPDATE_VALUE, HOLD);
    signal current_state : state_type := UPDATE_VALUE;

    signal holdVal : integer;

begin

    process(clk)
        variable i     : INTEGER range 0 to 31 := 0;
        variable count : INTEGER range 0 to 156249 := 0;
    begin
        if rising_edge(clk) then

            case current_state is

                when UPDATE_VALUE =>
                    wave_out_hex <= std_logic_vector(to_unsigned(wave(i), 8));

                    if i = 31 then
                        i := 0;
                    else
                        i := i + 1;
                    end if;

                    count := 0;
                    current_state <= HOLD;

                when HOLD =>
                    if count >= holdVal then
                        current_state <= UPDATE_VALUE;
                    else
                        count := count + 1;
                    end if;

            end case;

        end if;
    end process;

    -- Switch-based frequency selection
    holdVal <= 156      when sw(0) = '1' else   -- 10 kHz
               1562     when sw(1) = '1' else   -- 1 kHz
               15625    when sw(2) = '1' else   -- 100 Hz
               156249;                           -- 10 Hz default

end Behavioral;
