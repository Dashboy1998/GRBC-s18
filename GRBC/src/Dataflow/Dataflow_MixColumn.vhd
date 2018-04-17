library ieee;
use ieee.std_logic_1164.all;
use work.DoubleQWord.all;
use work.byte.all;
use ieee.numeric_std.all;
use work.Sbox_Transformation.all;
use work.LUT_array.all;
use work.mult_x.all;

entity MixColumn is
	port(
	Data: in DQWord;
	Mixed: out DQword;
	ED: in std_logic;
	Start: in std_logic;
	done: out std_logic;
	clk: in std_logic
	);
end entity;

architecture dataflow of Mixcolumn is
signal state: natural:=0;
	signal mcount: natural:=0;
	signal inr0, inr1, inr2, inr3, M0j, M1j, M2j, M3j: byte;
begin
	-- Currently for encryption only
	-- Selects the bytes for multiplication
	inr0<= data(mcount, 0);
	inr1<= data(mcount, 1);
	inr2<= data(mcount, 2);
	inr3<= data(mcount, 3);
	
	-- Calculates the answer for each column
	M0j<= mult_3(to_integer(unsigned(inr0))) xor mult_4(to_integer(unsigned(inr1))) xor inr2 							   xor mult_7(to_integer(unsigned(inr3))); 
	M1j<= mult_7(to_integer(unsigned(inr0))) xor mult_3(to_integer(unsigned(inr1))) xor mult_4(to_integer(unsigned(inr2))) xor inr3 							 ;
	M2j<= inr0 								 xor mult_7(to_integer(unsigned(inr1))) xor mult_3(to_integer(unsigned(inr2))) xor mult_4(to_integer(unsigned(inr3)));
	M3j<= mult_4(to_integer(unsigned(inr0))) xor inr1 								xor mult_7(to_integer(unsigned(inr2))) xor mult_3(to_integer(unsigned(inr3)));
	
	process(clk)
	begin
		if(clk = '1') then
			case state is
				when 0 =>
					done<= '0';
					mcount<= 0;
					if(start= '1') then -- Wait state
						state<= 1;
					else
						state<= 0;
				end if;
				when 1 =>
					-- Sets the output values (Note this would be done using MUXes)
					Mixed(mcount, 0)<= M0j;
					Mixed(mcount, 1)<= M1j;
					Mixed(mcount, 2)<= M2j;
					Mixed(mcount, 3)<= M3j;
					if(mcount /= 3) then
						mcount <= mcount + 1;
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