library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.KeyExpansionFunc.all; 
use work.Encryption.all;
use work.Decryption.all;
use work.stream.all;

entity GRBC is
	port(
		-- IO should be inout however I cannot get it to work in testbench as inout
		IO: inout Qword;--:=((others => (others => "ZZZZZZZZ"))); -- Used as input for plain text/cipher and key, and output of plain text/cipher
		-- Change PK to DK to mean data and key
		PK: in std_logic; -- Used to indicate if writting plain text/cihper or key
		-- LU should be inout. Assume device plugged into uses tristate buffers for read/writing data
		-- and a mux for which side of bits writting
		LU: inout std_logic:='Z'; -- Used to indicate upper or lower bound of data being inputted
		ED: in std_logic; -- Used to indicate if encrypting or decrypting
		RD: in std_logic; -- Used to indicate reading data
		Start: in std_logic; -- Used to start the encrpytion/decryption
		Clk: in std_logic; -- Clk signal
		Done: inout std_logic:='0' -- Signal to indicate if done
		);
end entity;	 

architecture behavioral of GRBC is
signal a: Qword:=(others=> (others => "XXXXXXXX"));
signal b: std_logic;
begin 
	process
		variable Key, Text: DQWord;
		variable Round: integer; -- Counter for rounds
		variable RoundKeys, RoundText: RoundData;
	begin
		
		done<='0';
		if(clk = '1') then
			if(RD = '1') then -- Reads the data
				if(PK = '0') then -- Reads Plain Text
					Text:=input(IO,LU,Text);
				else -- Reads the Key
					Key:=input(IO,LU,Key);
				end if;
			elsif(start = '1') then -- Encryption/Decrption		
				RoundKeys(0):=Key;
				for i in 1 to 12 loop -- Loop to calculate round keys
					RoundKeys(i):=KeyEx(RoundKeys(i-1), i);
				end loop;	
				if(ED = '0') then
					RoundText(0):=Cipher(Text, RoundKeys(0), 0);
					for i in 1 to 12 loop -- Loop to calculate round data for encryption
						RoundText(i):=Cipher(RoundText(i-1), RoundKeys(i), i); 
					end loop;
				else
					RoundText(0):=invCipher(Text, RoundKeys(12), 12);
					for i in 11 downto 0 loop -- Loop to calculate round data for decryption
						RoundText(12-i):=invCipher(RoundText(11-i), RoundKeys(i), i);
					end loop;
				end if;
				
				B <= '1';
				
				--Outputs the result
				for i in 0 to 1 loop
					wait until clk'event and clk = '1';
					done <= '1';
					A<= output(RoundText(12),B);
					B <= '0';
				end loop;
				wait until clk'event and clk = '1';
			end if;
		end if; 
		wait on clk;
	end process;
	
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
	LU<= B when (done = '1') else 'Z';
	
end behavioral;