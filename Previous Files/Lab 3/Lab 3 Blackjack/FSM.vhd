LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FSM IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		nextStep     : IN STD_LOGIC; --—- when true, it advances game to next step
		playerStands : IN STD_LOGIC; --—--- true if player wants to stand
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
	end FSM;
	
Architecture Behavioural of FSM is 
	
		type state_type is (Start, PlayerTurn, DealerTurn, Winner, DealerWin, PlayerWin, EndGame);
		signal state   : state_type;
		signal step		: STD_LOGIC;
		signal pcards	: STD_LOGIC_VECTOR(2 DOWNTO 0);
		signal dcards	: STD_LOGIC_VECTOR(2 DOWNTO 0);
begin 

	-- Logic to advance to the next step
	process(clock)
		variable i : std_LOGIC := '0';
		begin 
		
		-- this is to give step a single pulse 
		-- whenever key(0) is pressed
		if rising_edge(clock ) then 
			if i = '0' then 
				if   nextStep = '0' then 
					step <=  '1';
					i := '1';
				else 
					step <= '0';
				end if; 
			else 
				if nextStep = '1' then 
					i := '0';
				end if; 
				step <= '0';
				
			end if; 
		end if; 
	end process; 
		
	
	process (clock, reset)
	variable pcard	: unsigned (2 DOWNTO 0):="000";
	variable dcard	: unsigned (2 DOWNTO 0):="000";
	begin
		if reset = '0' then
			state <= Start;
			pcard := "000"; 
			dcard := "000";
			newDealerCard <= "0000";
			newPlayerCard <= "0000";
			redLEDs(17) <= '0';
			redLEDs(16) <= '0';
			redLEDs(15 downto 8 ) <= x"00";

		elsif (rising_edge(clock)) then
			case state is
				when Start=>
					--state progression logic
					if Step = '1' then
						state <= PlayerTurn;
						pcard := pcard + "001"; -- player and dealer card = 1
						dcard := dcard + "001";
					else
						state <= Start;
						--execute state 
						--greenLEDs<="00000000";
					end if;
					

					
				when PlayerTurn=>
				--state progression logic

					-- don't deal to player if they're standing
					if  Step = '1' and playerStands = '0' then --pcard < "100" AND
						pcard := pcard + "001";
						state <= DealerTurn;
					elsif dealerBust = '1' or playerBust = '1' or (playerStands = '1' and dealerStands = '1') or (to_integer(dcard) = 5) then
						state <= winner;
					
					
					-- skip straight to dealer turn
					elsif playerStands = '1' then
						state <= DealerTurn;
					

					else
					--execute state 
						state <= PlayerTurn;
						
						--greenLEDs<="00000011";
						case pcards is 
							when "000"=> newPlayerCard <= "0000";
							when "001"=> newPlayerCard <= "0001";
							when "010"=> newPlayerCard <= "0010";
							when "011"=> newPlayerCard <= "0100";
							when others=> newPlayerCard <= "1000";
						end case;
					end if;
					
				when DealerTurn =>
				--state progression logic
					if to_integer(dcard) <= 4 and Step = '1' and dealerStands = '0' then
						dcard := dcard + "001";
						state <= PlayerTurn;
					elsif dealerBust = '1' or playerBust = '1' or (playerStands = '1' and dealerStands = '1') or to_integer(dcard) = 5 then
						state <= winner;
						
					elsif dealerStands = '1' then
						state <= PlayerTurn;
					

					else
					--execute state 
						state <= DealerTurn;
						
						--greenLEDs<="00000100";
						case dcards is 
							when "000"=> newDealerCard <= "0000";
							when "001"=> newDealerCard <= "0001";
							when "010"=>	newDealerCard <= "0010";
							when "011"=> newDealerCard <= "0100";
							when others=>	newDealerCard <= "1000";
						end case;
					end if;
					
				when Winner =>
				--state progression logic
--					if PlayerWins <= '1' then 
--						state <= PlayerWin; 
--					elsif dealerWins = '1' then
--						state <= DealerWin;
					redLEDs(15 downto 8 ) <= x"7e"; 
					--else
					--execute state 
					redLEDs(17) <= dealerWins;
					redLEDs(16) <= playerWins;
						state <= Winner;
					--end if;
					
				when DealerWin =>
				--state progression logic
					if Step = '1' then
						state <= EndGame;
					else
					--execute state 
						redLEDs(17) <= dealerWins;
						state <= DealerWin;
					end if;
					
				when PlayerWin =>
				--state progression logic
					if Step = '1' then
						state <= EndGame;
					else
					--execute state 
						state <= PlayerWin;
						redLEDs(16) <= playerWins;
						
					end if;
					
				when others =>
						state <= EndGame;
					
					
			end case;
		end if;
		
		pcards <= std_LOGIC_VECTOR(pcard);
		dcards <= std_LOGIC_VECTOR(dcard);
	end process;

	-- monitor states w/ LEDS 
	greenLEDs(7) <= playerWins;  
	greenLEDs(6) <= playerBust; 
	greenLEDs(5) <= playerStands;

	redLEDs(7) <= dealerWins;  
	redLEDs(6) <= dealerBust; 
	redLEDs(5) <= dealerStands;
		
	
end Behavioural; 
