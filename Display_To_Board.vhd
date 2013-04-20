library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Display_To_Board is
Port(
	clock_100M	: in std_logic;
	state_text	: in std_logic_vector(15 downto 0);
	active_an	: out std_logic_vector(3 downto 0);
	active_cath	: out std_logic_vector(7 downto 0)
);
end Display_To_Board;

architecture Behavioral of Display_To_Board is
	-- --------------
	--   COMPONENTS
	-- --------------
	component ClockEnabler
	generic(
		max_count : integer
	);
	port(
		clock		: in std_logic;
		reset		: in std_logic;
		enable	: out std_logic
	);
	end component;
	
	component Ring_Counter
	port (
		clk				: in std_logic;
		clk_en 			: in std_logic;
		oh_ring_state	: out std_logic_vector(3 downto 0);
		ring_state		: out std_logic_vector(1 downto 0)
	);
	end component;
	
	component Sixteen_Bit_Multiplexer
	port(
		state_text				: in std_logic_vector(15 downto 0);
		ring_state				: in std_logic_vector(1 downto 0);
		char_to_be_displayed	: out std_logic_vector(3 downto 0)
	);
	end component;
	
	component Seven_Seg_Display_Hex_Digit_Decoder
	port(
		hex_digit				: in std_logic_vector(3 downto 0);
		seven_seg_cathodes	: out std_logic_vector(7 downto 0)
	);
	end component;
	
	-- -----------
	--   SIGNALS
	-- -----------
	signal clk_en_s		: std_logic;
	signal ring_state_s	: std_logic_vector(1 downto 0);
	signal hex_digit_s	: std_logic_vector(3 downto 0);

begin

	Clk_Enabler_100MHz_to_1KHz: ClockEnabler generic map(
		max_count	=> 99999	-- Go from 100MHz to 1KHz
	)
	port map(
		clock			=> clock_100M,
		reset			=> '0',	-- reset is LOW because this clock runs continuously
		enable		=> clk_en_s
	);
	
	Inst_Ring_Counter: Ring_Counter port map(
		clk				=> clock_100M,
		clk_en			=> clk_en_s,
		oh_ring_state	=> active_an,
		ring_state		=> ring_state_s
	);
	
	Inst_16_bit_MUX: Sixteen_Bit_Multiplexer port map(
		state_text				=> state_text,
		ring_state				=> ring_state_s,
		char_to_be_displayed => hex_digit_s
	);
	
	Inst_Decoder: Seven_Seg_Display_Hex_Digit_Decoder port map(
		hex_digit				=> hex_digit_s,
		seven_seg_cathodes	=> active_cath
	);

end Behavioral;
