LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.all;

ENTITY DFlipFlop IS
   PORT( 
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;

	-- Interface I/O
	 D : IN std_logic;
     Q : OUT std_logic
);
END DFlipFlop;

ARCHITECTURE behav OF DFlipFlop IS
	
	BEGIN
		PROCESS(clk,rstb) 
         
		BEGIN
		IF ( rstb /= '1') THEN
		Q <= 'U';
		ELSIF (clk'EVENT) and (clk='1') THEN -- Positive Edge
		Q <= D;
            	END IF;
	END PROCESS;
      
END behav;

