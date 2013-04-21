----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kevin Chapman
-- 
-- Create Date:    22:17:47 04/20/2013 
-- Design Name: 
-- Module Name:    pushbutton_debouncer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pushbutton_debouncer is
port(
	clock : in std_logic;
	bouncy_in : in std_logic;
	non_bouncy_out : out std_logic
	);
end pushbutton_debouncer;

architecture Behavioral of pushbutton_debouncer is
signal count : integer range 0 to 4999;
signal temp : std_logic;

begin
process(clock)
begin
	if rising_edge(clock) then
		temp <= bouncy_in;
		if temp = '1' then
			temp <= temp;
			if count = 4999 then
				non_bouncy_out <= '1';
				count <= 0;
				temp <= '0';
			else
				count <= count + 1;
			end if;
		end if;
	end if;
end process;

end Behavioral;

