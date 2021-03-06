LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.all;


ENTITY test_Turbo IS

END test_Turbo;


ARCHITECTURE behav OF test_Turbo IS


COMPONENT Convolutional
PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;

	-- Input Interface I/O
	isop : IN std_logic;
	ivalid: IN std_logic;
	input : IN std_logic;

	-- Output Interface I/O
        output :OUT std_logic
         );

END COMPONENT;    

-- Define Signals

	signal CycleNumber : integer;

	signal clk_i 	: std_logic;
	signal rstb_i 	: std_logic;
	signal isop_i 	: std_logic;
	signal ivalid_i : std_logic;
	signal input_i 	: std_logic;
	signal output_i : std_logic;


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


	-- Generate Global Reset
	GenerateRSTB:
	PROCESS(CycleNumber)
	VARIABLE ResetTime : INTEGER := 2000;
	
	BEGIN
	IF (CycleNumber <= ResetTime) THEN
		rstb_i <= '1' AFTER 1 ns;
	ELSE
		rstb_i <= '0' AFTER 1 ns;
	END IF; 
	END PROCESS GenerateRSTB;


    
	-- Port Map Declaration
	test: Convolutional PORT MAP( 	clk => clk_i,
				       	rstb => rstb_i,
					isop => isop_i,
					ivalid => ivalid_i,
					input => input_i,
					output => output_i
				        );

	-- Perform Test
	Do_Test:
	PROCESS
	BEGIN

	
	WAIT FOR 10 ns;
	isop_i <= '1';
	ivalid_i <= '1';

	WAIT FOR 10 ns;
	input_i	<= '1';	
        WAIT FOR 10 ns;
	input_i	<= '1';
	WAIT FOR 10 ns;
	input_i	<= '1';
        WAIT FOR 10 ns;
	input_i	<= '0';
	WAIT FOR 10 ns;
	input_i	<= '1';
        WAIT FOR 10 ns;
	input_i	<= '0';
	WAIT FOR 10 ns;
	input_i	<= '1';
        WAIT FOR 10 ns;
	input_i	<= '0';
	WAIT FOR 10 ns;
	input_i	<= '1';
        WAIT FOR 10 ns;
	input_i	<= '1';
	WAIT FOR 10 ns;
	input_i	<= '0';
        WAIT FOR 10 ns;
	input_i	<= '0';
        WAIT FOR 10 ns;
	input_i	<= '1';
        WAIT FOR 10 ns;
	input_i	<= '1';
        WAIT FOR 10 ns;
	input_i	<= 'U';
	WAIT FOR 10 ns;
	input_i	<= 'U';
	WAIT FOR 10 ns;
	input_i	<= 'U';
	WAIT FOR 50 ns;
	


	END PROCESS Do_Test;


END behav;
