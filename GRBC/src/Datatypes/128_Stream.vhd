library ieee;
use ieee.std_logic_1164.all;
use work.byte.all;

package DoubleQWord is 		   
	type DQWord is array (0 to 3, 0 to 3) of byte;
	type RoundData is array (0 to 12) of DQWord;
	function "xor"(X: DQWord; Y: DQWord) return DQWord; -- XORs two DQWords
end DoubleQWord;

package body DoubleQWord is
	function "xor"(X: DQWord; Y: DQWord)
		return DQWord is
		variable rword: DQWord;
	begin
		for i in 0 to 3 loop -- columns
			for j in 0 to 3 loop -- rows
				rword(i,j):= X(i,j) xor Y(i,j);
			end loop;
		end loop;
		return rword;
	end "xor";
end DoubleQWord;