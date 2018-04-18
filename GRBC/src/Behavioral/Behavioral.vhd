library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.KeyExpansionFunc.all; 
use work.Encryption.all;
use work.Decryption.all;
use work.stream.all;

architecture behavioral of GRBC is
	signal a: Qword:=(others=> (others => "XXXXXXXX"));
begin 
	process
		variable Key, Text: DQWord;
		variable Round: integer; -- Counter for rounds
		variable RoundKeys, RoundText: RoundData;
		variable work: boolean:=false; -- Used to indicate if the encryption is happening
		variable read_in: natural:=0; -- Used to indicate which set of data is being read
	begin
		
		done<='0';
		if(clk = '1') then
			if(start = '1' or work) then -- Reads the data
				work:= true;
				if(read_in < 4) then -- Loads in the data/key
					case read_in is
						when 0 =>
							Text:=input(IO,'1',Text); -- Loads the upper data
							read_in:= read_in+1;
						when 1 =>
							Text:=input(IO,'0',Text); -- Loads the upper data
							read_in:= read_in+1;
						when 2 =>
							Key:=input(IO,'1',Key); -- Loads the upper key
							read_in:= read_in+1;
						when 3 =>
							Key:=input(IO,'0',Key); -- Loads the upper key
							read_in:=4; -- Stops data/key from being read
						when others=>
						null;
					end case;
				else-- Encryption/Decrption		
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
					read_in:=0; -- Allows the process to repeat
					
					--Outputs the result
					wait until clk'event and clk = '1';
					done <= '1';
					A<= output(RoundText(12),'1');
					wait until clk'event and clk = '1';
					A<= output(RoundText(12),'0');
					wait until clk'event and clk = '1';
					work:= false;
				end if;
			end if;
		end if;
		wait on clk;
	end process;
	
	IO<= A when (done = '1') else (others => (others => "ZZZZZZZZ"));
	
end behavioral;