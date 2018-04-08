--This function is for reading and writting data
--Writting is a work in progress
library ieee;
use ieee.std_logic_1164.all;
use work.byte.all;
use work.DoubleQWord.all;

package stream is
	type QWord is array (0 to 1, 0 to 3) of byte; -- type for input/output
	function input(D: QWord; LU: std_logic; CD: DQWord) return DQWord; --function to read in QWords into our DQWords
	function output(D: DQWord; LU: std_logic) return Qword; --function to extract QWord from DQWord
end stream;						   

package body stream is
	function output(D: DQWord; LU: std_logic) 
		return Qword is
		variable outval: Qword;
	begin
		row:	for i in 0 to 1 loop
			col:	for j in 0 to 3 loop
				if(LU='1') then
					outval(i,j):=D(i,j);
				else
					outval(i,j):=D(2+i,j);
				end if;
			end loop col;
		end loop row;
		return outval;
	end output;
	function input(D: Qword; LU: std_logic; CD: DQWord)
		return DQWord is
		variable data: DQWord:=CD;
	begin
		for i in 0 to 1 loop -- Loads the word
			for j in 0 to 3 loop -- Loads the byte
				if(LU = '0') then -- Reads lower bound of data
					data(3-i,j):=D(1-i,j);
				else -- Reads upper bound of data
					data(1-i,j):=D(1-i,j);
				end if;
			end loop;
		end loop;	
		return data;
	end input;
end stream;