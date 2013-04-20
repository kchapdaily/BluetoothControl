library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sixteen_Bit_Multiplexer is
Port(
	state_text				: in std_logic_vector(15 downto 0);
	ring_state				: in std_logic_vector(1 downto 0);
	char_to_be_displayed	: out std_logic_vector(3 downto 0)
);
end Sixteen_Bit_Multiplexer;

architecture Behavioral of Sixteen_Bit_Multiplexer is

	-- No signals needed

begin

	extract_char: process (ring_state, state_text)
	begin
		case ring_state is
			when "00" =>	-- Fourth digit
				char_to_be_displayed <= state_text(3 downto 0);
			when "01" =>	-- Third digit
				char_to_be_displayed <= state_text(7 downto 4);
			when "10" =>	-- Second digit
				char_to_be_displayed <= state_text(11 downto 8);
			when "11" =>	-- First digit
				char_to_be_displayed <= state_text(15 downto 12);
			when others =>	-- This should never happen
				char_to_be_displayed <= X"6";
		end case;
	end process;

end Behavioral;
