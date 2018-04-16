library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DoubleQWord.all;
use work.byte.all;
use work.Sbox_Transformation.all;
use work.mult_x.all;


package Decryption is  
	function XDQWord(X: DQWord; Y: DQWord) return DQWord; -- XORs two DQWords  
	function invShift(X: DQword) return DQword; -- Function for shifting right
	function invMixColumn(W: DQWord) return DQWord; -- Decrypt
	function invSBox(X: DQWord) return DQWord;
	function invCipher(C: DQWord; E: DQWord; R: integer) return DQWord; 
end Decryption;


package body Decryption is
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
	function invshift(X: DQWord)-- Function to rotate right
		return DQWord is
		variable rword, tword: DQword:=X;
	begin			 
		for i in 1 to 3 loop -- loop to rotate word left Y times
			for j in 1 to i loop -- loop to rotate i times
				rword(0,i):= tword(3,i); 
				rword(1,i):= tword(0,i);
				rword(2,i):= tword(1,i);
				rword(3,i):= tword(2,i);
				tword:=rword;
			end loop;
		end loop;
		return rword;
	end invshift;
	function invMixColumn(W: DQWord) -- MixColum Math
		return DQWord is
		variable MX: DQword;
		variable R, P: byte;
		variable C: integer;
	begin
		for i in 0 to 3 loop -- indexes row of result
			for j in 0 to 3 loop -- indexes column of result
				for k in 0 to 3 loop -- used to index row of forwardMix, and index column of W.
					C:= to_integer(unsigned(inverseMix_GRBC_S18(i,k))); 
					R:=W(j,k);
					case C is
						when 8 =>
						P:= mult_8(to_integer(unsigned(R)));
						when 9 =>
						P:= mult_9(to_integer(unsigned(R)));
						when 11 =>
						P:= mult_b(to_integer(unsigned(R)));
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
	end invMixColumn;		
	function invSBox(X: DQword) 
		return DQWORD is	
		variable trans: DQword;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				trans(i,j) := invsbox_LUT(to_integer(unsigned(X(i,j))));
			end loop;
		end loop;
		return trans;
	end invsbox;
	function invCipher(C: DQWord; E: DQWord; R: integer)
		return DQWord is
		variable Er: DQWord:= C;
	begin
		Er:=XDQWord(C, E); -- AddRoundKey
		if(R /= 0) then
			if(R /= 12) then -- Skipped for Round 0	  
				Er:= invMixColumn(Er);
			end if;
			Er:=invshift(Er);
			Er:=invSBox(Er);
		end if;
		return Er;
	end invCipher;	
end Decryption;