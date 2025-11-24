library ieee;
use ieee.std_logic_1164.all;

entity Lecture4 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;  -- asynchronous clear
        set   : in  std_logic;  -- asynchronous seed load
        q_out : out std_logic_vector(4 downto 0)
    );
end entity Lecture4;

architecture structural of Lecture4 is

    component dff
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            set : in  std_logic;
            d   : in  std_logic;
            q   : out std_logic
        );
    end component;

    signal q : std_logic_vector(4 downto 0);  -- q(4)=MSB, q(0)=LSB
    signal d : std_logic_vector(4 downto 0);

begin
    -- Feedback logic for x^5 + x^3 + x^2 + x + 1
    -- new MSB = q(0) XOR q(1) XOR q(2) XOR q(3)
    d(4) <= q(0) xor q(1) xor q(2) xor q(3);

    -- Shift
    d(3) <= q(4);
    d(2) <= q(3);
    d(1) <= q(2);
    d(0) <= q(1);

    -- Instantiate flip-flops
    FF4: dff port map(clk => clk, rst => rst, set => set, d => d(4), q => q(4));
    FF3: dff port map(clk => clk, rst => rst, set => set, d => d(3), q => q(3));
    FF2: dff port map(clk => clk, rst => rst, set => set, d => d(2), q => q(2));
    FF1: dff port map(clk => clk, rst => rst, set => set, d => d(1), q => q(1));
    FF0: dff port map(clk => clk, rst => rst, set => set, d => d(0), q => q(0));

    -- output to LEDs or further logic
    q_out <= q;
	 
	 
	 
	 

end architecture structural;
