library ieee;
use ieee.std_logic_1164.all;

entity card7seg_tb is 
end card7seg_tb;

architecture rtl of card7seg_tb is
	component card7seg 
		port(
	   	card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- value of card
	   	seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- 7-seg LED pattern
		);
	end component;

	signal card : std_logic_vector(3 downto 0);
	signal seg7 : std_logic_vector(6 downto 0);
	
	begin
	   
	  dut : card7seg port map(card, seg7); 
	  
	  process
	    begin 
	       card <= "0000";
	        wait for 10 ns;
	       card <= "0001";
	        wait for 10 ns;
	        	       card <= "0010";
	        wait for 10 ns;
	       	       card <= "0011";
	        wait for 10 ns;
	       	       card <= "0100";
	        wait for 10 ns;
	       	       card <= "0101";
	        wait for 10 ns;
	       	       card <= "0110";
	        wait for 10 ns;
	       	       card <= "0111";
	        wait for 10 ns;
	       	       card <= "1000";
	        wait for 10 ns;
	       	       card <= "1001";
	        wait for 10 ns;
	       	       card <= "1010";
	        wait for 10 ns;
	       	       card <= "1011";
	        wait for 10 ns;
	       	       card <= "1100";
	        wait for 10 ns;
	       	       card <= "1101";
	        wait for 10 ns;
	       	       card <= "1110";
	        wait for 10 ns;
	       	       card <= "1111";
	        wait for 10 ns;
	      end process;
	    end rtl;
	    	        
	