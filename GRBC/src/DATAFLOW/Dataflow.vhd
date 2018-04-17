library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.stream.all;
use work.byte.all;

architecture dataflow of GRBC is
	signal state_main, state_data, state_key, state_e: natural:=0; --State machines  
	
	signal load, load_done, LU: std_logic:='0'; -- Used to load trigger loading data
	signal Key: DQword; -- Holds the entire secret Key
	signal In_data: Qword;
	
	signal Key_Ex, key_done: std_logic:='0'; -- Used for Key expanison
	signal Keys: RoundData;
	
	signal En_Encrypt, En_Decrypt: std_logic:='0'; -- Used to call other state machines
	signal round: natural:=0; -- Round counter
	signal rData: DQWord; -- AddRoundKey data
	signal sData: DQWord; -- Sbox data
	signal en_sbox: std_logic;
	signal done_sbox: std_logic;
	
	
	
	signal Data: DQWord; -- Used to input full data
	signal A: Qword; -- Used for tri-state buffer
	
	signal work: std_logic; -- Used to indicate if WIP
	
	component KeyExpansion
		port(
			Key: in DQWord;
			Keys: inout RoundData;
			enable: in std_logic;	  
			done: out std_logic;
			clk: in std_logic
			);
	end component;
	component sbox
		port(
			data: in DQWord;
			sdata: out DQWord;
			ED: in std_logic;
			start: in std_logic;
			done: out std_logic;
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
						Key_Ex<= '1'; -- Starts Key expanison
				end if;
				when 1 => -- Expands Key
					if(Key_done = '0') then -- Waits for Key expansion to finish
						state_main<= 1;
					else
						state_main<= 2;
				end if;
				when 2 => -- Encryption/Decryption state
					if(done = '0') then
						state_main <= 2;
					else
						state_main <= 3;
				end if;
				when 3 => --Output state
				null; -- Outputs data
				when others =>
				state_main<= 0;
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
				state_data<= 0;
			end case;
		end if;
	end process load_data;  
	
	Encryption:	process(clk)
	begin
		if(clk = '1') then
			case state_e is
				when 0 =>
					round<= 0;
					if(En_Encrypt = '0') then -- Waits
						state_e<= 0;
					else
						state_e<= 1;
				end if;
				when 1 => -- AddRoundKey
					state_e<= 2;
					round <= round + 1;
				when 2 => -- Sbox and rotate
					if(done_sbox = '1') then
						state_e<= 3;
					else
						state_e<= 2;
				end if;
				when 3 => -- Mix column
				null;
				when others =>
				state_e<= 0;
			end case;
			
		end if;	
	end process Encryption;
	
	KeyEx:	KeyExpansion port map(Key, Keys, Key_Ex, Key_done, clk);
	Data<= input(In_data, LU, Data) when ((state_data = 1 or state_data = 2) and clk'event and clk = '1') else rdata when (state_e /= 0 and clk'event and clk = '1') else Data;
	Key<= input(In_data, LU, Key) when ((state_data = 3 or state_data = 4) and clk'event and clk = '1') else Key;
	In_data<= IO when clk'event and clk = '1'; 
	
	En_Encrypt<= '1' when (state_main = 2 and ED = '0') else '0'; -- Used to start encryption state machine
	EN_Decrypt<= '1' when (state_main = 2 and ED = '1') else '0'; -- Used to start decryption state machine
	
	SB:	sbox port map(rdata, sdata, ED, en_sbox, done_sbox, clk);
	en_sbox<= '1' when (state_e<= 2) else '0'; -- Need to add condition for decryption
	rdata<= (data xor key) when (state_e = 1) else rdata;
	
	load<= '1' when (state_main = 0 and start = '1') else '0'; -- Used to indicate if loading data
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
end dataflow;