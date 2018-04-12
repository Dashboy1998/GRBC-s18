library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.stream.all;

architecture dataflow of GRBC is
	signal count, state_main, state_data,state_key, state_r: natural:=0;
	signal load: std_logic:='0'; -- Used to load trigger loading data
	signal KeyExpansion, Encryption, Decryption: std_logic:='0'; -- Used to call other state machines
	signal Key, Data: DQword; -- Used to input full key and data
	signal A: Qword; -- Used for tri-state buffer
	signal work: std_logic; -- Used to indicate if WIP
	signal Keys: RoundData;
begin
	Main:	process(clk)
	begin
		if(clk = '1')  then
			if(KeyExpansion = '0' and Encryption = '0' and Decryption = '0' and load = '0') then -- Checks if other states are happening
				case state_main is
					when 0 =>
						if(start = '1') then
							load<= '1'; -- Activates load_data state machine
						else
							state_main <= 0;
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
		end if;
	end process Main;
	
	load_data:	process(clk)
	begin
--		if(load = '1' and clk'event) then
--			case state_data is
--				when 0 =>
--					Key(
		end process load_data;
	
	KeyEx:	process(clk)
	begin
		
	end process KeyEx;
	
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
end dataflow;