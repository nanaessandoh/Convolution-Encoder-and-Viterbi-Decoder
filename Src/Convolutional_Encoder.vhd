LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Encoder IS
PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;


	-- Input Interface I/O
	isop : IN std_logic;
	ivalid: IN std_logic;
	input : IN std_logic;

	-- Output Interface I/O
        output :OUT std_logic_vector (1 downto 0)
         );

END Encoder;       

ARCHITECTURE behav OF Encoder IS 


-- Define State of the State Machine
TYPE state_type IS (ONRESET, IDLE,ENCODE,NODATA);
   
COMPONENT DFlipFlop IS
   PORT( 
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;

	-- Interface I/O
	 D : IN std_logic;
         Q : OUT std_logic
);
END COMPONENT;

-- Define Signals
SIGNAL current_state, next_state : state_type;
SIGNAL DF1_out: std_logic;
SIGNAL DF2_out: std_logic;
   

BEGIN
    
    DF1:DFlipFlop PORT MAP	(	clk => clk,
					rstb => rstb, 
					D => input,
					Q => DF1_out); 
    DF2:DFlipFlop PORT MAP	(	clk => clk,
					rstb => rstb, 
					D => DF1_out, 
					Q => DF2_out);


	sequential:
	PROCESS(clk,rstb,current_state,isop,ivalid)
	BEGIN

	CASE current_state IS
	

	WHEN ONRESET =>
	next_state <= IDLE;

	WHEN IDLE =>
	IF( isop = '1' and ivalid = '1') THEN
	next_state <= ENCODE;
	ELSIF (isop = '1' and ivalid /= '1') THEN
	next_state <= NODATA;
	ELSE
	next_state <= IDLE;
	END IF;


	WHEN ENCODE =>
	IF (ivalid /= '1') THEN
	next_state <= NODATA;
	ELSIF (ivalid /= '1' and input = 'U') THEN
	next_state <= IDLE;
	ELSE
	next_state <= ENCODE;
	END IF;

	WHEN NODATA =>
	IF( ivalid = '1') THEN
	next_state <= ENCODE;
	ELSE
	next_state <= NODATA;
	END IF;

	WHEN OTHERS =>
	next_state <= ONRESET;

	END CASE;
	END PROCESS sequential;



	clock_state_machine:
	PROCESS(clk,rstb)
	BEGIN
	IF (rstb /= '1') THEN
	current_state <= ONRESET;
	ELSIF (clk'EVENT and clk = '1') THEN
	current_state <= next_state;
	END IF;
	END PROCESS clock_state_machine;


	combinational:
	PROCESS(clk, rstb)
	BEGIN

	IF ( clk'EVENT and clk = '1') THEN


	IF (current_state = ENCODE) THEN
	output(1) <= input xor DF1_out xor DF2_out;
	output(0) <= input xor DF2_out;	
	END IF;

	END IF;

	END PROCESS combinational;

END behav;


         








    