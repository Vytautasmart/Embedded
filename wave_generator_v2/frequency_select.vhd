library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frequency_select is
    Port (
        key        : in  STD_LOGIC_VECTOR(3 downto 0); 
        clk        : in  STD_LOGIC;
        hold_value : out INTEGER
    );
end frequency_select;

architecture minimal of frequency_select is
    
	 signal val : INTEGER := 156249;
    signal key0_prev : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- detect rising edge of KEY0
            if (key(0) = '1' and key0_prev = '0') then

                -- choose value based on which key is active
                if key(3) = '1' then
                    val <= 156249;
                elsif key(2) = '1' then
                    val <= 15625;
                elsif key(1) = '1' then
                    val <= 1562;
                else
                    val <= 156;   -- KEY0 acts as lowest freq option
                end if;

            end if;

            key0_prev <= key(0);

        end if;
    end process;

    hold_value <= val;

end minimal;
