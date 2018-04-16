library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;

entity KeyStorage is
	port(
		rw: in std_logic; -- Used to indicate if reading or writing
		round: in integer; -- Indicates which key to read/write
		Key: inout DQWord; 
		clk: in std_logic
		); 
end KeyStorage;

architecture dataflow of KeyStorage is
	signal Keys: RoundData;
	signal KeyOut: DQWord;
begin
	
	process(clk)
	begin
		if(clk = '1') then
			if(rw = '0') then -- Reads data
				KeyOut<=Keys(round);
			else -- Writes data
				Keys(round)<=Key;
			end if;
		end if;
	end process;
	
	Key<= KeyOut when rw = '0' else (others => (others => "ZZZZZZZZ"));
end dataflow;
