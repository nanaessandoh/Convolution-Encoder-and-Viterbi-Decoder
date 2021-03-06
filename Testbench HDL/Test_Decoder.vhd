LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.all;


ENTITY test_Decoder IS

END test_Decoder;


ARCHITECTURE behav OF test_Decoder IS

COMPONENT ViterbiDecoder IS
PORT (
	-- Clock
	clk: in std_logic;

	-- Interface I/O
	input: in std_logic_vector (1 downto 0);

	-- The Output
	output: out std_logic);

END COMPONENT;  

	-- Define Signals
	signal CycleNumber : integer;

	signal clk_i 	: std_logic;
	signal input_i 	:  std_logic_vector (1 downto 0);
	signal output_i :  std_logic;


BEGIN

	-- Generate Clock
	GenerateCLK:
	PROCESS
	VARIABLE TimeHigh : time := 5 ns;
	VARIABLE TimeLow : time := 5 ns;
	VARIABLE CycleCount: integer := 0;
 
	BEGIN
	clk_i <= '1';
	WAIT FOR TimeHigh;
	clk_i <= '0';
	WAIT FOR TimeLow;

	--Handle Reset
	CycleCount := CycleCount + 1;
	CycleNumber <= CycleCount AFTER 1 ns;

	END PROCESS GenerateCLK;



	-- Port Map Declaration
	test: ViterbiDecoder PORT MAP( 	clk => clk_i,
					input => input_i,
					output => output_i
				        );
	-- Perform Test
	Do_Test:
	PROCESS
	BEGIN

	
	WAIT FOR 10 ns;


	input_i	<= "UU";
	WAIT FOR 40 ns;
	input_i	<= "10";
        WAIT FOR 10 ns;
	input_i	<= "01";
	WAIT FOR 10 ns;
	input_i	<= "00";
        WAIT FOR 10 ns;
	input_i	<= "10";
	WAIT FOR 10 ns;
	input_i	<= "00";
        WAIT FOR 10 ns;
	input_i	<= "UU";
	WAIT FOR 60 ns;
	input_i	<= "01";
        WAIT FOR 10 ns;
	input_i	<= "01";
	WAIT FOR 10 ns;
	input_i	<= "11";
        WAIT FOR 10 ns;
	input_i	<= "11";
	WAIT FOR 10 ns;
	input_i	<= "01";
	WAIT FOR 10 ns;
	input_i	<= "UU";
	WAIT FOR 50 ns;
	

	END PROCESS Do_Test;


END behav;