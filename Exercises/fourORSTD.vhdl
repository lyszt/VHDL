library ieee;
use ieee.std_logic_1164.all;

ENTITY four_entryor IS
    port(
        a: IN STD_LOGIC; 
        b: IN STD_LOGIC;
        c: IN STD_LOGIC;
        d: IN STD_LOGIC;
        s: OUT STD_LOGIC
    );
END four_entryor;


ARCHITECTURE behaviour_or OF four_entryor IS 
BEGIN
    S <= a OR b OR c OR d;
END behaviour_or;

