----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:46:47 04/13/2013 
-- Design Name: 
-- Module Name:    bluetoothControlTL - Behavioral 
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

entity bluetoothControlTL is
port(
	clock 				: in std_logic;
	fromPC				: in std_logic;
	reset					: in std_logic;
	ndts_button			: in std_logic;
	slide_switches		: in std_logic_vector(7 downto 0);
	toPC 					: out std_logic;
	seven_seg_an		: out std_logic_vector(3 downto 0);
	seven_seg_cath 	: out std_logic_vector(7 downto 0)
	);	
end bluetoothControlTL;

architecture Behavioral of bluetoothControlTL is
signal txcount : integer range 0 to 5207;
signal rxcount : integer range 0 to 83332;
signal recieve_reg, transmit_reg, data_to_send, data_recieved : std_logic_vector(7 downto 0);
signal txclkw, tx_emptyw, rxclkw, ld_tx_dataw, uld_rx_dataw, rx_emptyw, new_data_to_send : std_logic;
--signal to_seven_seg : std_logic_vector(15 downto 0);
signal to_seven_seg : std_logic_vector(3 downto 0);

component uart is
    port (
        reset       :in  std_logic;
        txclk       :in  std_logic;
        ld_tx_data  :in  std_logic;
        tx_data     :in  std_logic_vector (7 downto 0);
        tx_enable   :in  std_logic;
        tx_out      :out std_logic;
        tx_empty    :out std_logic;
        rxclk       :in  std_logic;
        uld_rx_data :in  std_logic;
        rx_data     :out std_logic_vector (7 downto 0);
        rx_enable   :in  std_logic;
        rx_in       :in  std_logic;
        rx_empty    :out std_logic
    );
end component;

component Display_To_Nexys3_SSD is
	Port(
		clk						: in std_logic;
		Turns_Left_from_Java	: in std_logic_vector (3 downto 0);
		active_an				: out std_logic_vector (3 downto 0);
		active_cath				: out std_logic_vector (7 downto 0)
	);
end component;

begin
new_data_to_send <= ndts_button;
data_to_send <= slide_switches;

--transmit_clock
process(clock)
begin
	if rising_edge(clock) then
		if txcount = 5207 then --9600 baud
			txclkw <= not txclkw;
			txcount <= 0;
		else
			txcount <= txcount + 1;
		end if;
	end if;
end process;

--recieve_clock
process(clock)
begin
	if rising_edge(clock) then
		if rxcount = 83332 then --16x9600 baud
			rxclkw <= not rxclkw;
			rxcount <= 0;
		else
			rxcount <= rxcount + 1;
		end if;
	end if;
end process;

--transmiting data
process(txclkw)
begin
	if rising_edge(txclkw) then
		if tx_emptyw = '1' and new_data_to_send = '1' then
			ld_tx_dataw <= '1';
			transmit_reg <= data_to_send;
		else
			ld_tx_dataw <= '0';
		end if;
	end if;
end process;	

--recieving data
process(rxclkw)
begin
	if rising_edge(rxclkw) then
		if rx_emptyw = '0' then
			case recieve_reg is
				when x"30" => to_seven_seg <= x"0";
				when x"31" => to_seven_seg <= x"1";
				when x"32" => to_seven_seg <= x"2";
				when x"33" => to_seven_seg <= x"3";
				when x"34" => to_seven_seg <= x"4";
				when x"35" => to_seven_seg <= x"5";
				when x"36" => to_seven_seg <= x"6";
				when x"37" => to_seven_seg <= x"7";
				when x"38" => to_seven_seg <= x"8";
				when x"39" => to_seven_seg <= x"9";
				when others=> to_seven_seg <= "0000";
			end case;
			
			uld_rx_dataw <= '1';
		else
			uld_rx_dataw <= '0';
		end if;
	end if;
end process;

inst_uart:uart
port map(
	reset => reset,
	txclk => txclkw, 
	ld_tx_data => ld_tx_dataw,
	tx_data => transmit_reg,
	tx_enable => '1',
	tx_out => toPC,
	tx_empty => tx_emptyw,
	rxclk => rxclkw,
	uld_rx_data => uld_rx_dataw,
	rx_data => recieve_reg,
	rx_enable => '1',
	rx_in => fromPC,
	rx_empty => rx_emptyw
	);
	
inst_display:Display_To_Nexys3_SSD
port map(
	clk => clock,
	Turns_Left_from_Java => to_seven_seg,
	active_an => seven_seg_an,
	active_cath => seven_seg_cath
	);

end Behavioral;

