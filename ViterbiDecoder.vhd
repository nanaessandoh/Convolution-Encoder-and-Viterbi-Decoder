LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ViterbiDecoder IS
PORT (
	-- Clock
	clk: in std_logic;

	-- Interface I/O
	input: in std_logic_vector (1 downto 0);

	-- The Output will be delayed for 3 Clock Cycles because the depth of the traceback is 3
	output: out bit);

END ViterbiDecoder;

ARCHITECTURE behav OF ViterbiDecoder IS
type word_2 is array (1 downto 0) of std_logic_vector (1 downto 0);
type word_4_NextState is array (3 downto 0) of std_logic_vector (1 downto 0);
type word_3 is array (2 downto 0) of std_logic_vector (1 downto 0); 
type word_3_bit is array (2 downto 0) of bit; 
type word_4 is array (3 downto 0) of integer;
type word_4_bit is array (3 downto 0) of bit;
type memory_4 is array (3 downto 0) of word_2;
type memory_4_bit is array (3 downto 0) of word_4_bit;
type memory_4_NextState is array (3 downto 0) of word_4_NextState;
type memory_8 is array (7 downto 0) of integer;
type memory_traceback_row is array (7 downto 0) of word_3;
type memory_traceback_table is array (3 downto 0) of memory_traceback_row;

--Traceback Depth is 3 
-- All 32 paths have been hardcoded
-- Below are 4 tables each containing 8 possible paths depending on the initial state
constant traceback_table: memory_traceback_table:=((("00","00","00"),("11","10","11"),("00","11","10"),("11","01","01"),("00","00","11"),("11","10","00"),("00","11","01"),("11","01","10")),
                                                  (("11","00","00"),("00","10","11"),("11","11","10"),("00","01","01"),("11","00","11"),("00","10","00"),("11","11","01"),("00","01","10")),
                                                  (("10","11","00"),("01","01","11"),("10","00","10"),("01","10","01"),("10","11","11"),("01","01","00"),("10","00","01"),("01","10","10")),
                                                  (("01","11","00"),("10","01","11"),("01","00","10"),("10","10","01"),("01","11","11"),("10","01","00"),("01","00","01"),("10","10","10")));

--The next table maps the state transitions to the inputs that caused them(Current State Vs. output)
-- -1 means invalid operation
--constant outputTable:memory_4_bit:=((0,-1,-1,1),(1,-1,-1,0),(-1,1,0,-1),(-1,0,1,-1));
constant outputTable:memory_4_bit:=(('0','0','0','1'),('1','0','0','0'),('0','1','0','0'),('0','0','1','0'));

--The next table gets the next state providing the current state and the state transition
constant nextStateTable:memory_4_NextState:=(("00","00","00","10"),("10","00","00","00"),("00","11","01","00"),("00","01","11","00"));


constant TraceBackDepth: positive:=3;


FUNCTION hammingDistance(a:std_logic_vector (1 downto 0)) RETURN integer IS
BEGIN
  
  CASE a IS
                  WHEN "00" =>
                      RETURN 0;
                  WHEN "01" =>
                      RETURN 1;
                  WHEN "10" =>
                      RETURN 1;
                  WHEN "11" =>
                      RETURN 2;
                  WHEN OTHERS => 
                     RETURN -1; --INVALID OPERATION
 END CASE; 
END hammingDistance; 

FUNCTION conv_int(a:std_logic_vector (1 downto 0)) RETURN integer IS
BEGIN
  
  CASE a IS
                  WHEN "00" =>
                      RETURN 0;
                  WHEN "01" =>
                      RETURN 1;
                  WHEN "10" =>
                      RETURN 2;
                  WHEN "11" =>
                      RETURN 3;
                  WHEN OTHERS => 
                     RETURN -1; --invalid operation
 END CASE; 
END conv_int; 


BEGIN  

  PROCESS(clk) 
   variable InitialState:std_logic_vector (1 downto 0):="00";
   variable TracebackResult:memory_8:=(0,0,0,0,0,0,0,0);
   variable InputLevel:integer:=0;
   variable i:integer:=0;
   variable chosenPathIndex:integer;
   variable lowestPathMetricError:integer:=6; --Initialized to the maximum possible error
   variable currentState:std_logic_vector (1 downto 0);
   variable outputVector:word_3_bit;
   
   variable temp_output:std_logic_vector (1 downto 0);
   BEGIN
            IF (clk'event) and (clk='1') and (input/= "UU")  THEN -- Positive Edge
               i:=0;
               
               -- Branch Metric Calculations
               WHILE i <8 LOOP
                         TracebackResult(i):=TracebackResult(i)+ hammingDistance(traceback_table(3-conv_int(InitialState))(7-i)(2-InputLevel) xor input );
                          i:=i+1;
               END LOOP;    
                         
               
               --Output the decoded data, from the previous path metric calculations
               --Output will be delayed for 3 clock cycles
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



        