-- todo maybe pixel in top left
-- overshoot in challenge 
-- double tap occasionally needed

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4vga is
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
end lab4vga;

architecture rtl of lab4vga  is

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
  
  signal done_clearing : std_logic;
  signal done_drawing : std_logic;
  signal done_assigning : std_logic;
  
	type state_type is (idle, clear, assign, draw);
	signal state   : state_type;
  
  
begin

  -- includes the vga adapter, which should be in your project 

  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => KEY(2),
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
  

	process ( CLOCK_50 )
		variable x0 : signed (9 downto 0); -- := "0001010000"; -- 80
		variable y0 : signed (9 downto 0); -- := "0000111100";  -- 60

		variable x1 : signed (9 downto 0):= "0000000000";
		variable y1 : signed (9 downto 0):= "0000000000";

		variable sx : signed (9 downto 0):= "0000000000";
		variable sy : signed (9 downto 0):= "0000000000";
		
		variable k : signed ( 2 downto 0) := "000";
		
		variable dx : signed (9 downto 0):= "0000000000";
		variable dy	: signed (9 downto 0):= "0000000000";		

		variable err : signed (9 downto 0):= "0000000000";
		variable e2 : signed (9 downto 0):= "0000000000";
		
		variable p : std_logic := '0';
		
		begin 
		
		if ( falling_edge(CLOCK_50)) then 
		
			case state is 
				-- this is the initialize to black state
				when idle =>
				
					-- these kill/animate the program for some reason
					-- done_drawing <= '0';
					-- done_clearing <= '0';
					
					p := '0';
					x0 := "0000000000";
					y0 := "0000000000";
					
 
 				-- drawing the whole screen black
				when clear => 
				
						p := '1';
					
						done_clearing <= '0';
						
						-- set color to black
						k := "000"; 
						
						if ( x0 < 160) then 
							x0 := x0 + 1;
							
						elsif ( y0 < 120) then 
							x0 := "0000000000";
							y0 := y0 + 1;
						
						else
							done_clearing <= '1';
							
						end if;
						
				
				when assign =>
				
						done_assigning <= '0';
				
						-- get color 
						k := signed(SW(2 downto 0));
						
						-- get center pixel for x0,y0
						x0 := "0001010000"; -- 80
					   y0 := "0000111100";  -- 60
						
						-- get coordinates from switches for x1,y1
						x1(7 downto 0) := signed(SW(17 downto 10)); --"00000000";
						y1(6 downto 0) := signed(SW(9 downto 3));   --"0000000";
						
						
						dx := abs(x1 - x0);
						dy := abs(y1 - y0);
						
						-- sx and sy determine directionality
						if x0 < x1 then 
							sx := "0000000001"; 
						else 
							sx := -"0000000001"; -- -1 in a weird hacky way
						end if;
						
						if y0 < y1 then 
							sy := "0000000001"; 
						else 
							sy := -"0000000001";
						end if;
						
						err := dx - dy;
											
						done_assigning <= '1';
						
					
				when draw => 
				
						p := '1';
				
						done_drawing <= '0';
					
						if x0 = x1 and y0 = y1 then
							done_drawing <= '1';
						end if;
						
						e2 := to_signed(2*to_integer(err), 10); -- 2*err
						
						if e2 > -1*dy then
							err := err - dy;
							x0 := x0 + sx;
						end if;
						
						if e2 < dx then
							err := err + dx;
							y0 := y0 + sy;
						end if;
					
				end case;

			end if; -- for falling_edge
	
	
		colour <= std_logic_vector(k);
		x <= std_logic_vector(x0(7 downto 0));
		y <= std_logic_vector(y0(6 downto 0));
		plot <= p;
		
	end process; 
	
	process(CLOCK_50, key(2))
		variable PRES_STATE   : state_type := idle;

	begin
	
		if KEY(3) = '0' then
			 PRES_STATE := clear;

		elsif rising_edge(CLOCK_50) then
		

			case PRES_STATE is
				when idle =>
				
					LEDG(0) <= '1';
					LEDG(1) <= '0';
					LEDG(2) <= '0';
				
					if key(0) = '0' then
						PRES_STATE := assign;
					else
						PRES_STATE := idle;					
					end if;
					
				when clear =>
				
					LEDG(0) <= '0';
					LEDG(1) <= '1';
					LEDG(2) <= '0';

					if done_clearing = '1' then 
						PRES_STATE := idle;
					else	
						PRES_STATE := clear;
					end if;
					
				when assign =>
				
					if done_assigning = '1' then 
						PRES_STATE := draw;
					else	
						PRES_STATE := assign;
					end if;				
				
				when draw =>

				
					LEDG(0) <= '0';
					LEDG(1) <= '0';
					LEDG(2) <= '1';
				
					
					if done_drawing = '1' then 
						PRES_STATE := idle;
					else	
						PRES_STATE := draw;
					end if;				
								
			end case;
			
		end if;
		
		state <= PRES_STATE;

	end process;

end RTL;


