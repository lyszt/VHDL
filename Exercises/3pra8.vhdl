USE ieee;
USE ieee.std_logic_1164.all;

type bit_vector is array (natural range<>) of bit;

ENTITY decoder_3to8 IS 
    PORT (
        a: IN BIT_VECTOR(2 DOWNTO 0);
        y: OUT BIT_VECTOR(7 DOWNTO 0)
    );
END decoder_3to8;

ARCHITECTURE behaviour of decoder_3to8 IS 
BEGIN 
    y(0) <= not c and not b and not a; -- 000
    y(1) <= not c and not b and a; -- 001
    y(2) <= not c and b and not a; -- 010
    y(3) <= not c and b and a; -- 011
    y(4) <=  c and not b and not a; -- 100
    y(5) <= c and not b and a; -- 101
    y(6) <= c and b and not a; -- 110
    y(7) <= c and b and a; -- 111
END behaviour;