library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Seven_Seg_Display_Hex_Digit_Decoder is
Port(
	hex_digit				: in std_logic_vector(3 downto 0);
	seven_seg_cathodes	: out std_logic_vector(7 downto 0)
);
end Seven_Seg_Display_Hex_Digit_Decoder;

architecture Behavioral of Seven_Seg_Display_Hex_Digit_Decoder is

begin

	convert_hex_to_seven_seg: process(hex_digit)
	begin
		case hex_digit is
			when X"0" =>
				seven_seg_cathodes <= "11000000";	-- 0
			when X"1" =>
				seven_seg_cathodes <= "11111001";	-- 1
			when X"2" =>
				seven_seg_cathodes <= "10100100";	-- 2
			when X"3" =>
				seven_seg_cathodes <= "10110000";	-- 3
			when X"4" =>
				seven_seg_cathodes <= "10011001";	-- 4
			when X"5" =>
				seven_seg_cathodes <= "10010010";	-- 5
			when X"6" =>
				seven_seg_cathodes <= "10000010";	-- 6
			when X"7" =>
				seven_seg_cathodes <= "11111000";	-- 7
			when X"8" =>
				seven_seg_cathodes <= "10000000";	-- 8
			when X"9" =>
				seven_seg_cathodes <= "10010000";	-- 9
			when X"A" =>
				seven_seg_cathodes <= "10001000";	-- Capital A
			when X"B" =>
				seven_seg_cathodes <= "10000011";	-- Lower-case B
			when X"C" =>
				seven_seg_cathodes <= "11000110";	-- Capital C
			when X"D" =>
				seven_seg_cathodes <= "10100001";	-- Lower-case D
			when X"E" =>
				seven_seg_cathodes <= "10000110";	-- Capital E
			when X"F" =>
				seven_seg_cathodes <= "10001110";	-- Capital F
			when others =>	-- This case should never happen
				seven_seg_cathodes <= "10110000";	-- Question Mark
		end case;
	end process;

end Behavioral;
