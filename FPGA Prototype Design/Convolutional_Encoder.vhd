LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY TEncoder IS
PORT(
	-- CLock and Reset
	CLOCK_50 : IN std_logic;
	RSTB : IN std_logic;

	-- Interface I/O
         input : IN std_logic;
         output :OUT std_logic_vector (1 downto 0)
         );
END TEncoder;       

ARCHITECTURE behav OF TEncoder IS 
   
COMPONENT DFlipFlop IS
   PORT( 
	-- Clock and Reset
	CLOCK_50 : IN std_logic;
	RSTB : IN std_logic;

	-- Interface I/O
	 D : IN std_logic;
         Q : OUT std_logic
);
END COMPONENT;


   signal DF1_out: std_logic;
   signal DF2_out: std_logic;
   

BEGIN
    
    DF1:DFlipFlop PORT MAP	(	CLOCK_50 => CLOCK_50,
					RSTB => RSTB, 
					D => input,
					Q => DF1_out); 
    DF2:DFlipFlop PORT MAP	(	CLOCK_50 => CLOCK_50,
					RSTB => RSTB, 
					D => DF1_out, 
					Q => DF2_out);
            
output(1)<= input xor DF1_out xor DF2_out;
output(0)<= input xor DF2_out;

END behav;


         
    