LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity Ring_Counter is
	Port (
		clk				: in std_logic;
		clk_en 			: in std_logic;
		oh_ring_state	: out std_logic_vector(3 downto 0);	-- One-hot ring state
		ring_state		: out std_logic_vector(1 downto 0)
	);
end Ring_Counter;

architecture state_machine of Ring_Counter is
	type stateType is (A, B, C, D);
	signal CS	: stateType := A;
	signal NS	: stateType := B;

begin

	state_machine: process(clk, clk_en)
	begin
		if rising_edge(clk) and clk_en = '1' then
			CS <= NS;
		end if;
	end process;

	Comb_logic: process(CS)
	begin
		ring_state <= "00";

		case CS is
			when A =>
				ring_state		<= "00";
				oh_ring_state	<= "1110";
				NS <= B;
			when B =>
				ring_state		<= "01";
				oh_ring_state	<= "1101";
				NS <= C;
			when C =>
				ring_state		<= "10";
				oh_ring_state	<= "1011";
				NS <= D;
			when D =>
				ring_state		<= "11";
				oh_ring_state	<= "0111";
				NS <= A;
		end case;
	end process;

-- State Mapping
--		CS		NS		ring_state	oh_ring_state
-- ------------------------------------------
--		A		B			"00"			"0001"
--		B		C			"01"			"0010"
--		C		D			"10"			"0100"
--		D		A			"11"			"1000"

end state_machine;
