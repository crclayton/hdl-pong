library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2vgaChallenge is
  port(CLOCK_50            : in  std_logic;
       KEY                 : in  std_logic_vector(3 downto 0);
       SW                  : in  std_logic_vector(17 downto 0);
       VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
       VGA_HS              : out std_logic;
       VGA_VS              : out std_logic;
       VGA_BLANK           : out std_logic;
       VGA_SYNC            : out std_logic;
       VGA_CLK             : out std_logic;
		  LEDG : out std_logic_vector (7 downto 0));
end lab2vgaChallenge;

architecture rtl of lab2vgaChallenge  is

 --Component from the Verilog file: vga_adapter.v

  component vga_adapter
    generic(RESOLUTION : string);
    port (resetn                                       : in  std_logic;
          clock                                        : in  std_logic;
          colour                                       : in  std_logic_vector(2 downto 0);
          x                                            : in  std_logic_vector(7 downto 0);
          y                                            : in  std_logic_vector(6 downto 0);
          plot                                         : in  std_logic;
          VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
          VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
  end component;

  signal x      : std_logic_vector(7 downto 0);
  signal y      : std_logic_vector(6 downto 0);
  signal SW_X      : std_logic_vector(7 downto 0);
  signal SW_Y      : std_logic_vector(6 downto 0);
  signal colour : std_logic_vector(2 downto 0);
  signal plot   : std_logic;
  signal z		: std_logic_vector(1 downto 0);
  signal done : std_logic;

begin

  -- includes the vga adapter, which should be in your project 

  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => KEY(3),
             clock     => CLOCK_50,
             colour    => colour,
             x         => x,
             y         => y,
             plot      => plot,
             VGA_R     => VGA_R,
             VGA_G     => VGA_G,
             VGA_B     => VGA_B,
             VGA_HS    => VGA_HS,
             VGA_VS    => VGA_VS,
             VGA_BLANK => VGA_BLANK,
             VGA_SYNC  => VGA_SYNC,
             VGA_CLK   => VGA_CLK);


  -- rest of your code goes here, as well as possibly additional files
  
--	process ( KEY(0), done )
--		variable PRESENT_STATE : std_logic_vector(1 downto 0 ) := "00";
--		begin
--		--if ( falling_edge (CLOCK_50)) then 
--		if ( PRESENT_STATE = "00") then
--			if (KEY(0) = '0') then 
--				PRESENT_STATE:= "01";
--			else 
--				PRESENT_STATE:= "00";
--			end if; 
--		elsif (PRESENT_STATE = "01") then 
--			if ( done = '1') then
--				PRESENT_STATE:= "10";
--			else 
--				PRESENT_STATE := "01";
--			end if;
--		elsif (PRESENT_STATE = "10") then 
--			PRESENT_STATE:= "10";
--			
--		else 
--			PRESENT_STATE := "00";
--		
--		--end if; 
--		end if;	
--		LEDG ( 1 downto 0 ) <= PRESENT_STATE;
--		z <= PRESENT_STATE; 
--	end process; 

	process ( CLOCK_50 )
		variable i : unsigned (7 downto 0):= "00000000";
		variable x_p : unsigned (7 downto 0):= "00000000";
		variable j : unsigned (6 downto 0):= "0000000";
		variable y_p : unsigned (6 downto 0):= "0000000";
		variable k : unsigned ( 2 downto 0) := "000";
		
		variable flag : std_logic := '0';
		variable flag2 : std_logic := '0';
		variable PRESENT_STATE : std_logic_vector(1 downto 0 ) := "00";
		begin 
		
		if ( falling_edge(CLOCK_50)) then 
			if ( PRESENT_STATE = "00") then
				i:="00000000";
				j:="0000000";
				
				if (not ( SW_X = SW( 7 downto 0)) or not (SW_Y = SW ( 14 downto 8 ))) then
				--if ( key(0) = '0') then
					SW_X      <= SW(7 downto 0);
					SW_Y     <= SW(14 downto 8);		
					PRESENT_STATE:= "01";
					k:= "000";
					
				else 
					PRESENT_STATE:= "00";
				end if; 
		
			
			elsif ( PRESENT_STATE = "01") then
				
				
				
				if ( i < 160) then 
						i := i + 1;
				elsif ( j < 120) then 
						i := "00000000";
						j := j+ 1;
				else 
					PRESENT_STATE := "10";
							 
				end if;
				
			elsif ( PRESENT_STATE = "10") then
						x_p := "00000000";
						y_p := "0000000";
					i:=  unsigned(SW_X);
					j:=  unsigned(SW_Y);
						PRESENT_STATE:= "11";
						flag := '0';
						
			elsif ( PRESENT_STATE = "11") then 
					--k := "111";

					if ( x_p < 3) then
						if (flag = '1') then 
							i := i + 1;
							x_p:= x_p + 1;
						else 
							flag := '1';
						end if;
						k := "010";
							
					elsif (y_p < 3) then  
							x_p := "00000000";
							i := unsigned(SW_X);
							j := j+ 1;
							y_p:=y_p + 1;
					else 
						PRESENT_STATE := "00";
--						i := "00000000";
--						j := "0000000";
						--k:= "000";
					end if;
					

				
					
				 
					
				 
			end if;
		end if;
	
		colour <= std_logic_vector(k);
		x<= std_logic_vector(i);
		y<= std_logic_vector(j);
		plot <= '1';
		
	end process; 
	

		
		
end RTL;


