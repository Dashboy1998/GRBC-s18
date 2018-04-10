library ieee;
use ieee.std_logic_1164.all;
use work.stream.all;

entity GRBC is
	port(
		-- IO should be inout however I cannot get it to work in testbench as inout
		IO: inout Qword;--:=((others => (others => "ZZZZZZZZ"))); -- Used as input for plain text/cipher and key, and output of plain text/cipher
		-- Change PK to DK to mean data and key
		DK: in std_logic; -- Used to indicate if writting plain text/cihper or key
		-- LU should be inout. Assume device plugged into uses tristate buffers for read/writing data
		-- and a mux for which side of bits writting
		LU: inout std_logic:='Z'; -- Used to indicate upper or lower bound of data being inputted
		ED: in std_logic; -- Used to indicate if encrypting or decrypting
		RD: in std_logic; -- Used to indicate reading data
		Start: in std_logic; -- Used to start the encrpytion/decryption
		Clk: in std_logic; -- Clk signal
		Done: inout std_logic:='0' -- Signal to indicate if done
		);
end entity;	 