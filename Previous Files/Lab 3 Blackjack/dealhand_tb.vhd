library ieee;
use ieee.std_logic_1164.all;

entity dealhand_tb is 
end dealhand_tb;

 

architecture rtl of dealhand_tb is
	component dealHand 
		port(
			clk : in std_logic;
			user_input : in std_logic;
	   	hand : OUT STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;

			signal clk : std_logic;
			signal user_input : std_logic;
	   	signal hand : STD_LOGIC_VECTOR(3 downto 0);
	    
	    
	begin

	  dut1 : dealhand port map(clk, user_input, hand); 
	  
	  clk_gen : process 
	  constant PERIOD : TIME := 20 ns;
	  begin 
	     clk <= '1'; 
	     wait for 10 ns;
	     clk <= '0';
	     wait for 10 ns;  
	    end process; 
	    
	  keypress : process
	    begin 
	      
	         user_input <= '1'; 
	         wait for 10 ns; 
	         user_input <= '0';
	         wait for 10 ns;  
	         user_input <= '1'; 
	         wait for 20 ns; 
	         user_input <= '0';
	         wait for 20 ns;
	         
	        
	      
	      
	    end process;
	  end rtl; 