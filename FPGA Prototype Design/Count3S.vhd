LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY Count3S IS
  PORT( CLOCK_50: IN std_logic;
	LED1: OUT std_logic;
	LED2: OUT std_logic;
	LED3: OUT std_logic;
        CNT150M: OUT std_logic
);
END Count3S;

ARCHITECTURE behav OF Count3S IS

SIGNAL CNT: std_logic_vector(27 downto 0) := "0000000000000000000000000000";

BEGIN

  -- Clock the counter
  PROCESS (CLOCK_50)
  BEGIN
    IF (CLOCK_50'event) and (CLOCK_50 = '1') THEN
	IF (CNT = "0000000000000000000000000000") THEN
	   LED1 <= '1';	
	   LED2 <= '0';	
	   LED3 <= '0';
	   CNT <= CNT + '1';
	ELSIF (CNT = "0010111110101111000010000000") THEN
	   LED1 <= '0';	
	   LED2 <= '1';	
	   LED3 <= '0';
	   CNT <= CNT + '1';
	ELSIF (CNT = "0101111101011110000100000000") THEN
	   LED1 <= '0';	
	   LED2 <= '0';	
	   LED3 <= '1';
	   CNT <= CNT + '1';
       	ELSIF (CNT = "1000111100001101000110000000") THEN   
	   LED1 <= '0';	
	   LED2 <= '0';	
	   LED3 <= '0';	
	   CNT150M <= '1';		
           CNT <= "0000000000000000000000000000";
       ELSE
          CNT150M <= '0';
          CNT <= CNT + '1';
	  END IF;
      END IF;
  END PROCESS;
  
END behav;

