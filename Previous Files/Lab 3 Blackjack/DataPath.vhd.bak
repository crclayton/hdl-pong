LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

Entity DataPath IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		newPlayerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		newDealerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);

		playerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --- player’s hand
		dealerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --— dealer’s hand

		dealerStands : OUT STD_LOGIC; -- true if dealerScore >= 17

		playerWins : OUT STD_LOGIC; -- true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins : OUT STD_LOGIC; --- true if dealerScore >= playerScore AND dealerScore <= 21

		playerBust : OUT STD_LOGIC; -- true if playerScore > 21
		dealerBust : OUT STD_LOGIC  -- true if dealerScore > 21
	);
	END DataPath;
	
ARCHITECTURE Behavioural of DataPath is 

	COMPONENT dealhand is 
		port(
				clk : in std_logic;
				user_input : in std_logic;
				hand : OUT STD_LOGIC_VECTOR(3 downto 0)
			);
	end component;
	
	COMPONENT scorehand is
		port(
	  
				hand : IN std_LOGIC_VECTOR(15 DOWNTO 0); 
				score : OUT std_LOGIC_VECTOR(4 downto 0)
			 );		
	end component;
	
	signal user_input : STD_LOGIC;
	signal playerhand : std_LOGIC_VECTOR(15 DOWNTO 0 );
	signal dealerhand : std_LOGIC_VECTOR(15 DOWNTO 0 );
	signal hand 		: std_lOGIC_VECTOR(3 DOWNTO 0);
	signal playerScore: std_LOGIC_VECTOR(4 DOWNTO 0);
	signal dealerScore: std_LOGIC_VECTOR(4 DOWNTO 0);
	signal players: STD_LOGIC;
	signal flag : STD_LOGIC;
begin 
		
		dealhand1: dealhand	
			port map ( clock, user_input, hand);
		playerscorehand: scorehand
			port map ( playerHand, playerScore); --changed from playerhand etc.
		dealerscorehand: scorehand
			port map ( dealerHand, dealerScore);
				
		
		--led(3 downto 0 ) <= newPlayerCard;
		--led(7 downto 4 ) <= hand;

	-- if player card changes or dealer card changes a new card is dealt 
	process ( clock, reset  )
		variable d, p : std_LOGIC_VECTOR( 3 DowNTO 0 ):= "0000"; 
		begin 
		if reset = '0' then 
			d := "0000"; 
			p := "0000"; 
			
		elsif rising_edge (clock) then 
			if not (newPlayerCard = p) then
				p:= newPlayerCard; 
				user_input <= '1'; -- stops random counter to read card
				flag <= '0'; --determines hand writes to playerscadrs
				
			elsif not (newDealerCard = d) then 
				d:= newDealerCard; 
				user_input <= '1';
				flag <= '1';  -- hand writes to dealers cards
			else
				user_input <= '0'; --starts random counter again 
				
			end if;
		end if; 
		end process; 
		
	-- deals cards and saves then in Cards 16 bit 	
	process( clock, reset )
		variable i : std_LOGIC;
		begin 
			if reset = '0' then 
				dealerHand <= x"0000";
				playerHand <= x"0000";
			elsif rising_edge(clock )then 
				if flag = '0' then
					case newPlayerCard is 
						when "0001" => playerHand(3 DOWNTO 0) <= hand;
						when "0010" => playerHand(7 DOWNTO 4) <= hand;
						when "0100" => playerHand(11 DOWNTO 8) <= hand; 
						when "1000" => playerHand(15 DOWNTO 12) <= hand;
						when others => playerHand(15 DOWNTO 0) <= x"0000";					
					end case;
				else 
					case newDealerCard is 
						when "0001" => dealerHand(3 DOWNTO 0) <= hand; 
						when "0010" => dealerHand(7 DOWNTO 4) <= hand;
						when "0100" => dealerHand(11 DOWNTO 8) <= hand;
						when "1000" => dealerHand(15 DOWNTO 12) <= hand;
						when others => dealerHand(15 DOWNTO 0) <= x"0000";
					end case;
				end if; 
			end if;
		end process;
		
		dealerCards <= dealerHand;
		playerCards <= playerHand;
		
		
		-- see if these values are being sent through
		process(clock)
			variable pbust : std_LOGIC := '0';
			variable dbust : std_logic := '0';
			variable pwin  : std_logic := '0';
			variable dwin  : std_LOGIC := '0';
			variable dstand :std_LOGIC := '0';
		begin
			if rising_edge(clock) then
				--pbust := '0';
				--dbust := '0';
				--pwin  := '0';
				--dwin  := '0';
				--dstand := '0';
				
				if to_integer(unsigned(dealerScore)) > 21 then
					pwin := '1';
					dbust := '1';
				else
					pwin := '0';
					dbust := '0';
				end if;
				
				if to_integer(unsigned(playerScore)) > 21 then
					dwin := '1';
					pbust := '1';
				else
					dwin := '0';
					pbust := '0';
				end if;
				
				if pbust = '0' and dbust = '0' then 

					if playerScore > dealerScore then 
						pwin := '1';
					else 
						dwin := '1';
					end if;
				
				end if;
				

				if to_integer(unsigned(dealerScore)) >= 17 then 
					dstand := '1';
				else
					dstand := '0';
				end if;
				
				playerBust <= pbust;
				dealerBust <= dbust;
				playerWins <= pwin;
				dealerWins <= dwin;
				dealerStands <= dstand;
					
				-- get playerStand from switch input at FSM
			end if; -- for clk
		end process;
end Behavioural; 
	
	