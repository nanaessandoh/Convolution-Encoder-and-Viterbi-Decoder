LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;


ENTITY Convolutional IS
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

END Convolutional;   

ARCHITECTURE behav OF Convolutional IS 

SIGNAL CE1_Out:std_logic_vector(1 DOWNTO 0);

COMPONENT Encoder
PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;

	-- Interface I/O
	isop : IN std_logic;
	ivalid: IN std_logic;
	input : IN std_logic;
        output :OUT std_logic_vector (1 DOWNTO 0)

         );
END COMPONENT; 


COMPONENT ViterbiDecoder 
PORT (
	-- Clock
	clk: in std_logic;

	-- Interface I/O
	input: IN std_logic_vector (1 DOWNTO 0);
	output: OUT std_logic);

END COMPONENT;

BEGIN
	
	CE1: Encoder PORT MAP( 	clk => clk,
				rstb => rstb,
				isop => isop,
				ivalid => ivalid,
				input => input,
				output => CE1_Out
			);
        
	CE2: ViterbiDecoder PORT MAP(	clk => clk,
					input => CE1_Out,	
					output => output
			);
    
END behav;
