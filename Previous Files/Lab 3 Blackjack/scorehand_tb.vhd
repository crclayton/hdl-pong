library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scorehand_tb is 
end scorehand_tb;

 

architecture rtl of scorehand_tb is
	component scorehand 
		port(
  
	   	hand : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
			
	   	score : OUT std_LOGIC_VECTOR(4 downto 0);
			stand : OUT std_logic; 
	   	bust  : out std_logic

		);
	end component;

  
	   	signal hand : STD_LOGIC_VECTOR(15 DOWNTO 0); 			
	   	signal score :  std_LOGIC_VECTOR(4 downto 0); 			
			signal bust  :  std_logic;
			signal stand  : std_logic;     
	    
	begin

	  dut : scorehand port map(hand, score, stand, bust); 
	  
	  hand_in : process 
	  
	  begin 
	  hand <= x"3333";
	  wait for 10 ns; 
	  hand <= x"5544";
	  wait for 10 ns; 
	  hand <= x"2424";
	  wait for 10 ns; 
	  hand <= x"5554";
	  wait for 10 ns; 
	  hand <= x"3333";
	  wait for 10 ns; 
	  hand <= x"5555";
	  wait for 10 ns; 
	  hand <= x"4444";
	  wait for 10 ns; 
	  hand <= x"5566";
	  wait for 10 ns; 
	  hand <= x"4433";
	  wait for 10 ns; 
	  hand <= x"5555";
	  wait for 10 ns; 
	  hand <= x"7788";
	  wait for 10 ns; 
	  hand <= x"5554";
	  wait for 10 ns;
	  	  hand <= x"7766";
	  wait for 10 ns; 
	  hand <= x"5544";
	  wait for 10 ns; 
	  hand <= x"8888";
	  wait for 10 ns; 
	  hand <= x"5534";
	  wait for 10 ns;  
	     
	    end process;
	  end rtl;  