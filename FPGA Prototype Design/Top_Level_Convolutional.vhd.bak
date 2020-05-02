LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;


ENTITY Turbo IS
PORT(
	-- Clock and Reset
	CLOCK_50 : IN std_logic;

	-- Input Interface I/O
	KEY : IN std_logic_vector(3 downto 0); -- Push Buttons
 	SW : IN std_logic_vector(9 downto 0); -- Switches

	-- Output Interface I/O
	HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : OUT std_logic_vector(6 downto 0); -- HEX Displays
	LEDR : OUT std_logic_vector (9 downto 0) -- LED Lights

         );
END Turbo;   

ARCHITECTURE behav OF Turbo IS 

SIGNAL CE1_Out : std_logic_vector(1 downto 0);
SIGNAL CE1_Val : std_logic_vector(1 downto 0);
SIGNAL VD_Out  : std_logic;
SIGNAL Second  : std_logic;
SIGNAL Input   : std_logic_vector(3 downto 0);
SIGNAL Output  : std_logic_vector(3 downto 0);
SIGNAL E_Out1  : std_logic_vector(3 downto 0);
SIGNAL E_Out2  : std_logic_vector(3 downto 0);
SIGNAL L1,L2,L3 : std_logic;

FUNCTION Conv_To_Hex (input :std_logic) RETURN std_logic_vector IS
BEGIN 
  CASE input IS
                  WHEN '0' => RETURN "0000"; -- 0
                  WHEN '1' => RETURN "0001"; -- 1
                  WHEN OTHERS => RETURN "1101"; -- Invalid Operation (Blank)
 END CASE; 
END Conv_To_Hex;


FUNCTION Conv_Output (input,switch :std_logic ) RETURN std_logic IS
BEGIN 
  CASE input IS
                  WHEN '0' => IF (switch = '1') THEN RETURN '1'; ELSE RETURN '0'; END IF;
                  WHEN '1' => IF (switch = '1') THEN RETURN '0'; ELSE RETURN '1'; END IF;
                  WHEN OTHERS => RETURN '0'; -- Invalid Operation
 END CASE; 
END Conv_Output;



COMPONENT TEncoder IS
PORT(
	-- Clock and Reset
	CLOCK_50 : IN std_logic;
	RSTB : IN std_logic;

	-- Interface I/O
         input : IN std_logic;
         output :OUT std_logic_vector (1 downto 0)
         );
END COMPONENT; 

COMPONENT Count3S IS
  PORT( CLOCK_50: IN std_logic;
	LED1: OUT std_logic;
	LED2: OUT std_logic;
	LED3: OUT std_logic;
        CNT150M: OUT std_logic
);
END COMPONENT;

COMPONENT ViterbiDecoder IS
PORT (
	-- Clock
	CLOCK_50: in std_logic;

	-- Interface I/O
	input: in std_logic_vector (1 downto 0);
	output: out std_logic);
END COMPONENT;

COMPONENT Seven_Segment IS
PORT(
	SW : IN std_logic_vector(3 downto 0);
	HEX0 : OUT std_logic_vector(6 downto 0)
);
END COMPONENT;


BEGIN
        
	

	CE1_Val(0) <= Conv_Output(CE1_Out(0),SW(5));
	CE1_Val(1) <= Conv_Output(CE1_Out(1),SW(6));
	Input <= Conv_To_Hex(SW(9));
	E_Out1 <= Conv_To_Hex(CE1_Val(0)); --
	E_Out2 <= Conv_To_Hex(CE1_Val(1)); --
	Output <= Conv_To_Hex(VD_Out);

	-- Port Maps
	SecH_0 : Seven_Segment port map (Output, HEX0);
	SecH_1 : Seven_Segment port map ("1101", HEX1);
	SecH_2 : Seven_Segment port map (E_Out1, HEX2);
	SecH_3 : Seven_Segment port map (E_Out2, HEX3);
	SecH_4 : Seven_Segment port map ("1101", HEX4);
	SecH_5 : Seven_Segment port map (Input, HEX5);
	Seconds: Count3S port map(CLOCK_50,L1,L2,L3,Second);
   CE1:TEncoder port map(Second,KEY(3),SW(9),CE1_Out);
   CE2:ViterbiDecoder port map(Second,CE1_Out,VD_Out);


	LEDR(9) <= SW(9);
	LEDR(2) <= L1;
	LEDR(1) <= L2;
	LEDR(0) <= L3;

END behav;
