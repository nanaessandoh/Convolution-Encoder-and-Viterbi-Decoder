LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.all;

ENTITY DFlipFlop IS
   PORT( 
	-- Clock and Reset
	CLOCK_50 : IN std_logic;
	RSTB : IN std_logic;

	-- Interface I/O
	 D : IN std_logic;
         Q : OUT std_logic
);
END DFlipFlop;

ARCHITECTURE behav OF DFlipFlop IS
	
	BEGIN
		PROCESS(CLOCK_50,rstb) 
         
		BEGIN
		IF ( RSTB = '0') THEN
		Q <= '0';
		ELSIF (CLOCK_50'event and CLOCK_50='1') THEN -- Positive Edge
		Q <= D;
            	END IF;
	END PROCESS;
      
END behav;

