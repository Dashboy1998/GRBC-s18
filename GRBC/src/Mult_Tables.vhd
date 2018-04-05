--Package to hold multiplication tables & Mix Matrices

use work.DoubleQWord.all; 
use work.LUT_array.all;

package mult_x is
	--Mix Matrices
	constant forwardMix_GRBC_S18 : DQWord := (
	(X"03", X"04", X"01", X"07"),
	(X"07", X"03", X"04", X"01"),
	(X"01", X"07", X"03", X"04"),
	(X"04", X"01", X"07", X"03")
	);
	constant inverseMix_GRBC_S18 : DQWord := (
	(X"09", X"0B", X"0B", X"08"),
	(X"08", X"09", X"0B", X"0B"),
	(X"0B", X"08", X"09", X"0B"),
	(X"0B", X"0B", X"08", X"09")
	);
	
	--Multiplication tables
	constant mult_3 : array_256 := (
	X"00",X"03",X"06",X"05",X"0C",X"0F",X"0A",X"09",X"18",X"1B",X"1E",X"1D",X"14",X"17",X"12",X"11",
	X"30",X"33",X"36",X"35",X"3C",X"3F",X"3A",X"39",X"28",X"2B",X"2E",X"2D",X"24",X"27",X"22",X"21",
	X"60",X"63",X"66",X"65",X"6C",X"6F",X"6A",X"69",X"78",X"7B",X"7E",X"7D",X"74",X"77",X"72",X"71",
	X"50",X"53",X"56",X"55",X"5C",X"5F",X"5A",X"59",X"48",X"4B",X"4E",X"4D",X"44",X"47",X"42",X"41",
	X"C0",X"C3",X"C6",X"C5",X"CC",X"CF",X"CA",X"C9",X"D8",X"DB",X"DE",X"DD",X"D4",X"D7",X"D2",X"D1",
	X"F0",X"F3",X"F6",X"F5",X"FC",X"FF",X"FA",X"F9",X"E8",X"EB",X"EE",X"ED",X"E4",X"E7",X"E2",X"E1",
	X"A0",X"A3",X"A6",X"A5",X"AC",X"AF",X"AA",X"A9",X"B8",X"BB",X"BE",X"BD",X"B4",X"B7",X"B2",X"B1",
	X"90",X"93",X"96",X"95",X"9C",X"9F",X"9A",X"99",X"88",X"8B",X"8E",X"8D",X"84",X"87",X"82",X"81",
	X"E3",X"E0",X"E5",X"E6",X"EF",X"EC",X"E9",X"EA",X"FB",X"F8",X"FD",X"FE",X"F7",X"F4",X"F1",X"F2",
	X"D3",X"D0",X"D5",X"D6",X"DF",X"DC",X"D9",X"DA",X"CB",X"C8",X"CD",X"CE",X"C7",X"C4",X"C1",X"C2",
	X"83",X"80",X"85",X"86",X"8F",X"8C",X"89",X"8A",X"9B",X"98",X"9D",X"9E",X"97",X"94",X"91",X"92",
	X"B3",X"B0",X"B5",X"B6",X"BF",X"BC",X"B9",X"BA",X"AB",X"A8",X"AD",X"AE",X"A7",X"A4",X"A1",X"A2",
	X"23",X"20",X"25",X"26",X"2F",X"2C",X"29",X"2A",X"3B",X"38",X"3D",X"3E",X"37",X"34",X"31",X"32",
	X"13",X"10",X"15",X"16",X"1F",X"1C",X"19",X"1A",X"0B",X"08",X"0D",X"0E",X"07",X"04",X"01",X"02",
	X"43",X"40",X"45",X"46",X"4F",X"4C",X"49",X"4A",X"5B",X"58",X"5D",X"5E",X"57",X"54",X"51",X"52",
	X"73",X"70",X"75",X"76",X"7F",X"7C",X"79",X"7A",X"6B",X"68",X"6D",X"6E",X"67",X"64",X"61",X"62"
	);
	constant mult_4 : array_256 := (
	X"00",X"04",X"08",X"0C",X"10",X"14",X"18",X"1C",X"20",X"24",X"28",X"2C",X"30",X"34",X"38",X"3C",
	X"40",X"44",X"48",X"4C",X"50",X"54",X"58",X"5C",X"60",X"64",X"68",X"6C",X"70",X"74",X"78",X"7C",
	X"80",X"84",X"88",X"8C",X"90",X"94",X"98",X"9C",X"A0",X"A4",X"A8",X"AC",X"B0",X"B4",X"B8",X"BC",
	X"C0",X"C4",X"C8",X"CC",X"D0",X"D4",X"D8",X"DC",X"E0",X"E4",X"E8",X"EC",X"F0",X"F4",X"F8",X"FC",
	X"63",X"67",X"6B",X"6F",X"73",X"77",X"7B",X"7F",X"43",X"47",X"4B",X"4F",X"53",X"57",X"5B",X"5F",
	X"23",X"27",X"2B",X"2F",X"33",X"37",X"3B",X"3F",X"03",X"07",X"0B",X"0F",X"13",X"17",X"1B",X"1F",
	X"E3",X"E7",X"EB",X"EF",X"F3",X"F7",X"FB",X"FF",X"C3",X"C7",X"CB",X"CF",X"D3",X"D7",X"DB",X"DF",
	X"A3",X"A7",X"AB",X"AF",X"B3",X"B7",X"BB",X"BF",X"83",X"87",X"8B",X"8F",X"93",X"97",X"9B",X"9F",
	X"C6",X"C2",X"CE",X"CA",X"D6",X"D2",X"DE",X"DA",X"E6",X"E2",X"EE",X"EA",X"F6",X"F2",X"FE",X"FA",
	X"86",X"82",X"8E",X"8A",X"96",X"92",X"9E",X"9A",X"A6",X"A2",X"AE",X"AA",X"B6",X"B2",X"BE",X"BA",
	X"46",X"42",X"4E",X"4A",X"56",X"52",X"5E",X"5A",X"66",X"62",X"6E",X"6A",X"76",X"72",X"7E",X"7A",
	X"06",X"02",X"0E",X"0A",X"16",X"12",X"1E",X"1A",X"26",X"22",X"2E",X"2A",X"36",X"32",X"3E",X"3A",
	X"A5",X"A1",X"AD",X"A9",X"B5",X"B1",X"BD",X"B9",X"85",X"81",X"8D",X"89",X"95",X"91",X"9D",X"99",
	X"E5",X"E1",X"ED",X"E9",X"F5",X"F1",X"FD",X"F9",X"C5",X"C1",X"CD",X"C9",X"D5",X"D1",X"DD",X"D9",
	X"25",X"21",X"2D",X"29",X"35",X"31",X"3D",X"39",X"05",X"01",X"0D",X"09",X"15",X"11",X"1D",X"19",
	X"65",X"61",X"6D",X"69",X"75",X"71",X"7D",X"79",X"45",X"41",X"4D",X"49",X"55",X"51",X"5D",X"59"
	);
	constant mult_7 : array_256 := (
	X"00",X"07",X"0E",X"09",X"1C",X"1B",X"12",X"15",X"38",X"3F",X"36",X"31",X"24",X"23",X"2A",X"2D",
	X"70",X"77",X"7E",X"79",X"6C",X"6B",X"62",X"65",X"48",X"4F",X"46",X"41",X"54",X"53",X"5A",X"5D",
	X"E0",X"E7",X"EE",X"E9",X"FC",X"FB",X"F2",X"F5",X"D8",X"DF",X"D6",X"D1",X"C4",X"C3",X"CA",X"CD",
	X"90",X"97",X"9E",X"99",X"8C",X"8B",X"82",X"85",X"A8",X"AF",X"A6",X"A1",X"B4",X"B3",X"BA",X"BD",
	X"A3",X"A4",X"AD",X"AA",X"BF",X"B8",X"B1",X"B6",X"9B",X"9C",X"95",X"92",X"87",X"80",X"89",X"8E",
	X"D3",X"D4",X"DD",X"DA",X"CF",X"C8",X"C1",X"C6",X"EB",X"EC",X"E5",X"E2",X"F7",X"F0",X"F9",X"FE",
	X"43",X"44",X"4D",X"4A",X"5F",X"58",X"51",X"56",X"7B",X"7C",X"75",X"72",X"67",X"60",X"69",X"6E",
	X"33",X"34",X"3D",X"3A",X"2F",X"28",X"21",X"26",X"0B",X"0C",X"05",X"02",X"17",X"10",X"19",X"1E",
	X"25",X"22",X"2B",X"2C",X"39",X"3E",X"37",X"30",X"1D",X"1A",X"13",X"14",X"01",X"06",X"0F",X"08",
	X"55",X"52",X"5B",X"5C",X"49",X"4E",X"47",X"40",X"6D",X"6A",X"63",X"64",X"71",X"76",X"7F",X"78",
	X"C5",X"C2",X"CB",X"CC",X"D9",X"DE",X"D7",X"D0",X"FD",X"FA",X"F3",X"F4",X"E1",X"E6",X"EF",X"E8",
	X"B5",X"B2",X"BB",X"BC",X"A9",X"AE",X"A7",X"A0",X"8D",X"8A",X"83",X"84",X"91",X"96",X"9F",X"98",
	X"86",X"81",X"88",X"8F",X"9A",X"9D",X"94",X"93",X"BE",X"B9",X"B0",X"B7",X"A2",X"A5",X"AC",X"AB",
	X"F6",X"F1",X"F8",X"FF",X"EA",X"ED",X"E4",X"E3",X"CE",X"C9",X"C0",X"C7",X"D2",X"D5",X"DC",X"DB",
	X"66",X"61",X"68",X"6F",X"7A",X"7D",X"74",X"73",X"5E",X"59",X"50",X"57",X"42",X"45",X"4C",X"4B",
	X"16",X"11",X"18",X"1F",X"0A",X"0D",X"04",X"03",X"2E",X"29",X"20",X"27",X"32",X"35",X"3C",X"3B"
	);
	constant mult_8 : array_256 := (
	X"00",X"08",X"10",X"18",X"20",X"28",X"30",X"38",X"40",X"48",X"50",X"58",X"60",X"68",X"70",X"78",
	X"80",X"88",X"90",X"98",X"A0",X"A8",X"B0",X"B8",X"C0",X"C8",X"D0",X"D8",X"E0",X"E8",X"F0",X"F8",
	X"63",X"6B",X"73",X"7B",X"43",X"4B",X"53",X"5B",X"23",X"2B",X"33",X"3B",X"03",X"0B",X"13",X"1B",
	X"E3",X"EB",X"F3",X"FB",X"C3",X"CB",X"D3",X"DB",X"A3",X"AB",X"B3",X"BB",X"83",X"8B",X"93",X"9B",
	X"C6",X"CE",X"D6",X"DE",X"E6",X"EE",X"F6",X"FE",X"86",X"8E",X"96",X"9E",X"A6",X"AE",X"B6",X"BE",
	X"46",X"4E",X"56",X"5E",X"66",X"6E",X"76",X"7E",X"06",X"0E",X"16",X"1E",X"26",X"2E",X"36",X"3E",
	X"A5",X"AD",X"B5",X"BD",X"85",X"8D",X"95",X"9D",X"E5",X"ED",X"F5",X"FD",X"C5",X"CD",X"D5",X"DD",
	X"25",X"2D",X"35",X"3D",X"05",X"0D",X"15",X"1D",X"65",X"6D",X"75",X"7D",X"45",X"4D",X"55",X"5D",
	X"EF",X"E7",X"FF",X"F7",X"CF",X"C7",X"DF",X"D7",X"AF",X"A7",X"BF",X"B7",X"8F",X"87",X"9F",X"97",
	X"6F",X"67",X"7F",X"77",X"4F",X"47",X"5F",X"57",X"2F",X"27",X"3F",X"37",X"0F",X"07",X"1F",X"17",
	X"8C",X"84",X"9C",X"94",X"AC",X"A4",X"BC",X"B4",X"CC",X"C4",X"DC",X"D4",X"EC",X"E4",X"FC",X"F4",
	X"0C",X"04",X"1C",X"14",X"2C",X"24",X"3C",X"34",X"4C",X"44",X"5C",X"54",X"6C",X"64",X"7C",X"74",
	X"29",X"21",X"39",X"31",X"09",X"01",X"19",X"11",X"69",X"61",X"79",X"71",X"49",X"41",X"59",X"51",
	X"A9",X"A1",X"B9",X"B1",X"89",X"81",X"99",X"91",X"E9",X"E1",X"F9",X"F1",X"C9",X"C1",X"D9",X"D1",
	X"4A",X"42",X"5A",X"52",X"6A",X"62",X"7A",X"72",X"0A",X"02",X"1A",X"12",X"2A",X"22",X"3A",X"32",
	X"CA",X"C2",X"DA",X"D2",X"EA",X"E2",X"FA",X"F2",X"8A",X"82",X"9A",X"92",X"AA",X"A2",X"BA",X"B2"
	);
	constant mult_9 : array_256 := (
	X"00",X"09",X"12",X"1B",X"24",X"2D",X"36",X"3F",X"48",X"41",X"5A",X"53",X"6C",X"65",X"7E",X"77",
	X"90",X"99",X"82",X"8B",X"B4",X"BD",X"A6",X"AF",X"D8",X"D1",X"CA",X"C3",X"FC",X"F5",X"EE",X"E7",
	X"43",X"4A",X"51",X"58",X"67",X"6E",X"75",X"7C",X"0B",X"02",X"19",X"10",X"2F",X"26",X"3D",X"34",
	X"D3",X"DA",X"C1",X"C8",X"F7",X"FE",X"E5",X"EC",X"9B",X"92",X"89",X"80",X"BF",X"B6",X"AD",X"A4",
	X"86",X"8F",X"94",X"9D",X"A2",X"AB",X"B0",X"B9",X"CE",X"C7",X"DC",X"D5",X"EA",X"E3",X"F8",X"F1",
	X"16",X"1F",X"04",X"0D",X"32",X"3B",X"20",X"29",X"5E",X"57",X"4C",X"45",X"7A",X"73",X"68",X"61",
	X"C5",X"CC",X"D7",X"DE",X"E1",X"E8",X"F3",X"FA",X"8D",X"84",X"9F",X"96",X"A9",X"A0",X"BB",X"B2",
	X"55",X"5C",X"47",X"4E",X"71",X"78",X"63",X"6A",X"1D",X"14",X"0F",X"06",X"39",X"30",X"2B",X"22",
	X"6F",X"66",X"7D",X"74",X"4B",X"42",X"59",X"50",X"27",X"2E",X"35",X"3C",X"03",X"0A",X"11",X"18",
	X"FF",X"F6",X"ED",X"E4",X"DB",X"D2",X"C9",X"C0",X"B7",X"BE",X"A5",X"AC",X"93",X"9A",X"81",X"88",
	X"2C",X"25",X"3E",X"37",X"08",X"01",X"1A",X"13",X"64",X"6D",X"76",X"7F",X"40",X"49",X"52",X"5B",
	X"BC",X"B5",X"AE",X"A7",X"98",X"91",X"8A",X"83",X"F4",X"FD",X"E6",X"EF",X"D0",X"D9",X"C2",X"CB",
	X"E9",X"E0",X"FB",X"F2",X"CD",X"C4",X"DF",X"D6",X"A1",X"A8",X"B3",X"BA",X"85",X"8C",X"97",X"9E",
	X"79",X"70",X"6B",X"62",X"5D",X"54",X"4F",X"46",X"31",X"38",X"23",X"2A",X"15",X"1C",X"07",X"0E",
	X"AA",X"A3",X"B8",X"B1",X"8E",X"87",X"9C",X"95",X"E2",X"EB",X"F0",X"F9",X"C6",X"CF",X"D4",X"DD",
	X"3A",X"33",X"28",X"21",X"1E",X"17",X"0C",X"05",X"72",X"7B",X"60",X"69",X"56",X"5F",X"44",X"4D"
	);
	constant mult_b : array_256 := (
	X"00",X"0B",X"16",X"1D",X"2C",X"27",X"3A",X"31",X"58",X"53",X"4E",X"45",X"74",X"7F",X"62",X"69",
	X"B0",X"BB",X"A6",X"AD",X"9C",X"97",X"8A",X"81",X"E8",X"E3",X"FE",X"F5",X"C4",X"CF",X"D2",X"D9",
	X"03",X"08",X"15",X"1E",X"2F",X"24",X"39",X"32",X"5B",X"50",X"4D",X"46",X"77",X"7C",X"61",X"6A",
	X"B3",X"B8",X"A5",X"AE",X"9F",X"94",X"89",X"82",X"EB",X"E0",X"FD",X"F6",X"C7",X"CC",X"D1",X"DA",
	X"06",X"0D",X"10",X"1B",X"2A",X"21",X"3C",X"37",X"5E",X"55",X"48",X"43",X"72",X"79",X"64",X"6F",
	X"B6",X"BD",X"A0",X"AB",X"9A",X"91",X"8C",X"87",X"EE",X"E5",X"F8",X"F3",X"C2",X"C9",X"D4",X"DF",
	X"05",X"0E",X"13",X"18",X"29",X"22",X"3F",X"34",X"5D",X"56",X"4B",X"40",X"71",X"7A",X"67",X"6C",
	X"B5",X"BE",X"A3",X"A8",X"99",X"92",X"8F",X"84",X"ED",X"E6",X"FB",X"F0",X"C1",X"CA",X"D7",X"DC",
	X"0C",X"07",X"1A",X"11",X"20",X"2B",X"36",X"3D",X"54",X"5F",X"42",X"49",X"78",X"73",X"6E",X"65",
	X"BC",X"B7",X"AA",X"A1",X"90",X"9B",X"86",X"8D",X"E4",X"EF",X"F2",X"F9",X"C8",X"C3",X"DE",X"D5",
	X"0F",X"04",X"19",X"12",X"23",X"28",X"35",X"3E",X"57",X"5C",X"41",X"4A",X"7B",X"70",X"6D",X"66",
	X"BF",X"B4",X"A9",X"A2",X"93",X"98",X"85",X"8E",X"E7",X"EC",X"F1",X"FA",X"CB",X"C0",X"DD",X"D6",
	X"0A",X"01",X"1C",X"17",X"26",X"2D",X"30",X"3B",X"52",X"59",X"44",X"4F",X"7E",X"75",X"68",X"63",
	X"BA",X"B1",X"AC",X"A7",X"96",X"9D",X"80",X"8B",X"E2",X"E9",X"F4",X"FF",X"CE",X"C5",X"D8",X"D3",
	X"09",X"02",X"1F",X"14",X"25",X"2E",X"33",X"38",X"51",X"5A",X"47",X"4C",X"7D",X"76",X"6B",X"60",
	X"B9",X"B2",X"AF",X"A4",X"95",X"9E",X"83",X"88",X"E1",X"EA",X"F7",X"FC",X"CD",X"C6",X"DB",X"D0"
	);
end mult_x;