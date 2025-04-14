library ieee;
use ieee.std_logic_1164.all;


entity half_adder is 
    port (
      a, b, cin : in std_logic;
      s, cout : out std_logic;  
    );