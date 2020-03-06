LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;


ENTITY Turbo IS
PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;

	-- Interface I/O
	input : IN std_logic;
        output :OUT std_logic
         );
END Turbo;   

ARCHITECTURE behav OF Turbo IS 

SIGNAL CE1_Out:std_logic_vector(1 downto 0);
SIGNAL VD1_Out:bit;

COMPONENT TEncoder IS
PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;

	-- Interface I/O
         input : IN std_logic;
         output :OUT std_logic_vector (1 downto 0)
         );
END COMPONENT; 


COMPONENT ViterbiDecoder IS
PORT (
	-- Clock
	clk: in std_logic;

	-- Interface I/O
	input: in std_logic_vector (1 downto 0);
	output: out std_logic);

END COMPONENT;

BEGIN
	
	CE1:TEncoder PORT MAP( 	clk => clk,
				rstb => rstb,
				input => input,
				output => CE1_Out
			);
        
	CE2:ViterbiDecoder PORT MAP(	clk => clk,
					input => CE1_Out,	
					output => output
			);
    
END behav;
