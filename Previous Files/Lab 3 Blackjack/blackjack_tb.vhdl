library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blackjack_tb is 
end blackjack_tb;

architecture rtl of blackjack_tb is
	component blackjack 
		port(
		  
		CLOCK_50 : in std_logic; -- A 50MHz clock
	   	SW   : in  std_logic_vector(17 downto 0); -- SW(0) = player stands
			KEY  : in  std_logic_vector(3 downto 0);  -- KEY(3) reset, KEY(0) advance
	   	LEDR : out std_logic_vector(17 downto 0); -- red LEDs: dealer wins
	   	LEDG : out std_logic_vector(7 downto 0);  -- green LEDs: player wins

	   	HEX7 : out std_logic_vector(6 downto 0);  -- dealer, fourth card
	   	HEX6 : out std_logic_vector(6 downto 0);  -- dealer, third card
	   	HEX5 : out std_logic_vector(6 downto 0);  -- dealer, second card
	   	HEX4 : out std_logic_vector(6 downto 0);   -- dealer, first card

	   	HEX3 : out std_logic_vector(6 downto 0);  -- player, fourth card
	   	HEX2 : out std_logic_vector(6 downto 0);  -- player, third card
	   	HEX1 : out std_logic_vector(6 downto 0);  -- player, second card
	   	HEX0 : out std_logic_vector(6 downto 0)   -- player, first card
	   	);
	   	
	   	