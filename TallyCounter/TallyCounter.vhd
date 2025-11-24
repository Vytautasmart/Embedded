library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tallyCounter is port
(
	button, reset, clk : in std_logic;
	sseg0, sseg1, sseg2 : out std_logic_vector(7 downto 0)
);
end tallyCounter;

architecture behavioural of tallyCounter is

component doubleDabble is port

(
	clk :      in std_logic;
	binaryIn : in unsigned(11 downto 0);
	bcd :      out std_logic_vector(15 downto 0)
);
end component;

	component ssegDecoder
	port
	(
		binaryIn	 : in std_logic_vector(3 downto 0);
		ssegOut	 : out std_logic_vector(7 downto 0)
	);
   end component;	


-- Build an enumerated type for the state machine
type state_type is (waitForButtonPush, waitForRelease, delayedReset);

-- Register to hold the current state
signal state : state_type := waitForButtonPush;

signal count : unsigned (11 downto 0) := x"000";
signal bcd :   std_logic_vector(15 downto 0);

begin

dd1 : doubleDabble port map (clk => clk, binaryin => count, bcd => bcd);
ssegOnes : ssegDecoder port map (binaryIn => bcd(3 downto 0), ssegOut => sseg0);
ssegTens : ssegDecoder port map (binaryIn => bcd(7 downto 4), ssegOut => sseg1);
ssegHunds : ssegDecoder port map (binaryIn => bcd(11 downto 8), ssegOut => sseg2);




	process (clk, button, reset)
	variable timer : integer range 0 to 150000000 := 0;
	begin
			if (rising_edge(clk)) then

	-- Determine the next state synchronously, based on

			case state is
				when waitForbuttonpush =>
					if button = '0' then
			state <= waitForRelease;
			count <= count + 1;
			if count >= x"999" then
			count <= x"000";
			end if;
			elsif reset <= '0' then
			state <= delayedReset;
			timer := 0;
			else
			state <= waitForButtonPush;
			end if;

			when waitForRelease =>
			if button = '0' then
			state <= waitForRelease;
			else
			state <= waitForButtonpush;
			end if;
			when delayedReset =>
			if (reset = '0' and timer < 150000000) then
			state <= delayedReset;
			timer := timer + 1;
			elsif (timer >= 150000000) then
			state <= waitForButtonpush;
			count <= x"000";
			timer := 0;
			else
			state <= waitForButtonpush;
			timer := 0;
			end if;

			end case;

			end if;
			end process;
			
end behavioural;