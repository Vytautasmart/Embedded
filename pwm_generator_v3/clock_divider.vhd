library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity clock_divider is
   Port (
       clk_in : in STD_LOGIC;
       reset : in STD_LOGIC;
       clk_out : out STD_LOGIC
   );
end clock_divider;


architecture Behavioral of clock_divider is
    signal clk_out_i : std_logic := '0';
    signal counter   : integer := 0;
begin

    clk_out <= clk_out_i;   -- drive output from internal signal

    process(clk_in, reset)
    begin
        if reset = '1' then
            counter    <= 0;
            clk_out_i  <= '0';
        elsif rising_edge(clk_in) then
            if counter = 50000000 then
                clk_out_i <= NOT clk_out_i;
                counter   <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end Behavioral;
