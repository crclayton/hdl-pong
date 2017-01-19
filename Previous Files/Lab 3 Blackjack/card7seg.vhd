library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity card7seg is
  port(
	   	card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- value of card
	   	seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- 7-seg LED pattern
		 );
end card7seg;

architecture card7seg_behavioural of card7seg  is
begin

  WITH card SELECT  
  
            --gfedcba and inverted
    seg7 <=  "1111111" WHEN "0000", -- no cards, all off
             "0001000" WHEN "0001", -- A for ace
             "0100100" WHEN "0010", -- 2
             "0110000" WHEN "0011", -- 3
			 "0011001" WHEN "0100", -- 4
			 "0010010" WHEN "0101", -- 5
			 "0000010" WHEN "0110", -- 6
			 "1111000" WHEN "0111", -- 7
			 "0000000" WHEN "1000", -- 8
			 "0010000" WHEN "1001", -- 9
			 "1000000" WHEN "1010", -- 10
			 "1100001" WHEN "1011", -- J for jack
			 "0011000" WHEN "1100", -- q for queen
			 "0001001" WHEN "1101",	-- H for king	   
             "0000110" WHEN OTHERS; -- E for error
				 
end card7seg_behavioural;