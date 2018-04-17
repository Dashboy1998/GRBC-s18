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
		Keys: inout RoundData;
		enable: in std_logic;	  
		done: out std_logic:='0';
		clk: in std_logic
		);
end KeyExpansion;

architecture dataflow of KeyExpansion is
	signal R: byte;
	signal T: word;
	signal PrevKey, NextKey: DQWord;
	signal Round: natural:=0;
begin
	R<= rcon_LUT(round); -- Finds the Rcon for the round
	PrevKey<= Keys(round - 1) when round /= 0 else key;
		
	-- Calculates T
	T(0)<= sbox_and_Inv(to_integer(unsigned('0' & PrevKey(3,1)))) xor R;	 
	T(1)<= sbox_and_Inv(to_integer(unsigned('0' & PrevKey(3,2))));
	T(2)<= sbox_and_Inv(to_integer(unsigned('0' & PrevKey(3,3))));
	T(3)<= sbox_and_Inv(to_integer(unsigned('0' & PrevKey(3,0))));
	
	--W4 = W0 xor T
	nextKey(0,0)<= PrevKey(0,0) xor T(0);
	nextKey(0,1)<= PrevKey(0,1) xor T(1);
	nextKey(0,2)<= PrevKey(0,2) xor T(2);
	nextKey(0,3)<= PrevKey(0,3) xor T(3);
	
	--W5 = W1 xor W4
	nextKey(1,0)<= PrevKey(1,0) xor nextKey(0,0);
	nextKey(1,1)<= PrevKey(1,1) xor nextKey(0,1);
	nextKey(1,2)<= PrevKey(1,2) xor nextKey(0,2);
	nextKey(1,3)<= PrevKey(1,3) xor nextKey(0,3);
	
	--W6 = W2 xor W5
	nextKey(2,0)<= PrevKey(2,0) xor nextKey(1,0);
	nextKey(2,1)<= PrevKey(2,1) xor nextKey(1,1);
	nextKey(2,2)<= PrevKey(2,2) xor nextKey(1,2);
	nextKey(2,3)<= PrevKey(2,3) xor nextKey(1,3);
	
	--W7 = W3 xor W6
	nextKey(3,0)<= PrevKey(3,0) xor nextKey(2,0);
	nextKey(3,1)<= PrevKey(3,1) xor nextKey(2,1);
	nextKey(3,2)<= PrevKey(3,2) xor nextKey(2,2);
	nextKey(3,3)<= PrevKey(3,3) xor nextKey(2,3);
	
	process(clk)
	begin
		if(enable = '1' and clk = '1') then -- Calculates the next key (Would be done with XOR gates in series)
			if(round = 0) then
				Keys(0)<= Key;
			else
				Keys(round)<=NextKey;
			end if;		 
			if(round = 12) then
				done<= '1';
			else
				round<= round + 1;
			end if;
		end if;
	end process;
	
end dataflow;