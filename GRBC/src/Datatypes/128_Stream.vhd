use work.byte.all;

package DoubleQWord is 		   
	type DQWord is array (0 to 3, 0 to 3) of byte;
	type RoundData is array (0 to 12) of DQWord;
end DoubleQWord;