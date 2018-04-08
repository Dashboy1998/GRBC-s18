use work.LUT_array.all;

package Sbox_Transformation is
	constant sbox_LUT : array_256 := (
	X"63",X"7C",X"E1",X"60",X"2F",X"62",X"E2",X"68",X"48",X"6C",X"E3",X"34",X"AE",X"29",X"E6",X"95",
	X"FB",X"CE",X"E9",X"8F",X"2E",X"0D",X"C5",X"53",X"85",X"4D",X"46",X"66",X"A1",X"A7",X"15",X"EB",
	X"22",X"1B",X"B8",X"16",X"2B",X"A5",X"18",X"D6",X"C8",X"9D",X"54",X"79",X"3D",X"9F",X"76",X"65",
	X"1D",X"17",X"74",X"0E",X"F1",X"31",X"EC",X"51",X"0F",X"8C",X"01",X"AB",X"58",X"43",X"2A",X"B0",
	X"C3",X"DB",X"52",X"6A",X"83",X"32",X"D9",X"8A",X"47",X"EA",X"00",X"30",X"D3",X"D2",X"B4",X"B7",
	X"B6",X"81",X"11",X"4F",X"F8",X"B1",X"6E",X"02",X"41",X"7B",X"10",X"96",X"E4",X"8D",X"6D",X"5B",
	X"5C",X"F5",X"59",X"4B",X"E5",X"B9",X"D5",X"40",X"27",X"06",X"4A",X"A9",X"A4",X"C4",X"77",X"21",
	X"55",X"9E",X"99",X"56",X"5F",X"05",X"0A",X"37",X"F3",X"2C",X"7E",X"C0",X"C7",X"9C",X"87",X"14",
	X"33",X"4E",X"3F",X"CC",X"F6",X"B3",X"E7",X"36",X"13",X"98",X"CB",X"AF",X"3E",X"FD",X"97",X"86",
	X"71",X"08",X"AA",X"C1",X"DF",X"70",X"CA",X"1A",X"3B",X"A6",X"BB",X"DC",X"88",X"49",X"09",X"BE",
	X"89",X"93",X"12",X"EE",X"57",X"84",X"75",X"9A",X"A3",X"8B",X"07",X"DD",X"E8",X"BC",X"DE",X"23",
	X"7F",X"5D",X"6F",X"61",X"D7",X"67",X"94",X"F7",X"A0",X"38",X"19",X"BF",X"69",X"25",X"72",X"F0",
	X"FC",X"BA",X"28",X"F4",X"73",X"9B",X"7A",X"3A",X"20",X"CD",X"03",X"A2",X"35",X"D4",X"FF",X"5A",
	X"4C",X"D0",X"D1",X"92",X"FA",X"24",X"0B",X"0C",X"80",X"04",X"BD",X"ED",X"64",X"AD",X"42",X"FE",
	X"78",X"82",X"90",X"AC",X"1E",X"A8",X"F9",X"C6",X"7D",X"1F",X"50",X"6B",X"DA",X"CF",X"44",X"EF",
	X"26",X"39",X"C9",X"C2",X"E0",X"8E",X"B2",X"5E",X"3C",X"B5",X"91",X"45",X"1C",X"F2",X"D8",X"2D"
	);
	constant invsbox_LUT : array_256 := (   
	X"4A",X"3A",X"57",X"CA",X"D9",X"75",X"69",X"AA",X"91",X"9E",X"76",X"D6",X"D7",X"15",X"33",X"38",
	X"5A",X"52",X"A2",X"88",X"7F",X"1E",X"23",X"31",X"26",X"BA",X"97",X"21",X"FC",X"30",X"E4",X"E9",
	X"C8",X"6F",X"20",X"AF",X"D5",X"BD",X"F0",X"68",X"C2",X"0D",X"3E",X"24",X"79",X"FF",X"14",X"04",
	X"4B",X"35",X"45",X"80",X"0B",X"CC",X"87",X"77",X"B9",X"F1",X"C7",X"98",X"F8",X"2C",X"8C",X"82",
	X"67",X"58",X"DE",X"3D",X"EE",X"FB",X"1A",X"48",X"08",X"9D",X"6A",X"63",X"D0",X"19",X"81",X"53",
	X"EA",X"37",X"42",X"17",X"2A",X"70",X"73",X"A4",X"3C",X"62",X"CF",X"5F",X"60",X"B1",X"F7",X"74",    
	X"03",X"B3",X"05",X"00",X"DC",X"2F",X"1B",X"B5",X"07",X"BC",X"43",X"EB",X"09",X"5E",X"56",X"B2",    
	X"95",X"90",X"BE",X"C4",X"32",X"A6",X"2E",X"6E",X"E0",X"2B",X"C6",X"59",X"01",X"E8",X"7A",X"B0",    
	X"D8",X"51",X"E1",X"44",X"A5",X"18",X"8F",X"7E",X"9C",X"A0",X"47",X"A9",X"39",X"5D",X"F5",X"13",
	X"E2",X"FA",X"D3",X"A1",X"B6",X"0F",X"5B",X"8E",X"89",X"72",X"A7",X"C5",X"7D",X"29",X"71",X"2D",
	X"B8",X"1C",X"CB",X"A8",X"6C",X"25",X"99",X"1D",X"E5",X"6B",X"92",X"3B",X"E3",X"DD",X"0C",X"8B",
	X"3F",X"55",X"F6",X"85",X"4E",X"F9",X"50",X"4F",X"22",X"65",X"C1",X"9A",X"AD",X"DA",X"9F",X"BB",
	X"7B",X"93",X"F3",X"40",X"6D",X"16",X"E7",X"7C",X"28",X"F2",X"96",X"8A",X"83",X"C9",X"11",X"ED",
	X"D1",X"D2",X"4D",X"4C",X"CD",X"66",X"27",X"B4",X"FE",X"46",X"EC",X"41",X"9B",X"AB",X"AE",X"94",
	X"F4",X"02",X"06",X"0A",X"5C",X"64",X"0E",X"86",X"AC",X"12",X"49",X"1F",X"36",X"DB",X"A3",X"EF",
	X"BF",X"34",X"FD",X"78",X"C3",X"61",X"84",X"B7",X"54",X"E6",X"D4",X"10",X"C0",X"8D",X"DF",X"CE"
	);
end Sbox_Transformation;