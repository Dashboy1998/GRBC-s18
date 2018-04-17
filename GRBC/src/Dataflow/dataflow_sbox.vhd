library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.byte.all;
use ieee.numeric_std.all;
use work.Sbox_Transformation.all;
use work.word.all;

entity sbox is
	port(
		data: in DQWord;
		sdata: out DQWord;
		ED: in std_logic;
		start: in std_logic;
		done: out std_logic;
		clk: in std_logic
		);
end entity;

architecture dataflow of sbox is
	signal state: natural:=0;
	signal scount: natural:=0;
	signal inS0, inS1, inS2, inS3, S0o, S1o, S2o, S3o: byte;
begin
	-- Currently for encryption only
	-- Rotates by crossing wire
	-- Selected the bytes for sboxxing
	inS0<= data(scount, scount);
	inS1<= data(scount+1, scount) when (scount /= 3) else data(0,scount);
	inS2<= data(scount+2, scount) when (scount < 2 ) else data(scount-2,scount);
	inS3<= data(scount+3, scount) when (scount = 0) else data(scount-1,scount);
	
	-- Sboxes selected bytess
	S0o<= sbox_and_Inv(to_integer(unsigned(ED & inS0)));
	S1o<= sbox_and_Inv(to_integer(unsigned(ED & inS1)));
	S2o<= sbox_and_Inv(to_integer(unsigned(ED & inS2)));
	S3o<= sbox_and_Inv(to_integer(unsigned(ED & inS3)));
	
	process(clk)
	begin
		if(clk = '1') then
			case state is
				when 0 =>
					done<= '0';
					scount<= 0;
					if(start= '1') then -- Wait state
						state<= 1;
					else
						state<= 0;
				end if;
				when 1 =>
					-- Sets the output values (Note this would be done using MUXes)
					sdata(0,scount)<= S0o;
					sdata(1,scount)<= S1o;
					sdata(2,scount)<= S2o;
					sdata(3,scount)<= S3o;
					if(scount /= 3) then
						scount <= scount + 1;
						state<= 1;
					else
						state<= 0;
						done<= '1';
				end if;
				when others =>
				state<= 0;
			end case;
		end if;
	end process;
end architecture;