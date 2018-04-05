library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DoubleQWord.all;
use work.byte.all;
use work.Sbox_Transformation.all;
use work.mult_x.all;


package Encryption is	
	function XDQWord(X: DQWord; Y: DQWord) return DQWord; -- XORs two DQWords
	function SBox(X: DQWord) return DQWord; -- for sbox by DQWord
	function shift(X: DQword) return DQword; -- Function for shifting left
	function MixColumn(W: DQWord) return DQWord; -- Encrypt		   
	function Cipher(P: DQWord; E: DQWord; R: integer) return DQWord; -- MixColumn math 
end Encryption;


package body Encryption is
	function XDQWord(X: DQWord; Y: DQWord)
		return DQWord is
		variable rword: DQWord;
	begin
		for i in 0 to 3 loop -- columns
			for j in 0 to 3 loop -- rows
				rword(i,j):= X(i,j) xor Y(i,j);
			end loop;
		end loop;
		return rword;
	end XDQWord;
	function SBox(X: DQword) 
		return DQWORD is	
		variable trans: DQword;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				trans(i,j) := sbox_LUT(to_integer(unsigned(X(i,j))));
			end loop;
		end loop;
		return trans;
	end sbox;
	function shift(X: DQword) -- Function to rotate left
		return DQWord is
		variable rword: DQWord:=X;
		variable tword: DQWord:=X;
	begin			 										
		for i in 1 to 3 loop -- loop to rotate right
			for j in 1 to i loop -- loop to rotate i times
				rword(0,i):= tword(1,i); 
				rword(1,i):= tword(2,i);
				rword(2,i):= tword(3,i);
				rword(3,i):= tword(0,i);
				tword:=rword;
			end loop;
		end loop;
		return rword;
	end shift;
	function MixColumn(W: DQWord) -- MixColum Math
		return DQWord is
		variable MX: DQword;
		variable R, P: byte;
		variable C: integer;
	begin
		for i in 0 to 3 loop -- indexes row of result
			for j in 0 to 3 loop -- indexes column of result
				for k in 0 to 3 loop -- used to index row of forwardMix, and index column of W.
					C:= to_integer(unsigned(forwardMix_GRBC_S18(i,k)));
					R:=W(j,k);
					case C is
						when 3 =>
						P:= mult_3(to_integer(unsigned(R)));
						when 4 =>
						P:= mult_4(to_integer(unsigned(R)));
						when 7 =>
						P:= mult_7(to_integer(unsigned(R)));
						when others =>
						P:=R;
					end case;
					if(k/=0) then 
						MX(j,i):= MX(j,i) xor P;
					else
						MX(j,i):=P;
					end if;
				end loop;
			end loop;
		end loop;
		return MX;
	end MixColumn;
	function Cipher(P: DQWord; E: DQWord; R: integer)
		return DQWord is
		variable Er: DQWord:= P;
	begin
		if(R /= 0) then -- Skipped for Round 0 (STIRCTLY ENCPYTION)
			ER:=SBox(P);
			Er:= shift(Er);-- Rotate
			if(R /= 12) then -- Skipped for round 12
				-- Mix columns
				Er:= MixColumn(Er);
			end if;
		end if;
		Er:=XDQWord(Er, E);-- XORs both the words, also called AddRoundKey
		return Er;
	end Cipher;			
end Encryption;