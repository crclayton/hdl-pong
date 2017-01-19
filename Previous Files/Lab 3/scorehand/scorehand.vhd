library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scorehand is
  port(
	   	hand : IN std_logic_vector(15 DOWNTO 0); 
	   	score : OUT std_LOGIC_VECTOR(4 downto 0);
	   	stand : OUT std_logic; 
	   	bust  : out std_logic
		);
end scorehand;

architecture scorehand_behavioural of scorehand  is

begin
	process(hand)
		variable c1 : unsigned(5 downto 0) := "000000";
		variable c2 : unsigned(5 downto 0) := "000000";
		variable c3 : unsigned(5 downto 0) := "000000";
		variable c4 : unsigned(5 downto 0) := "000000";
		
		variable score_temp : unsigned(5 downto 0) := "000000";
	begin
			
			c1(3 downto 0) := unsigned(hand(15 downto 12));
			c2(3 downto 0) := unsigned(hand(11 downto 8));
			c3(3 downto 0) := unsigned(hand(7 downto 4));
			c4(3 downto 0) := unsigned(hand(3 downto 0));
      
      			-- set face cards to 10
			if c1 = "001011" or c1 = "001100" or c1 = "001101"  then
				c1 := "001010";
			end if;
			
			if c2 = "001011" or c2 = "001100" or c2 = "001101"  then
				c2 := "001010";
			end if;
			
			if c3 = "001011" or c3 = "001100" or c3 = "001101"  then
				c3 := "001010";
			end if;
			
			if c4 = "001011" or c4 = "001100" or c4 = "001101"  then
				c4 := "001010";
			end if;
			
			-- set any aces to 11 by default
			if c1 = "000001" then
				c1 := "001011";
			end if;

			if c2 = "000001" then
				c2 := "001011";
			end if;
			
			if c3 = "000001" then
				c3 := "001011";
			end if;
			
			if c4 = "000001" then
				c4 := "001011";
			end if;
	


	
			-- if we've busted, reduce any aces until we're below 21
			score_temp :=  c1 + c2 + c3 + c4; 
			if c1 = "001011" and to_integer(score_temp) > 21 then
				c1 := "000001";
			end if;
	
			score_temp :=  c1 + c2 + c3 + c4; 
			if c2 = "001011" and to_integer(score_temp) > 21 then
				c2 := "000001";
			end if;
				
			score_temp :=  c1 + c2 + c3 + c4; 
			if c3 = "001011" and  to_integer(score_temp) > 21 then
				c3 := "000001";
			end if;
				
			score_temp :=  c1 + c2 + c3 + c4; 
			if c4 = "001011" and  to_integer(score_temp) > 21 then
				c4 := "000001";
			end if;
		
			score_temp :=  c1 + c2 + c3 + c4; 
			
			if to_integer(score_temp) > 21 then 
	--		  score_temp:= "111111"; 
			  bust <= '1';
			elsif to_integer(score_temp) >= 17 then 
			   stand <= '1'; 
			else 
			   stand <= '0'; 
			   bust <= '0';
			 end if; 
			 		
			score <= std_LOGIC_VECTOR(score_temp(4 downto 0));
	
	end process;
end scorehand_behavioural;