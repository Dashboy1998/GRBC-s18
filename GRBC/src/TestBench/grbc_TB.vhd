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
			IO : inout Qword; -- Should be inout
			PK : in STD_LOGIC;
			LU : inout STD_LOGIC;
			ED : in STD_LOGIC;
			RD : in STD_LOGIC;
			Start : in STD_LOGIC;
			Clk : in STD_LOGIC;
			Done : inout STD_LOGIC);
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal PK : STD_LOGIC;
	signal LU : STD_LOGIC;
	signal ED : STD_LOGIC;
	signal RD : STD_LOGIC;
	signal Start : STD_LOGIC;
	signal Clk : STD_LOGIC;
	signal IO : Qword;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Done : STD_LOGIC;
	
	-- Add your code here ...
	signal EndSim: boolean:=false; -- Ends simulation 
	
	constant test_Key: std_logic_vector(127 downto 0):= tests(0).key; -- Key used in encryption
	--constant test_PlainText: std_logic_vector(127 downto 0):= tests(0).plain; -- Plain Text used in encryption
	constant test_PlainText: std_logic_vector(127 downto 0):= tests(0).expected; -- Cipher used in decryption
begin
	-- Unit Under Test port map
	UUT : grbc
	port map (
		IO => IO,
		PK => PK,
		LU => LU,
		ED => ED,
		RD => RD,
		Start => Start,
		Clk => Clk,
		Done => Done
		);
	
	-- Add your stimulus here ...
	
	process -- Generates clock
	begin			
		clk<= '0';
		wait for 25ns;
		clk<= '1';
		wait for 25ns;
		if(EndSim) then wait; end if; -- Stops the clk
	end process;
	
	process -- Process for Writting Data
	begin
		start<='1'; 
		ED<= '1'; -- Sets for Encryption
		RD<= '1'; -- Sets to read data
		PK<= '1'; -- Loads Key
		LU<= '0'; -- Loads lower half 
		
		IO<= to_Qword(test_key(63 downto 0));
		wait until clk = '1';
		wait until clk = '0';
		
		IO<= to_Qword(test_key(127 downto 64));
		LU<= '1'; -- Loads upper half
		wait until clk = '1';
		wait until clk = '0';
		PK<= '0'; -- Loads Text
		LU<= '0'; -- Loads lower half
		
		IO<= to_Qword(test_PlainText(63 downto 0));
		wait until clk = '1';
		wait until clk = '0';
		
		IO<= to_Qword(test_PlainText(127 downto 64));
		LU<= '1'; -- Loads upper half
		--RD<= '0'; 
		wait until clk = '1';
		wait until clk = '0';
		RD<= '0';
		wait until clk = '1';
		wait until clk = '0';
		wait until clk = '1';
		wait until clk = '0';
		wait until clk = '1';
		wait until clk = '0';
		wait until clk = '1';
		wait until clk = '0';
		wait until clk = '1';
		wait until clk = '0';
		EndSim<= true;
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_grbc of grbc_tb is
	for TB_ARCHITECTURE
		for UUT : grbc
			use entity work.grbc(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_grbc;

