library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab5 is
  port(CLOCK_50            : in  std_logic;
       KEY                 : in  std_logic_vector(3 downto 0);
       SW                  : in  std_logic_vector(17 downto 0);
       VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
       VGA_HS              : out std_logic;
       VGA_VS              : out std_logic;
       VGA_BLANK           : out std_logic;
       VGA_SYNC            : out std_logic;
       VGA_CLK             : out std_logic;
		 LEDG : out std_logic_vector (7 downto 0);
		 HEX6 : out std_logic_vector(6 downto 0);
		 HEX4 : out std_logic_vector(6 downto 0)
		 );
end lab5;

architecture rtl of lab5  is

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
  signal done_drawing_ball : std_logic;
  signal done_pausing : std_logic;
  signal done_erasing_ball : std_logic;
  signal done_reseting : std_logic;
  
  signal done_init_rg : std_logic;
  signal done_erase_rg : std_logic;
  signal done_draw_rg : std_logic;
  
  signal done_erase_rf : std_logic;
  signal done_draw_rf : std_logic;
  
  signal done_erase_bg : std_logic;
  signal done_draw_bg : std_logic;
  
  signal done_erase_bf : std_logic;
  signal done_draw_bf : std_logic;
  
  signal pre_game_over_done : std_logic;
  signal done_gameover : std_logic;
    
  
  signal player_1_wins : std_logic;
  signal player_2_wins : std_logic;
  
    
  signal player_1_score : integer;
  signal player_2_score : integer;
  
  signal direction : unsigned(1 downto 0);
  
  signal delay_time : integer;
  
  
	type state_type is (	idle,	clear, reset, pause, 
								erase_ball, 	draw_ball, 
								draw_rg, 		erase_rg,
								draw_rf, 		erase_rf,
								draw_bg, 		erase_bg,
								draw_bf, 		erase_bf,
								pre_game_over, game_over
							); 
	signal state : state_type;
  
  
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
  
	-- DATAPATH PROCESS
	process ( CLOCK_50 )
		variable x0 : unsigned(7 downto 0);
		variable y0 : unsigned(6 downto 0);
		
		variable bx : integer := 0;
		variable by : integer := 0;

		variable d_bx : integer := 0;
		variable d_by : integer := 0;
		
		variable c : unsigned(2 downto 0);

		variable delay: integer := 0;
		
		variable p : std_logic := '0';
		
		variable rg_x : integer := 0;
		variable rg_yt : integer := 0;
		variable rg_yb : integer := 0;

		variable bg_x : integer := 0;
		variable bg_yt : integer := 0;
		variable bg_yb : integer := 0;		
		
		variable rf_x : integer := 0;
		variable rf_yt : integer := 0;
		variable rf_yb : integer := 0;

		variable bf_x : integer := 0;
		variable bf_yt : integer := 0;
		variable bf_yb : integer := 0;		
		
		
		
		
	begin 
		
		if falling_edge(CLOCK_50) then 
		
			case state is 
			
				when idle =>

						player_1_score <= 0;
						player_2_score <= 0;
						
						direction <= "00";
						
						ledg(3) <= '1';

				
				when reset => 
			
						ledg(3) <= '0';
		
						p := '1'; -- we will draw

						done_reseting <= '0';
						
						delay := 0;
						
						-- alternate direction
						direction <= direction + 1;
										
						case direction is
							when "00" => d_bx := 1;
											 d_by := 1;
											 
							when "01" => d_bx := -1;
											 d_by := 1;
											 
							when "10" => d_bx := 1;
											 d_by := -1;
											 
							when "11" => d_bx := -1;
											 d_by := -1;	
						end case;
						
						-- starting ball coordinates
						bx := 80;
						by := 60;
						
						-- starting red goalie coords
						rg_x  := 15;
						rg_yt := 55;
						rg_yb := 65;
						
						rf_x := 60;
						rf_yt := 55;
						rf_yb := 65;
						
						bf_x := 100;
						bf_yt := 55;
						bf_yb := 65;
						
						bg_x := 135;
						bg_yt := 55;
						bg_yb := 65;

						-- reset the winner flag
						player_1_wins <= '0';
						player_2_wins <= '0';
						

						x0 := "00000000";
						y0 := "0000000";

						
						-- default delay time
						delay_time <= 1400000; --1200000
						
						
						done_reseting <= '1';
					
				
				when clear => 
				
						p := '1'; -- we will draw
						done_clearing <= '0';
						
						-- set color to black
						c := "000"; 
						
						-- unless we're drawing our top and bottom borders
						if y0 = 9 or y0 = 111 then
							if x0 >= 10 and x0 <= 140 then
								c := "111";
							end if;
						end if;
						
						-- drawing it all black
						if ( x0 < 160) then 
							x0 := x0 + 1;
							
						elsif ( y0 < 120) then 
							x0 := "00000000";
							y0 := y0 + 1;
						
						else
							-- once the whole screen is 
							-- covered black, we're done clearing
							done_clearing <= '1';
							
						end if;
						
				--state to draw red goalie 
				when draw_rg =>

						done_draw_rg <= '0';
						c := "100"; -- should be 100

						rg_x := 15;

						-- if paddle between bottom and top border
						if rg_yb < 110 and rg_yt > 10 then 

							-- if moving up, draw one pixel higher than our paddle
							if SW(17) = '1' then
								rg_yt := rg_yt - 1;
								y0 := to_unsigned(rg_yt, 7); 

							-- if moving down, draw one pixel lower than our paddle
							else
								rg_yb := rg_yb + 1;
								y0 := to_unsigned(rg_yb, 7); 

							end if;

						x0 := to_unsigned(rg_x, 8);


						-- if the paddle is below the bottom border
						elsif rg_yb >= 110 then -- 110
							-- keep it above the border
							rg_yb := 109; 
							rg_yt := 99; 

						-- if the paddle is above the top border
						elsif rg_yt <= 10 then
							-- keept it below the border
							rg_yt := 11; 
							rg_yb := 21; 

						end if;

						
						done_draw_rg <= '1';


				when erase_rg => 

						done_erase_rg <= '0';
						c := "000"; -- should be 000
						rg_x := 15;
						if rg_yb < 110 and rg_yt > 10 then -- make 111 and 9 to send right to border, but not being erased correctly

							if SW(17) = '1' then
								y0 := to_unsigned(rg_yb, 7); 
								rg_yb := rg_yb - 1;
							else
								y0 := to_unsigned(rg_yt, 7);
								rg_yt := rg_yt + 1;
							end if;
	
							x0 := to_unsigned(rg_x, 8); -- added this
						
						end if;
						
						done_erase_rg <= '1';
				--state to draw red forward
					when draw_rf =>

						done_draw_rf <= '0';
						c := "100"; -- should be 100

						rf_x := 60;

						-- if paddle between bottom and top border
						if rf_yb < 110 and rf_yt > 10 then 

							-- if moving up, draw one pixel higher than our paddle
							if SW(16) = '1' then
								rf_yt := rf_yt - 1;
								y0 := to_unsigned(rf_yt, 7); 

							-- if moving down, draw one pixel lower than our paddle
							else
								rf_yb := rf_yb + 1;
								y0 := to_unsigned(rf_yb, 7); 

							end if;

							x0 := to_unsigned(rf_x, 8);

						-- if the paddle is below the bottom border
						elsif rf_yb >= 110 then -- 110
							-- keep it above the border
							rf_yb := 109; 
							rf_yt := 99; 
							c := "000"; -- should be 000

						-- if the paddle is above the top border
						elsif rf_yt <= 10 then
							-- keept it below the border
							rf_yt := 11; 
							rf_yb := 21; 
						c := "000"; -- should be 000

						end if;
						
						done_draw_rf <= '1';


				when erase_rf => 

						done_erase_rf <= '0';
						c := "000"; -- should be 000
						rf_x := 60;
						if rf_yb < 110 and rf_yt > 10 then -- make 111 and 9 to send right to border, but not being erased correctly

							if SW(16) = '1' then
								y0 := to_unsigned(rf_yb, 7); 
								rf_yb := rf_yb - 1;
							else
								y0 := to_unsigned(rf_yt, 7);
								rf_yt := rf_yt + 1;
							end if;
	
							x0 := to_unsigned(rf_x, 8); -- added this
						
						end if;
						
						done_erase_rf <= '1';			

				when draw_bf =>
						
						done_draw_bf <= '0';
						c := "001";

						bf_x := 100;
						
						-- if paddle between bottom and top border
						if bf_yb < 110 and bf_yt > 10 then 
						
							-- if moving up, draw one pixel higher than our paddle
							if SW(1) = '1' then
								bf_yt := bf_yt - 1;
								y0 := to_unsigned(bf_yt, 7); 
							-- if moving down, draw one pixel lower than our paddle
							else
								bf_yb := bf_yb + 1;
								y0 := to_unsigned(bf_yb, 7); 
							end if;
							
							x0 := to_unsigned(bf_x, 8);

						-- if you comment out these lines, you stop getting the dots next to the red
						-- but you also stop being able to move the blue once it hits an edge
						-- I'm not sure why
						
						-- if the paddle is below the bottom border
						elsif bf_yb >= 110 then 
							
							-- for some reason the red paddle is being trailed with blue dots from this code,
							-- here I'm not really fixing it, I'm just turning them into black dots
							c := "000";
						
							-- keep it above the border
							bf_yt := 99;  		
							bf_yb := 109; 

						-- if the paddle is above the top border
						elsif bf_yt <= 10 then
							
							c := "000"; 
	
							-- keep it below the border
							bf_yt := 11; -- 11
							bf_yb := 21; -- 21 
						
						end if;
						
						done_draw_bf <= '1';


				when erase_bf => 
						
						done_erase_bf <= '0';
						c := "000"; -- should be 000
						
						bf_x := 100;
												
						if bf_yb < 110 and bf_yt > 10 then -- make 111 and 9 to send right to border, but not being erased correctly
									
							if SW(1) = '1' then
								y0 := to_unsigned(bf_yb, 7); 
								bf_yb := bf_yb - 1;
								
							else
								y0 := to_unsigned(bf_yt, 7);
								bf_yt := bf_yt + 1;
								
							end if;
	
							x0 := to_unsigned(bf_x, 8); -- added this
						
						end if;
						
						done_erase_bf <= '1';
						
				when draw_bg =>
						
						done_draw_bg <= '0';
						c := "001";

						bg_x := 135;
						
						-- if paddle between bottom and top border
						if bg_yb < 110 and bg_yt > 10 then 
						
							-- if moving up, draw one pixel higher than our paddle
							if SW(0) = '1' then
								bg_yt := bg_yt - 1;
								y0 := to_unsigned(bg_yt, 7); 
							-- if moving down, draw one pixel lower than our paddle
							else
								bg_yb := bg_yb + 1;
								y0 := to_unsigned(bg_yb, 7); 
							end if;
							
						x0 := to_unsigned(bg_x, 8);

						-- if you comment out these lines, you stop getting the dots next to the red
						-- but you also stop being able to move the blue once it hits an edge
						-- I'm not sure why
						
						-- if the paddle is below the bottom border
						elsif bg_yb >= 110 then 
							
							-- for some reason the red paddle is being trailed with blue dots from this code,
							-- here I'm not really fixing it, I'm just turning them into black dots
							c := "000";
						
							-- keep it above the border
							bg_yt := 99;  		
							bg_yb := 109; 

						-- if the paddle is above the top border
						elsif bg_yt <= 10 then
							
							c := "000"; 
	
							-- keep it below the border
							bg_yt := 11; -- 11
							bg_yb := 21; -- 21 
						
						end if;
						
						done_draw_bg <= '1';


				when erase_bg => 
						
						done_erase_bg <= '0';
						c := "000"; -- should be 000
						
						bg_x := 135;
												
						if bg_yb < 110 and bg_yt > 10 then -- make 111 and 9 to send right to border, but not being erased correctly
									
							if SW(0) = '1' then
								y0 := to_unsigned(bg_yb, 7); 
								bg_yb := bg_yb - 1;
								
							else
								y0 := to_unsigned(bg_yt, 7);
								bg_yt := bg_yt + 1;
								
							end if;
	
							x0 := to_unsigned(bg_x, 8); -- added this
						
						end if;
						
						done_erase_bg <= '1';
				
			
					
				when erase_ball => 
										
						done_erasing_ball <= '0';

						c := "000";

						x0 := to_unsigned(bx, 8);						
						y0 := to_unsigned(by, 7);
						
						done_erasing_ball <= '1';

				when draw_ball => 
										
						done_drawing_ball <= '0';

						-- default ball colour
						c := "111";
						
						-- set d_bx and d_by based on which wall it hit
					
						-- if ball hits right wall
						if bx >= 140 then
							d_bx := -1; 
							
							player_1_wins <= '1';
							player_1_score <= player_1_score + 1;
							
							
							
							LEDG(0) <= '1';
							LEDG(7) <= '0';
							
						-- if ball hits left wall
						elsif bx <= 10 then
							d_bx := 1; 

							player_2_wins <= '1';
							player_2_score <= player_2_score + 1;
							LEDG(0) <= '0';
							LEDG(7) <= '1';		

						-- if ball hits red goalie, change x direction
						elsif (bx = rg_x - 1 or bx = rg_x + 1 or bx = rg_x) and by > rg_yt - 1 and by < rg_yb + 1 then
							d_bx := -d_bx;
							delay_time <= delay_time - 200000;

						-- if ball hits red forward, change x direction
						elsif (bx = rf_x - 1 or bx = rf_x + 1 or bx = rf_x) and by > rf_yt - 1 and by < rf_yb + 1 then
							d_bx := -d_bx;
							delay_time <= delay_time - 200000;

						-- if ball hits blue goalie, change x direction
						elsif (bx = bg_x - 1 or bx = bg_x + 1 or bx = bg_x) and by > bg_yt - 1 and by < bg_yb + 1 then
							d_bx := -d_bx;
							delay_time <= delay_time - 200000;
							
						-- if ball hits blue forward, change x direction
						elsif (bx = bf_x - 1 or bx = bf_x + 1 or bx = bf_x) and by > bf_yt - 1 and by < bf_yb + 1 then
							d_bx := -d_bx;
							delay_time <= delay_time - 200000;
						
						end if;
						
						-- hits top and bottom border
						if by >= 110 then 
							d_by := -1;
						elsif by <= 10 then
							d_by := 1;
						end if;
						
						-- update ball location
						bx := bx + d_bx; 
						by := by + d_by;
						
						
						-- set the pixel to be drawn to the ball
						x0 := to_unsigned(bx, 8);						
						y0 := to_unsigned(by, 7);
						
						done_drawing_ball <= '1';
	
	
				when pause => 

						-- pause will be random seed for starting direction
						direction <= direction + 1;
				
						done_pausing <= '0';
				
						if delay < delay_time then -- 50MGz * 500,000 clock cycles = 10ms
							delay := delay + 1;
							
						else
							delay := 0;
							done_pausing <= '1';
							
						end if;
						
						
					
				when pre_game_over =>
				
						pre_game_over_done <= '0';
						
						x0 := "00000000";
						y0 := "0000000";				
	
						pre_game_over_done <= '1';
	
				when game_over =>
				
						--todo: draw screen color and write message
				
						p := '1'; -- we will draw
						done_gameover <= '0';
						
						if done_gameover = '0' then				

						end if;
						-- set color to red
						
						if player_1_wins = '1' then
							c := "100"; 
						else
							c := "001";
						end if;
						
						if ( x0 < 160) then 
							x0 := x0 + 1;
							
						elsif ( y0 < 120) then 
							x0 := "00000000";
							y0 := y0 + 1;
						
						else
							-- once the whole screen is 
							-- covered black, we're done clearing
							done_gameover <= '1';
							
						end if;
						
					when others =>
					
				end case;
				
				
			end if; -- for falling_edge
	
	
		colour  <= std_logic_vector(c);
		x  <= std_logic_vector(x0(7 downto 0));
		y  <= std_logic_vector(y0(6 downto 0)); 
		plot  <= p;
		
	end process; 
	
	
	-- LED DECOsDER
	process(player_1_score, player_2_score) 
	
	begin
	
	    case player_1_score is  
					--gfedcba and inverted
				when 0 => HEX6 <= "1000000";
				when 1 => HEX6 <= "1111001"; -- 1
				WHEN 2 => HEX6 <= "0100100"; -- 2
				WHEN 3 => HEX6 <= "0110000"; -- 3
				WHEN 4 => HEX6 <= "0011001"; -- 4
				WHEN 5 => HEX6 <= "0010010"; -- 5
				WHEN 6 => HEX6 <= "0000010"; -- 6
				WHEN 7 => HEX6 <= "1111000"; -- 7
				WHEN 8 => HEX6 <= "0000000"; -- 8
				WHEN 9 => HEX6 <= "0010000"; -- 9
				WHEN OTHERS => HEX6 <= "0111111"; -- 0
					 
		end case;
		
		case player_2_score is  
				when 0 => HEX4 <= "1000000";
				when 1 => HEX4 <= "1111001"; -- 1
				WHEN 2 => HEX4 <= "0100100"; -- 2
				WHEN 3 => HEX4 <= "0110000"; -- 3
				WHEN 4 => HEX4 <= "0011001"; -- 4
				WHEN 5 => HEX4 <= "0010010"; -- 5
				WHEN 6 => HEX4 <= "0000010"; -- 6
				WHEN 7 => HEX4 <= "1111000"; -- 7
				WHEN 8 => HEX4 <= "0000000"; -- 8
				WHEN 9 => HEX4 <= "0010000"; -- 9
				WHEN OTHERS => HEX4 <= "0111111"; -- 0
					 
		end case;
			
	end process;
	
	
	-- STATE MACHINE PROCESS
	process(CLOCK_50, key(1))
		variable PRES_STATE : state_type := idle;

	begin
	
		-- asynch reset
		if KEY(1) = '0' then
			 PRES_STATE := idle;

		elsif rising_edge(CLOCK_50) then
		
			case PRES_STATE is			
					
				when idle =>

					PRES_STATE := reset;					
				
				
				when reset =>
				
					if done_reseting = '1' then 
						PRES_STATE := clear;
					else	
						PRES_STATE := reset;
					end if;		
									
									
				when clear =>
				
					if done_clearing = '1' then 
						PRES_STATE := draw_rg; 
					else	
						PRES_STATE := clear;
					end if;		
					
					
				when draw_rg =>

					if done_draw_rg = '1' then
						PRES_STATE := erase_rg; 
					else
						PRES_STATE := draw_rg;
					end if;		

					
				when erase_rg =>

					if done_erase_rg = '1' then
						PRES_STATE := draw_rf; 
					else
						PRES_STATE := erase_rg;
					end if;		

				when draw_rf =>

					if done_draw_rf = '1' then
						PRES_STATE := erase_rf; 
					else
						PRES_STATE := draw_rf;
					end if;		

					
				when erase_rf =>

					if done_erase_rf = '1' then
						PRES_STATE := draw_bf; 
					else
						PRES_STATE := erase_rf;
					end if;	

				when draw_bf =>

					if done_draw_bf = '1' then
						PRES_STATE := erase_bf; 
					else
						PRES_STATE := draw_bf;
					end if;		

					
				when erase_bf =>

					if done_erase_bf = '1' then
						PRES_STATE := draw_bg; 
					else
						PRES_STATE := erase_bf;
					end if;						
				
				
				when draw_bg =>

					if done_draw_bg = '1' then
						PRES_STATE := erase_bg; 
					else
						PRES_STATE := draw_bg;
					end if;		

					
				when erase_bg =>

					if done_erase_bg = '1' then
						PRES_STATE := erase_ball; 
					else
						PRES_STATE := erase_bg;
					end if;				
					
					
				when erase_ball =>

					if done_erasing_ball = '1' then 
						PRES_STATE := draw_ball;
					else	
						PRES_STATE := erase_ball;
					end if;		
					
									
				when draw_ball =>

					if done_drawing_ball = '1' then 
						PRES_STATE := pause;
					else	
						PRES_STATE := draw_ball;
					end if;			
													
					
				when pause =>
				
					if done_pausing = '1' then 
						PRES_STATE := draw_rg;
					else	
						PRES_STATE := pause;
					end if;			

				
					if player_1_wins = '1' or player_2_wins = '1' then
						PRES_STATE := pre_game_over;
					end if;	
					
					
				when pre_game_over =>
					
					if pre_game_over_done = '1' then
						PRES_STATE := game_over;
					else
						PRES_STATE := pre_game_over;
					end if;

				
				when game_over => 
				
					if key(3) = '0' then 
						PRES_STATE := reset;
					else	
						PRES_STATE := game_over;
					end if;
				
				
				when others =>
				
			end case;
			
		end if;
		
		state <= PRES_STATE;

	end process;

end RTL;


