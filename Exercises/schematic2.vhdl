LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY schematic2 IS 
    PORT (
        a: IN STD_LOGIC;
        b: IN STD_LOGIC;
        c: IN STD_LOGIC;
        d, e: OUT STD_LOGIC
    );
END schematic2;

ARCHITECTURE behaviour OF schematic2 IS 
BEGIN 
    d <= ((not a) and c) or (not a and b) or (b and c);
    e <= (not a and not b and c) or (not a and b and not c) or (a and not b and not c) or (a and b and c);
END behaviour;