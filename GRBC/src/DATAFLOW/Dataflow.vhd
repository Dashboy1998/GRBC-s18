library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.stream.all;
use work.byte.all;

architecture dataflow of GRBC is
	signal state_main, state_data, state_key, state_e, state_o: natural:=0; --State machines  
	
	signal load, load_done, LU: std_logic:='0'; -- Used to load trigger loading data
	signal Key: DQword; -- Holds the entire secret Key
	signal In_data: Qword;
	
	signal Key_Ex, key_done: std_logic:='0'; -- Used for Key expanison
	signal Keys: RoundData;
	
	--signal En_Encrypt, En_Decrypt: std_logic:='0'; -- Used to call other state machines
	signal En_EnDecrypt: std_logic:='0'; -- Used to call encryption/decryption state machines
	signal round: natural:=0; -- Round counter
	signal UseKey: natural:= 0; -- Used to pick the key (Used to allow one state machine for encryption and decryption)
	signal rData: DQWord; -- AddRoundKey data
	signal sData: DQWord; -- Sbox data
	signal mData: DQWord; -- Mix matrix data
	signal en_sbox: std_logic;
	signal done_sbox: std_logic;
	signal en_mix: std_logic;
	signal done_mix: std_logic;
	signal ED_Done: std_logic; 
	signal FirstAddRoundKey: std_logic; -- Used to show if first time doing add round key for in decryption
	signal s_indata, m_indata: DQWord;
	
	
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
	component MixColumn
		port(
			Data: in DQWord;
			Mixed: out DQword;
			ED: in std_logic;
			Start: in std_logic;
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
				end if;
				when 1 => -- Expands Key
					if(Key_done = '0') then -- Waits for Key expansion to finish
						state_main<= 1;
					else
						state_main<= 2;
				end if;
				when 2 => -- Encryption/Decryption state
					if(ED_done = '0') then
						state_main <= 2;
					else
						state_main <= 3;
				end if;
				when 3 => --Output state
				state_main <= 4;
				when 4 => --Output state 
				state_main <= 0;
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
						state_data<= 1;
					else
						state_data<= 0;
						load_done<= '0';
				end if;
				when 1 =>
				state_data <= 2;
				when 2 => 	 
				state_data<= 3;
				when 3 =>	  
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
					FirstAddRoundKey<= '0';
					if(En_EnDecrypt = '0') then -- Waits
						state_e<= 0;
					else
						state_e<= 1;
				end if;
				when 1 => -- AddRoundKey
					if(round /= 12) then
						if(ED = '0') then
							state_e<= 2; -- Sbox/Rotate
							round <= round + 1;
						else
							if(FirstAddRoundKey = '0') then -- go to sbox/shift
								state_e<=2; -- Sbox/Rotate
							else -- go to mix
								state_e<=3; -- Mix Column
							end if;
						end if;
					else -- Finished De/encryption
						state_e<= 0;
				end if;
				when 2 => -- Sbox and rotate
					if(done_sbox = '1') then
						if(round /= 12 and ED = '0') then
							state_e<= 3; --Mix Column
						else
							FirstAddRoundKey<= '1';
							state_e<= 1; -- AddRoundKey
						end if;
					else 
						state_e<= 2; -- Wait
				end if;
				when 3 => -- Mix column
					if(done_mix = '1') then	
						if(ED = '0') then 
							state_e<= 1; -- AddRoundKey  
						else
							state_e<= 2; -- Sbox/rotate
							round<= round + 1;
						end if;
					else
						state_e<= 3; -- wait
				end if;
				when others =>
				state_e<= 0;
			end case;
		end if;	
	end process Encryption;
	
	KeyEx:	KeyExpansion port map(Key, Keys, Key_Ex, Key_done, clk); --Expands Key 
	Data<= input(In_data, LU, Data) when ((state_data = 1 or state_data = 2) and clk'event and clk = '1') else Data; -- Data
	Key<= input(In_data, LU, Key) when ((state_data = 3 or state_data = 4) and clk'event and clk = '1') else Key; -- Secret Key
	UseKey<= round when ED = '0' else (12 - round); -- Calculates which Key to use
	In_data<= IO when clk'event and clk = '1'; -- Holds IO data
	Key_Ex<= '1' when state_main = 1 else '0'; -- Starts Key expanison
	LU<= '1' when (((state_data = 0 and load = '1') or state_data = 2 or (state_main = 2 and ED_done = '1')) and clk'event and clk = '1') else '0' when (clk'event and clk = '1');
	
	En_EnDecrypt<= '1' when (state_main = 2) else '0'; -- Used to start encryption/decryption
	--En_Encrypt<= '1' when (state_main = 2 and ED = '0') else '0'; -- Used to start encryption state machine
	--EN_Decrypt<= '1' when (state_main = 2 and ED = '1') else '0'; -- Used to start decryption state machine
	ED_done <= '1' when (state_e = 1 and round = 12) else '0'; -- Used to signal when encryption is done
	
	SB:	sbox port map(s_indata, sdata, ED, en_sbox, done_sbox, clk); -- Sbox for encryption/decryption
	en_sbox<= '1' when (state_e<= 2) else '0'; -- Need to add condition for decryption
	rdata<= (data xor Keys(UseKey)) when (state_e = 1 and round = 0 and FirstAddRoundKey = '0') -- Used for zero Round in encryption and first AddRoundKey in Decryption
	else (sdata xor Keys(UseKey)) when (state_e = 1 and FirstAddRoundKey = '1') -- Used for AddRoundKey in Decryption
	else (mdata xor keys(UseKey)) when (state_e = 1 and round /= 0 and round /= 12) -- Used for
	else (sdata xor keys(round)) when (state_e = 1 and round = 12) 
	else rdata; --AddKeyRound data
	
	Mix: MixColumn port map(m_indata, mdata, ED, en_mix, done_mix, clk); -- Mix column for encryption/decryption
	en_mix<= '1' when (state_e = 3) else '0'; -- Need to update for decryption
	
	m_indata<= sdata when ED = '0' else rdata;
	s_indata<= rdata when ED = '0' else rdata when (ED = '1' and round = 0) else mdata;
		
	done<= '1' when (state_main = 3 or state_main = 4) else '0'; -- Used to indicate when encryption/decryption is done 
	A <= output(rdata, LU) when done = '1' else A; --Tri state signal
	
	load<= '1' when (state_main = 0 and start = '1') else '0'; -- Used to indicate if loading data 
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
end dataflow;