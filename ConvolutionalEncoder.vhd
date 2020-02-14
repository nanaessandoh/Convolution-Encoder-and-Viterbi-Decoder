library ieee;
use ieee.std_logic_1164.all;

entity CEncoder is
    port(input : in std_logic;
         clk : in std_logic;
         output :out std_logic_vector (1 downto 0)
         );
end CEncoder;       

architecture behav of CEncoder is 
   
component DFlipFlop is
   port( 
	clk: in std_logic;
	 D : IN std_logic;
         Q : OUT std_logic
);
end component;

   signal DF1_out: std_logic;
   signal DF2_out: std_logic;
   

begin
    
    DF1:DFlipFlop
        port map (	clk => clk, 
			D => input,
			Q => DF1_out); 
    DF2:DFlipFlop
        port map (	clk => clk, 
			D => DF1_out, 
			Q => DF2_out);
            
output(1)<= input xor DF1_out xor DF2_out;
output(0)<= input xor DF2_out;

end behav;


         
    