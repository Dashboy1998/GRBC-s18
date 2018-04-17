library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.byte.all;
use ieee.numeric_std.all;
use work.Sbox_Transformation.all;

entity MixColumn is
	port(
	Data: in DQWord;
	Mixed: out DQword;
	ED: in std_logic;
	clk: in std_logic
	);
end entity;

architecture dataflow of Mixcolumn is
begin
	
end architecture;