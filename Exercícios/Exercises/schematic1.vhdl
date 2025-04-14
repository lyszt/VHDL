library ieee;
use ieee.std_logic_1164.all;

ENTITY schematic1 IS
    port(
        a: IN STD_LOGIC; 
        b: IN STD_LOGIC;
        c: IN STD_LOGIC;
        d, e, f: OUT STD_LOGIC
    );
END schematic1;


ARCHITECTURE behaviour_or OF schematic1 IS 
BEGIN
    d <= (not a) and b;
    e <= '1';
    f <= (not b) and (not c);
END behaviour_or;

