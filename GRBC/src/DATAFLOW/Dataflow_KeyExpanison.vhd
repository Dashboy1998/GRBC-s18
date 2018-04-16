library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.byte.all;
use work.rcon_table.all;
use ieee.numeric_std.all;
use work.Sbox_Transformation.all;
use work.word.all;

entity KeyExpansion is -- Entity for doing round 1 - 12 of key expansion
	port(
		Key: in DQWord;
		nextKey: inout DQWord;
		round: integer;
		clk: in std_logic
		);
end KeyExpansion;

architecture dataflow of KeyExpansion is
	signal R: byte;
	signal T: word;
begin
	R<= rcon_LUT(round); -- Finds the Rcon for the round
	
	-- Calculates T
	T(0)<= sbox_and_Inv(to_integer(unsigned('0' & Key(3,1)))) xor R;	 
	T(1)<= sbox_and_Inv(to_integer(unsigned('0' & Key(3,2))));
	T(2)<= sbox_and_Inv(to_integer(unsigned('0' & Key(3,3))));
	T(3)<= sbox_and_Inv(to_integer(unsigned('0' & Key(3,0))));
	
	process(clk)
	begin
		if(clk = '1') then -- Calculates the next key (Would be done with XOR gates in series)
			if(round = 0) then
				NextKey<= Key;
			else
				for i in 0 to 3 loop
					for j in 0 to 3 loop
						if(i = 0) then
							nextKey(i,j)<= Key(i,j) xor T(j);
						else
							nextKey(i,j)<= Key(i,j) xor Key(i-1,j);
						end if;
					end loop;
				end loop;
			end if;
		end if;
	end process;
	
end dataflow;