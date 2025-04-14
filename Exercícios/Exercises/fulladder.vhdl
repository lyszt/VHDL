library ieee;
use ieee.std_logic_1164.all;


entity half_adder is 
    port (
      a, b : in std_logic;
      s, cout : out std_logic
    );
end half_adder;

architecture behavioral of half_adder is 
begin 
  s <= a xor b;
  cout <= a and b;
end behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is 
    port (
      a,b, cin: in std_logic;
      s, cout: out std_logic
    );
end full_adder;

architecture behavioral of full_adder is 
  signal e,f: std_logic;
  begin
  e <=  a xor b;
  s <= e xor cin;
  f <= a and b;
  cout <= (a and b) or (cin and e);
end behavioral;