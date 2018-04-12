library ieee;
use ieee.std_logic_1164.all;
library GRBC;
use GRBC.DoubleQWord.all;
use GRBC.KeyExpansionFunc.all;
use work.stream.all;
use aesTest_GRBC_s18.all;

-- Add your library and packages declaration here ...

entity grbc_tb is
end grbc_tb;

architecture TB_ARCHITECTURE of grbc_tb is
	-- Component declaration of the tested unit
	component grbc
		port(
			IO : inout Qword;
			ED : in STD_LOGIC;
			Start : in STD_LOGIC;
			Clk : in STD_LOGIC;
			Done : inout STD_LOGIC);
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal ED : STD_LOGIC;
	signal Start : STD_LOGIC;
	signal Clk : STD_LOGIC;
	signal IO : Qword;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Done_Gold : STD_LOGIC;
	signal Done_Dataflow : std_logic;
	--signal 
	
	-- Add your code here ...
	signal EndSim: boolean:=false; -- Ends simulation
	signal A: Qword; -- Signal for IO
	signal Correct: boolean;

begin
	-- Unit Under Test port map
	UUT_Gold : grbc
	port map (
		IO => IO,
		ED => ED,
		Start => Start,
		Clk => Clk,
		Done => Done_Gold
		);
--	UUT_Dataflow : grbc
--	port map (
--		IO => IO,
--		DK => DK,
--		LU => LU,
--		ED => ED,
--		RD => RD,
--		Start => Start,
--		Clk => Clk,
--		Done => Done_Dataflow
--		);
		
	
	-- Add your stimulus here ...
	IO<= A when (done_Gold = '0') else (others => (others => "ZZZZZZZZ"));
	process -- Generates clock
	begin			
		clk<= '0';
		wait for 25ns;
		clk<= '1';
		wait for 25ns;
		if(EndSim) then wait; end if; -- Stops the clk
	end process;
	
	process -- Process for Writting Data
		variable test_key, test_PlainText, test_cipher, test_IO: std_logic_vector(127 downto 0);
	begin
		Crypt:	for i in 0 to 1 loop -- encryption/decryption loop
			Data:	for j in 0 to 284 loop -- selects to test data
				test_key:=tests(j).key;
				test_PlainText:=tests(j).plain;
				test_cipher:=tests(j).expected;
				if(i = 0) then test_IO:= test_PlainText; else test_IO:= test_cipher; end if;
		start<='1'; -- Starts 
		if(i=0) then ED<= '0'; else ED<= '1'; end if; 
		
		A<= to_Qword(test_IO(127 downto 64)); -- loads upper half of data
		wait until clk'event and clk='1';
		
		start<='0'; -- Prevents the cycle from repeating
		
		A<= to_Qword(test_IO(63 downto 0)); -- loads lower half of data
		wait until clk'event and clk='1';
		
		A<= to_Qword(test_key(127 downto 64)); -- loads upper half of key
		wait until clk'event and clk='1';
		
		A<= to_Qword(test_key(63 downto 0)); -- loads lower half of key
		wait until clk'event and clk='1';
		
		wait until done_Gold'event and done_Gold = '1';
		--- Tests the output value
		wait until clk'event and clk = '1';
		if(i=0) then 
			Correct<= (IO = to_Qword(test_cipher(127 downto 64))); 
		else 
			Correct<= (IO = to_Qword(test_PlainText(127 downto 64)));
		end if;
		wait until clk'event and clk = '1';
		if(i=0) then 
			Correct<= (IO = to_Qword(test_cipher(63 downto 0))); 
		else 
			Correct<= (IO = to_Qword(test_PlainText(63 downto 0)));
		end if;
		wait until done_Gold'event and done_Gold = '0';
		end loop Data;
		end loop Crypt;
		EndSim<= true;
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_grbc of grbc_tb is
	for TB_ARCHITECTURE
		for UUT_Gold : grbc
			use entity work.grbc(behavioral);
		end for;
--		for UUT_Dataflow : grbc
--			use entity work.grbc(dataflow);
--		end for;
	end for;
end TESTBENCH_FOR_grbc;

