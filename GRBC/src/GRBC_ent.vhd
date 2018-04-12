library ieee;
use ieee.std_logic_1164.all;
use work.stream.all;

entity GRBC is
	port(
		IO: inout Qword; -- Used as input for plain text/cipher and key, and output of plain text/cipher
		ED: in std_logic; -- Used to indicate if encrypting or decrypting
		Start: in std_logic; -- Used to start the encrpytion/decryption
		Clk: in std_logic; -- Clk signal
		Done: inout std_logic:='0' -- Signal to indicate if done
		);
end entity;	 