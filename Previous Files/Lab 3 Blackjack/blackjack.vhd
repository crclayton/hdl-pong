LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY BlackJack IS
	PORT(
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
END;


ARCHITECTURE Behavioural OF BlackJack IS

	COMPONENT Card7Seg IS
	PORT(
	   	card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- value of card
	   	seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- 7-seg LED pattern
	);
	END COMPONENT;

	COMPONENT DataPath IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		newPlayerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		newDealerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);

		playerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --—- player’s hand
		dealerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); ---— dealer’s hand

		dealerStands : OUT STD_LOGIC; --—- true if dealerScore >= 17

		playerWins : OUT STD_LOGIC;-- —- true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins : OUT STD_LOGIC; --—- true if dealerScore >= playerScore AND dealerScore <= 21

		playerBust : OUT STD_LOGIC; --—- true if playerScore > 21
		dealerBust : OUT STD_LOGIC  --—- true if dealerScore > 21
	);
	END COMPONENT;

	COMPONENT FSM IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		nextStep     : IN STD_LOGIC;-- —- when true, it advances game to next step
		playerStands : IN STD_LOGIC; --—- true if player wants to stand
		dealerStands : IN STD_LOGIC; --—- true if dealerScore >= 17
		playerWins   : IN STD_LOGIC; --—- true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins   : IN STD_LOGIC; --—- true if dealerScore >= playerScore AND dealerScore <= 21
		playerBust   : IN STD_LOGIC; --—- true if playerScore > 21
		dealerBust   : IN STD_LOGIC;  --—- true if dealerScore > 21

		newPlayerCard : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		newDealerCard : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

		redLEDs   : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		greenLEDs : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT;


	signal newPlayerCard : std_LOGIC_VECTOR( 3 downto 0); 
	signal newDealerCard : STD_LOGIC_VECTOR ( 3 DOWNTO 0 ); 
	signal dealerStands  : STD_LOGIC; 
	signal dealerWins    : STD_LOGIC; 
	signal playerWins    : STD_LOGIC; 
	signal dealerBust    : STD_LOGIC; 
	signal playerBust    : STD_LOGIC;
	signal playerCards	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal dealerCards	: STD_LOGIC_VECTOR (15 DOWNTO 0);	
	
BEGIN
	-- player's cards 
	playerCard_1: card7Seg
		port map( playerCards(3 DOWNTO 0), HEX0 );
	playerCard_2: card7Seg
		port map(playerCards(7 DOWNTO 4), HEX1);
	playerCard_3: card7Seg
		port map(playerCards(11 DOWNTO 8), HEX2);
	playerCard_4: card7Seg
		port map(playerCards(15 DOWNTO 12), HEX3);
		
	-- dealer's cards
	dealerCard_1: card7Seg
		port map( dealerCards(3 DOWNTO 0), HEX4);
	dealerCard_2: card7Seg
		port map( dealerCards(7 DOWNTO 4), HEX5);
	dealerCard_3: card7Seg
		port map( dealerCards(11 DOWNTO 8), HEX6);
	dealerCard_4: card7Seg
		port map( dealerCards(15 DOWNTO 12), HEX7);
	
	-- datapath and state machine inputs
	Data_Path: DataPath
		port map( CLOCK_50, KEY(3), newPlayerCard, newDealerCard, playerCards, dealerCards, dealerStands, playerWins, dealerWins, playerBust, dealerBust);
	F_SM: FSM
		port map( CLOCK_50, KEY(3), KEY(0), SW(0), dealerStands, playerWins, dealerWins, playerBust, dealerBust, newPlayerCard, newDealerCard, LEDR, LEDG);

END Behavioural;

