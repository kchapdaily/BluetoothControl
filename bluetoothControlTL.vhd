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
	clock 		: in std_logic;
	fromPC		: in std_logic;
	reset			: in std_logic;
	toPC 			: out std_logic
	);	
end bluetoothControlTL;

architecture Behavioral of bluetoothControlTL is
signal recieve_reg, transmit_reg, data_to_send, data_recieved : std_logic_vector(7 downto 0);
signal txclkw, tx_emptyw, rxclkw, ld_tx_dataw, uld_rx_dataw, rx_emptyw, new_data_to_send : std_logic;

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

begin

transmit_clock:process(clock)
variable count : integer range 0 to 10416;
begin
	if rising_edge(clock) and count = 5207 then --9600 baud
		txclkw <= not txclkw;
		count := 0;
	else
		count := count + 1;
	end if;
end process transmit_clock;

recieve_clock:process(clock)
variable count : integer range 0 to 83332;
begin
	if rising_edge(clock) and count = 5207 then --16x9600 baud
		rxclkw <= not rxclkw;
		count := 0;
	else
		count := count + 1;
	end if;
end process recieve_clock;

--transmiting data
process(txclkw)
begin
	new_data_to_send <= '1'; --temporarily high for testing
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
		if rx_emptyw = '1' then
			data_recieved <= recieve_reg;
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

end Behavioral;

