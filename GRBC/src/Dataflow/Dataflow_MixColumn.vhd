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
	signal FB: natural:=0; -- Used to select forword or reverse mix columns 
begin
	-- Selects the bytes for multiplication
	inr0<= data(mcount, 0);
	inr1<= data(mcount, 1);
	inr2<= data(mcount, 2);
	inr3<= data(mcount, 3);
	
	FB<= 1 when ED = '1' else 0;  
	
	-- Calculates the answer for each column
	M0j<= C00(FB) (to_integer(unsigned(inr0))) xor C01(FB) (to_integer(unsigned(inr1))) xor C02(FB) (to_integer(unsigned(inr2))) xor C03(FB) (to_integer(unsigned(inr3))); 
	M1j<= C10(FB) (to_integer(unsigned(inr0))) xor C11(FB) (to_integer(unsigned(inr1))) xor C12(FB) (to_integer(unsigned(inr2))) xor C13(FB) (to_integer(unsigned(inr3)));
	M2j<= C20(FB) (to_integer(unsigned(inr0))) xor C21(FB) (to_integer(unsigned(inr1))) xor C22(FB) (to_integer(unsigned(inr2))) xor C23(FB) (to_integer(unsigned(inr3)));
	M3j<= C30(FB) (to_integer(unsigned(inr0))) xor C31(FB) (to_integer(unsigned(inr1))) xor C32(FB) (to_integer(unsigned(inr2))) xor C33(FB) (to_integer(unsigned(inr3)));
	
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