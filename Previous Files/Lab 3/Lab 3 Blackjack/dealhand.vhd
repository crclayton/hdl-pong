library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions


entity dealHand is
  port(
			clk : in std_logic;
			user_input : in std_logic;
	   	hand : OUT std_logic_vector(3 downto 0)
		 );
end dealHand;

architecture dealHand_behavioural of dealhand  is
begin

	process(clk)
	variable random_counter : unsigned(3 downto 0) := "0000"; 
	begin
		if rising_edge(clk) then
			if user_input = '0' then 
				if random_counter < 1 or random_counter >= 13 then
					random_counter := "0001";
				else 
					random_counter := random_counter + "0001";
				end if;
			
			else
				hand <= std_logic_vector(random_counter);
			end if;
			
		end if; -- rising edge
	end process;
	
	
end dealhand_behavioural;