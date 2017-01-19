library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4statemachine is
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
end lab4statemachine;

architecture rtl of lab4statemachine  is

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
  
	type state_type is (idle, clear, draw);
	signal state   : state_type;
  
  
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
  

	process ( CLOCK_50 )
		variable i : unsigned (7 downto 0):= "00000000";
		variable x_p : unsigned (7 downto 0):= "00000000";
		variable j : unsigned (6 downto 0):= "0000000";
		variable y_p : unsigned (6 downto 0):= "0000000";
		variable k : unsigned ( 2 downto 0) := "000";
		
		variable flag : std_logic := '0';
		variable flag2 : std_logic := '0';
		variable PRESENT_STATE   : state_type;
		
		begin 
		
		if ( falling_edge(CLOCK_50)) then 
		
			case state is 
				-- this is the initialize to black state
				when idle =>
				
					-- these kill/animate the program for some reason
					-- done_drawing <= '0';
					-- done_clearing <= '0';
					
					
					i := "00000000";
					j := "0000000";
 
 				-- drawing the whole screen black
				when clear => 

					-- set color to black
					k := "000";
					
					if ( i < 160) then 
						i := i + 1;
						
					elsif ( j < 120) then 
						i := "00000000";
						j := j + 1;
					
					else
						done_clearing <= '1';
		 
					end if;
				
				-- draw 
				when draw =>
							
						if i < 160 then -- this needs to be more complicated
							i := i + 1;
						end if;
						
						if j < 120 then 
							j := j + 1;
						else
							done_drawing <= '1';
						end if;
						
						-- k represents the color, so we're incrementing
						-- the color value to alternate colours as we draw
						-- uncomment this line to make line consistent color 
						k := k + 1;
						
				end case;

			end if; -- for falling_edge
	
		colour <= std_logic_vector(k);
		x <= std_logic_vector(i);
		y <= std_logic_vector(j);
		plot <= '1';
		
	end process; 
	
	process(CLOCK_50, key(3))
		variable PRES_STATE   : state_type;

	begin
	
		if key(3) = '0' then
			PRES_STATE := clear;

		elsif rising_edge(cloCK_50) then
		
			-- if done_clearing or done_drawing go to idle
			-- otherwise, continue in state we're in
			
			if done_clearing = '0' then
				PRES_STATE := clear;
			else	
				PRES_STATE := idle;
			end if;
			
			if done_drawing = '0' then
				PRES_STATE := draw;
			else
				PRES_STATE := idle;
			end if;

			-- if key 0 is ever pressed, draw the line
			if key(0) = '0' then
				PRES_STATE := draw;
			end if;

			
		end if;
		
		state <= PRES_STATE;

	end process;

end RTL;


