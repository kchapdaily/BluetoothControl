library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Address_LUT is
	Port(
		address		: in std_logic_vector(3 downto 0);
		state_text	: out std_logic_vector(15 downto 0)
	);
end Address_LUT;

architecture Behavioral of Address_LUT is

	signal address_s		: std_logic_vector(3 downto 0) := "0110";
	signal state_text_s	: std_logic_vector(15 downto 0);

begin
	
	address_s	<= address;
	state_text	<= state_text_s;
	
	-- This process takes a four bit logic vector (address) and converts it
	-- into a sixteen bit logic vector (state_text) which contains the four
	-- hex digits to be displayed on the seven segment displays
	convert_address_to_state_text: process (address_s)
	begin
		case address_s is

			when X"0" =>
				state_text_s <= X"A000";
			when X"1" =>
				state_text_s <= X"A100";
			when X"2" =>
				state_text_s <= X"A200";
			when X"3" =>
				state_text_s <= X"A300";
			when X"4" =>
				state_text_s <= X"A400";
			when X"5" =>
				state_text_s <= X"A500";
			when X"6" =>
				state_text_s <= X"A600";
			when X"7" =>
				state_text_s <= X"A700";
			when X"8" =>
				state_text_s <= X"A800";
			when X"9" =>
				state_text_s <= X"A900";
			when others =>	-- This case should not happen
				state_text_s <= X"0000";
		end case;
	end process;

end Behavioral;

