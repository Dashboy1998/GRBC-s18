library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DoubleQWord.all;
use work.LUT_array.all;
use work.byte.all;
use work.Sbox_Transformation.all;

package KeyExpansionFunc is
	type word is array (0 to 3) of byte;
	function sbox(X: Word) return word; -- Function for sbox transformation
	function rolw(X: Word) return Word; -- Function to rotate words left
	function rcon(X: integer) return byte; -- Function for rcon
	function KeyEx(X: DQWord; R: integer) return DQWord; -- Function for Key expansion 
	constant rcon_LUT : array_256 := (
	X"B1",X"01",X"02",X"04",X"08",X"10",X"20",X"40",X"80",X"63",X"C6",X"EF",X"BD",X"19",X"32",X"64",	
	X"C8",X"F3",X"85",X"69",X"D2",X"C7",X"ED",X"B9",X"11",X"22",X"44",X"88",X"73",X"E6",X"AF",X"3D",	
	X"7A",X"F4",X"8B",X"75",X"EA",X"B7",X"0D",X"1A",X"34",X"68",X"D0",X"C3",X"E5",X"A9",X"31",X"62",	
	X"C4",X"EB",X"B5",X"09",X"12",X"24",X"48",X"90",X"43",X"86",X"6F",X"DE",X"DF",X"DD",X"D9",X"D1",	
	X"C1",X"E1",X"A1",X"21",X"42",X"84",X"6B",X"D6",X"CF",X"FD",X"99",X"51",X"A2",X"27",X"4E",X"9C",	
	X"5B",X"B6",X"0F",X"1E",X"3C",X"78",X"F0",X"83",X"65",X"CA",X"F7",X"8D",X"79",X"F2",X"87",X"6D",	
	X"DA",X"D7",X"CD",X"F9",X"91",X"41",X"82",X"67",X"CE",X"FF",X"9D",X"59",X"B2",X"07",X"0E",X"1C",
	X"38",X"70",X"E0",X"A3",X"25",X"4A",X"94",X"4B",X"96",X"4F",X"9E",X"5F",X"BE",X"1F",X"3E",X"7C",
	X"F8",X"93",X"45",X"8A",X"77",X"EE",X"BF",X"1D",X"3A",X"74",X"E8",X"B3",X"05",X"0A",X"14",X"28",
	X"50",X"A0",X"23",X"46",X"8C",X"7B",X"F6",X"8F",X"7D",X"FA",X"97",X"4D",X"9A",X"57",X"AE",X"3F",
	X"7E",X"FC",X"9B",X"55",X"AA",X"37",X"6E",X"DC",X"DB",X"D5",X"C9",X"F1",X"81",X"61",X"C2",X"E7",
	X"AD",X"39",X"72",X"E4",X"AB",X"35",X"6A",X"D4",X"CB",X"F5",X"89",X"71",X"E2",X"A7",X"2D",X"5A",
	X"B4",X"0B",X"16",X"2C",X"58",X"B0",X"03",X"06",X"0C",X"18",X"30",X"60",X"C0",X"E3",X"A5",X"29",
	X"52",X"A4",X"2B",X"56",X"AC",X"3B",X"76",X"EC",X"BB",X"15",X"2A",X"54",X"A8",X"33",X"66",X"CC",
	X"FB",X"95",X"49",X"92",X"47",X"8E",X"7F",X"FE",X"9F",X"5D",X"BA",X"17",X"2E",X"5C",X"B8",X"13",
	X"26",X"4C",X"98",X"53",X"A6",X"2F",X"5E",X"BC",X"1B",X"36",X"6C",X"D8",X"D3",X"C5",X"E9",X"B1"
	);
	
end KeyExpansionFunc;

package body KeyExpansionFunc is
	function sbox(X: Word) -- sbox on the last word
		return Word is	
		variable trans: word:=X;
	begin
		for i in 0 to 3 loop
			trans(i) := sbox_LUT(to_integer(unsigned(X(i))));
		end loop;
		return trans;
	end sbox;
	function rolw(X: word)-- Function to rotate words left
		return word is
		variable rword: word:=X;
	begin			 
		rword(0):= X(1); 
		rword(1):= X(2);
		rword(2):= X(3);
		rword(3):= X(0);
		return rword;
	end rolw;
	function rcon(X: integer) -- Function to return rcon value
		return byte is
	begin
		return rcon_LUT(X); 
	end rcon;
	function KeyEx(X: DQWord; R: integer) -- Function for key expanison, R indicates round number, Y is used to indicate encryption or decryption
		return DQWORD is
		variable EKey: DQWord;
		variable T: word;
	begin
		for i in 0 to 3 loop
			T(i):= X(3,i); -- Sets T to equal the last word
		end loop;
		T:=rolw(T); -- Rotates T left by 1 byte
		T:=sbox(T); -- Sbox substitution
		T(0):=(T(0) xor rcon(R)); -- XORs the first byte with the rcon value
		
		for i in 0 to 3	loop
			for j in 0 to 3 loop -- loops to calculate the words of the expanded key
				if(i=0) then
					EKey(i,j):=(T(j) xor X(i,j)); -- Calculates the first word
				else
					EKey(i,j):=(EKey(i-1,j) xor X(i,j));
				end if;
			end loop;
		end loop;
		return EKey;
	end KeyEx;
end KeyExpansionFunc;