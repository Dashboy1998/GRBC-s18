library ieee;
use ieee.std_logic_1164.all;

architecture dataflow of GRBC is
	signal count, state_main, state_key, state_r: integer:=0;
	signal load_UK, load_LK, load_UD, load_LD: std_logic; -- Used to load data
	signal KeyExpansion, Encryption, Decryption: std_logic; -- Used to call other state machines
begin
	Main:	process(clk)
	begin
		if(clk = '1')  then
			if(KeyExpansion = '0' and Encryption = '0' and Decryption = '0') then -- Checks if other states are happening
				case state_main is
					when 0 =>
						if(start = '0') then
							if(RD = '1') then -- Loads Data/key
								if(DK = '0') then -- Loads Data
									if(LU = '0') then -- Loads lower data
										load_LD <= '1';
									end if;
								elsif(LU = '1') then -- Loads upper data
									load_UD <= '1';
								end if;
							elsif(DK = '1') then -- Loads Key
								if(LU = '0') then -- Loads lower key
									load_LK <= '1';
								elsif(LU = '1') then -- Loads upper key
									load_UK <= '1';
								end if;
							end if;
							state_main <= 0;
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
	
end dataflow;