library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.stream.all;

architecture dataflow of GRBC is
	signal count, state_main, state_data,state_key, state_r: natural:=0;
	signal load, load_done: std_logic:='0'; -- Used to load trigger loading data
	signal KeyExpansion, Encryption, Decryption: std_logic:='0'; -- Used to call other state machines
	signal Data: DQword; -- Used to input full data
	signal A: Qword; -- Used for tri-state buffer
	signal work: std_logic; -- Used to indicate if WIP
	signal Keys: RoundData;
begin
	Main:	process(clk)
	begin
		if(clk = '1')  then
				case state_main is
					when 0 => -- idle state
						if(load_done = '0') then
							state_main <= 0;
						else
							state_main <= 1;
					end if;
					when 1 => -- Expands Key
					KeyExpansion <= '1';
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
	end process Main;
	
	load_data:	process(clk) -- Process for loading the data (plain text/cipher and key)
	begin
		if(clk = '1') then
			case state_data is
				when 0 =>
					if(load = '1') then
						Data<= input(IO, '1', Data);
						state_data<= 1;
					else
						state_data<= 0;
						load_done<= '0';
				end if;
				when 1 =>
					Data<= input(IO, '0', Data);
				state_data<= 2;
				when 2 =>
					Keys(0)<= input(IO, '1', Keys(0));
				state_data<= 3;
				when 3 =>
					Keys(0)<= input(IO, '0', Keys(0));
					load_done <= '1';
				state_data<= 0;
				when others =>
				null;
			end case;
		end if;
	end process load_data; 
	
	load<= '1' when (state_main = 0 and start = '1') else '0'; -- Used to indicate if loading data
	
	KeyEx:	process(clk)
	begin
		
	end process KeyEx;
	
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
end dataflow;