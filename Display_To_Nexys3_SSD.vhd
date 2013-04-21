library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Display_To_Nexys3_SSD is
	Port(
		clk						: in std_logic;
		Turns_Left_from_Java	: in std_logic_vector (3 downto 0);
		active_an				: out std_logic_vector (3 downto 0);
		active_cath				: out std_logic_vector (7 downto 0)
	);
end Display_To_Nexys3_SSD;

architecture Behavioral of Display_To_Nexys3_SSD is

	component Address_LUT
	port(
		address		: in std_logic_vector(3 downto 0);
		state_text	: out std_logic_vector(15 downto 0)
	);
	end component;
	
	component Display_To_Board
	port(
		clock_100M	: in std_logic;
		state_text	: in std_logic_vector(15 downto 0);
		active_an	: out std_logic_vector(3 downto 0);
		active_cath	: out std_logic_vector(7 downto 0)
	);
	end component;
	
	-- Signals
	signal state_text_s	: std_logic_vector(15 downto 0);

	
begin

	Inst_Address_LUT: Address_LUT port map (
		address		=> Turns_Left_from_Java,
		state_text	=> state_text_s
	);
	
	Inst_Display_to_board : Display_To_Board port map(
		clock_100M	=> clk,
		state_text	=> state_text_s,
		active_an	=> active_an,
		active_cath	=> active_cath
	);

end Behavioral;

