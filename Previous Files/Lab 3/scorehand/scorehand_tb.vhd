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
	  hand <= x"0a11";
	  wait for 10 ns; 
	  hand <= x"1111";
	  wait for 10 ns; 
	  hand <= x"0111";
	  wait for 10 ns; 
	  hand <= x"0AA1";
	  wait for 10 ns; 
	  hand <= x"0a11";
	  wait for 10 ns; 
	  hand <= x"0089";
	  wait for 10 ns; 
	  hand <= x"7777";
	  wait for 10 ns; 
	  hand <= x"9857";
	  wait for 10 ns; 
	  hand <= x"0a11";
	  wait for 10 ns; 
	  hand <= x"dc11";
	  wait for 10 ns; 
	  hand <= x"00a8";
	  wait for 10 ns; 
	  hand <= x"5555";
	  wait for 10 ns;
	  	  hand <= x"1188";
	  wait for 10 ns; 
	  hand <= x"8888";
	  wait for 10 ns; 
	  hand <= x"1119";
	  wait for 10 ns; 
	  hand <= x"1919";
	  wait for 10 ns;  
	     
	    end process;
	  end rtl;  