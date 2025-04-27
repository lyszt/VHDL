library ieee;
use ieee.std_logic_1164.all;

ENTITY four_arrayor IS 
    PORT (
        a: IN STD_LOGIC_VECTOR(3 downto 0);
        s: OUT STD_LOGIC
    );
END four_arrayor;

ARCHITECTURE behaviour_or OF four_arrayor IS 
BEGIN
    s <= a(0) OR a(1) OR a(2) OR a(3);
END behaviour_or;
