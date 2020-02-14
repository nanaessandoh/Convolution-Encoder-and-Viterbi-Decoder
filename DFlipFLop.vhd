
library ieee;
use ieee.std_logic_1164.all;

entity DFlipFlop is
   port( 
	clk: in std_logic;
	 D : IN std_logic;
         Q : OUT std_logic
);
end DFlipFlop;

architecture behav of DFlipFlop is
   begin
      process(clk) --We only care about Clk
         begin
            if (clk'event) and (clk='1') then -- Positive Edge
               Q <= D;
            end if;
      end process;
      
end behav;

