library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.stream.all;

architecture dataflow of GRBC is
	signal count, state_main, state_key, state_r: integer:=0;
	signal load_UK, load_LK, load_UD, load_LD: std_logic:='0'; -- Used to load data
	signal KeyExpansion, Encryption, Decryption: std_logic:='0'; -- Used to call other state machines
	signal Key, Data: DQword; -- Used to input full key and data
	signal A: Qword; -- Used for tri-state buffer  
	signal B: std_logic; -- Used for tri-state buffer
begin
	Main:	process(clk)
	begin
		if(clk = '1')  then
			load_UK<='0';
			load_LK<='0'; 
			load_UD<='0'; 
			load_LD<='0';
			if(KeyExpansion = '0' and Encryption = '0' and Decryption = '0') then -- Checks if other states are happening
				case state_main is
					when 0 =>
						if(start = '0') then
							if(RD = '1') then -- Loads Data/key
								if(DK = '0') then -- Loads Data
									if(LU = '0') then -- Loads lower data
										Data<= input(IO,'0',Data);
									elsif(LU = '1') then -- Loads upper data
										Data<= input(IO,'1',Data);
									end if;
								elsif(DK = '1') then -- Loads Key
									if(LU = '0') then -- Loads lower key
										Key<= input(IO,'0',Key);
									elsif(LU = '1') then -- Loads upper key
										Key<= input(IO,'1',Key);
									end if;
								end if;
								state_main <= 0;
							end if;
						elsif(start = '1') then
							state_main <= 1;
						end if;
					
					when 1 => -- Expands Key
						KeyExpansion <= '1';
					state_main <= 2;
					when 2 =>
						if(ED = '0') then -- Encrypts data
							Encryption <= '1';
						elsif(ED = '1') then
							Decryption <= '0'; -- Decrypts data
					end if;
					when 3 =>
					null; -- Outputs data
					when others =>
					null;
				end case;
			end if;
		end if;
	end process Main;
	
	KeyEx:	process(clk)
	begin
		
	end process KeyEx;
	
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
	LU<= B when (done = '1') else 'Z';
end dataflow;