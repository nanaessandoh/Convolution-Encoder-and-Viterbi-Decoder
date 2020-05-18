-- Portions of this Code were adapted from the Viterbi Decoder design by:( See Below)
--	Mustafa Ozcelikors thewebblog.net | github.com/mozcelikors | <mozcelikors@gmail.com>
--	Hassan Qayyum
--	Umair Saleem

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ViterbiDecoder IS
PORT (
	-- Clock
	clk: IN std_logic;

	-- Input Interface
	input: IN std_logic_vector (1 DOWNTO 0);

	-- Output Interface 
	output: OUT std_logic);

END ViterbiDecoder;

ARCHITECTURE behav OF ViterbiDecoder IS
TYPE word_2 IS ARRAY (1 DOWNTO 0) of std_logic_vector (1 DOWNTO 0);
TYPE word_4_NextState IS ARRAY (3 DOWNTO 0) of std_logic_vector (1 DOWNTO 0);
TYPE word_3 IS ARRAY (2 DOWNTO 0) of std_logic_vector (1 DOWNTO 0); 
TYPE word_3_bit IS ARRAY (2 DOWNTO 0) of std_logic; 
TYPE word_4 IS ARRAY (3 DOWNTO 0) of integer;
TYPE word_4_bit IS ARRAY (3 DOWNTO 0) of std_logic;
TYPE memory_4 IS ARRAY (3 DOWNTO 0) of word_2;
TYPE memory_4_bit IS ARRAY (3 DOWNTO 0) of word_4_bit;
TYPE memory_4_NextState IS ARRAY (3 DOWNTO 0) of word_4_NextState;
TYPE memory_8 IS ARRAY (7 DOWNTO 0) of integer;
TYPE memory_traceback_row IS ARRAY (7 DOWNTO 0) of word_3;
TYPE memory_traceback_table IS ARRAY (3 DOWNTO 0) of memory_traceback_row;

-- Traceback Depth is 3 
-- All 32 paths have been hardcoded
-- The 4 traceback tables each containing 8 possible paths depending on the initial state

CONSTANT traceback_table: memory_traceback_table := ((("00","00","00"),("11","10","11"),("00","11","10"),("11","01","01"),("00","00","11"),("11","10","00"),("00","11","01"),("11","01","10")),
                                                    (("11","00","00"),("00","10","11"),("11","11","10"),("00","01","01"),("11","00","11"),("00","10","00"),("11","11","01"),("00","01","10")),
                                                    (("10","11","00"),("01","01","11"),("10","00","10"),("01","10","01"),("10","11","11"),("01","01","00"),("10","00","01"),("01","10","10")),
                                                    (("01","11","00"),("10","01","11"),("01","00","10"),("10","10","01"),("01","11","11"),("10","01","00"),("01","00","01"),("10","10","10")));

-- Next table maps the state transitions to the inputs (Current State Vs. output)
CONSTANT outputTable:memory_4_bit := (('0','0','0','1'),('1','0','0','0'),('0','1','0','0'),('0','0','1','0'));

-- Next table gets the next state providing the current state and the state transition
CONSTANT nextStateTable:memory_4_NextState:=(("00","00","00","10"),("10","00","00","00"),("00","11","01","00"),("00","01","11","00"));


CONSTANT TraceBackDepth: positive := 3;


FUNCTION hammingDistance(load :std_logic_vector (1 DOWNTO 0)) RETURN integer IS
BEGIN
  
  CASE load IS
                  WHEN "00" =>
                  RETURN 0;
                  WHEN "01" =>
                  RETURN 1;
                  WHEN "10" =>
                  RETURN 1;
                  WHEN "11" =>
                  RETURN 2;
                  WHEN OTHERS => 
                  RETURN -1; --Invalid
 END CASE; 
END hammingDistance; 

FUNCTION conv_int( load :std_logic_vector (1 DOWNTO 0)) RETURN integer IS
BEGIN
  
  CASE load IS
                  WHEN "00" =>
                  RETURN 0;
                  WHEN "01" =>
                  RETURN 1;
                  WHEN "10" =>
                  RETURN 2;
                  WHEN "11" =>
                  RETURN 3;
                  WHEN OTHERS => 
                  RETURN -1; --Invalid
 END CASE; 
END conv_int; 


BEGIN  

  PROCESS(clk) 
   variable InitialState:std_logic_vector (1 DOWNTO 0):="00";
   variable TracebackResult:memory_8:=(0,0,0,0,0,0,0,0);
   variable InputLevel:integer:=0;
   variable i:integer:=0;
   variable chosenPathIndex:integer;
   variable lowestPathMetricError:integer:=6; --Initialized to the maximum possible error
   variable currentState:std_logic_vector (1 DOWNTO 0);
   variable outputVector:word_3_bit;
   
   variable temp_output:std_logic_vector (1 DOWNTO 0);
   BEGIN
            IF (clk'event) and (clk='1') and (input/= "UU")  THEN -- Positive Edge
               i := 0;
               
               -- Branch Metric Calculations
               WHILE i <8 LOOP
               TracebackResult(i):=TracebackResult(i)+ hammingDistance(traceback_table(3-conv_int(InitialState))(7-i)(2-InputLevel) xor input );
               i := i+1;
               END LOOP;    
                         
               
               -- Output the decoded data, from the previous path metric calculations
               -- Output will be delayed for 3 clock cycles
               output <= outputVector(InputLevel);
               
               InputLevel:=InputLevel+1;
               IF (InputLevel = TraceBackDepth) THEN                   
                   --Select the correct path which have the lowest path metric error
                    i:=0;
                    WHILE i<8 LOOP
                        IF(lowestPathMetricError > TracebackResult(i)) THEN
                          lowestPathMetricError := TracebackResult(i);
                          chosenPathIndex := i;
                        END IF;
                          i := i+1;
                    END LOOP;  
                   
                   --Convert the selected path to corresponding output
                   currentState := InitialState;
                    i := 0;
                    WHILE i < TraceBackDepth LOOP
                     temp_output := traceback_table(3-conv_int(InitialState))(7-chosenPathIndex)(2-i);
                     outputVector(i) := outputTable(3-conv_int(currentState))(3-conv_int(temp_output));
                     currentState := nextStateTable(3-conv_int(currentState))(3-conv_int(temp_output));
                     i := i+1;
                    END LOOP;  
                   
                   --Set the initial state of the next stage
                   InitialState := currentState;
                   
                   --Reset variables
                   InputLevel := 0;
                   TracebackResult := (0,0,0,0,0,0,0,0);
                   lowestPathMetricError := 6;
                   
               END IF;
               
            END IF;
   END PROCESS;   
   
   END behav;



        