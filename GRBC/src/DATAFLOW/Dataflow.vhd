library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.stream.all;

architecture dataflow of GRBC is
	signal state_main, state_data,state_key, state_r: natural:=0;  
	signal round: natural:=0;
	signal load, load_done, LU: std_logic:='0'; -- Used to load trigger loading data
	signal ReadKey: std_logic:='0'; 
	signal Encryption, Decryption: std_logic:='0'; -- Used to call other state machines
	--signal KeyEx_Done: std_logic; -- Used to tell the main state machine key expanison is done (All rounds)
	signal Data: DQWord; -- Used to input full data 
	signal NextKey, Key: DQword; -- Used to find the next key 
	signal A: Qword; -- Used for tri-state buffer
	signal work: std_logic; -- Used to indicate if WIP
	signal Key0, Key1, Key2, Key3, Key4, Key5, Key6, Key7, Key8, Key9, Key10, Key11, Key12: DQWord; -- All the keys
	signal In_data: Qword;
	component KeyExpansion
		port(
			Key: in DQWord;
			nextKey: inout DQWord;
			round: integer;
			clk: in std_logic
			);
	end component;
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
						round <= 0;
				end if;
				when 1 => -- Expands Key
					round<=round + 1;
					if(round = 12) then
						if(ED = '0') then
							state_main<= 2; -- Encryption
							round<= 0;
						else
							state_main<= 3; -- Decryption
						end if;
					else
						state_main<= 1;
				end if;
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
			-- IO will be connected to the data/key0 register with a Demux, 
			-- The registers will have a mux attached to them to select holding the data or to set new data (i.e. IO)
			-- Select line of the MUX will be attached to the state (Using logic gates as need), and to load
			case state_data is
				when 0 =>
					if(load = '1') then
						LU<= '1';
						state_data<= 1;
					else
						state_data<= 0;
						load_done<= '0';
				end if;
				when 1 =>
					LU<= '0';
				state_data <= 2;
				when 2 => 
					LU<= '1';
				state_data<= 3;
				when 3 =>
					LU<= '0';
				state_data<= 4;
				when 4 =>
					load_done <= '1';
				state_data<= 0;
				when others =>
				null;
			end case;
		end if;
	end process load_data; 
	
	--KeyEx:	process(clk)
	--		begin
	--			if(clk = '1') then
	--				case state_key is
	--					when 0 =>
	--						if(KeyExpansion = '1') then
	--							Data<= input(IO, '1', Data);
	--							state_key<= 1;
	--						else
	--							state_data<= 0;
	--							load_done<= '0';
	--					end if;
	--					when 1 =>
	--						Data<= input(IO, '0', Data);
	--					state_data<= 2;
	--					when 2 =>
	--						Keys(0)<= input(IO, '1', Keys(0));
	--					state_data<= 3;
	--					when 3 =>
	--						Keys(0)<= input(IO, '0', Keys(0));
	--						load_done <= '1';
	--					state_data<= 0;
	--					when others =>
	--					null;
	--				end case;
	--			end if;
	--		end process KeyEx; 
	
	
	FF:	process(clk) --Process for flip flops
	begin
		if(clk = '1') then
			In_data<= IO;
			if(state_data = 1 or state_data = 2) then --Implies Mux
				Data<= input(In_data, LU, Data); -- The function input implies a Demux with LU as select
			else 
				Data<= data;
			end if;
			
			if(state_data = 3 or state_data = 4) then --Implies Mux
				Key0<= input(In_data, LU, Key0); -- The function input implies a Demux with LU as select
			else 
				Key0<= Key0;
			end if;
			
			if(state_main = 1) -- Mux for Key
				case round is
					when 1 =>
					Key <= Key0;
					when 2 =>
					Key <= Key1;
					when 3 =>
					Key <= Key2;
					when 4 =>
					Key <= Key3;
					when 5 =>	
					Key <= Key4;
					when 6 =>	
					Key <= Key5;
					when 7 =>	
					Key <= Key6;
					when 8 =>	
					Key <= Key7;
					when 9 =>	
					Key <= Key8;
					when 10 =>	
					Key <= Key9;
					when 11 =>	
					Key <= Key10;
					when 12 =>
					Key <= Key11;
					when others => null;
					end case;	
			end if;
			
					
			
		end if;
	end process FF;
	
KeyEx:	KeyExpansion port map(Key, nextKey, round, clk);
	
	load<= '1' when (state_main = 0 and start = '1') else '0'; -- Used to indicate if loading data
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
end dataflow;