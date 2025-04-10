-- O código não funcionou de jeito nenhum, nem fazendo de outros modos,
-- incluindo pedindo pra chatgpt, entre outros. Talvez meu digital
-- esteja com problema
library ieee;
use ieee.std_logic_1164.all;

type bit_vector is array (natural range<>) of bit;

ENTITY decoder_3to8 IS 
    PORT (
        a : IN BIT_VECTOR(2 DOWNTO 0);  
        y : OUT BIT_VECTOR(7 DOWNTO 0)  
    );
END decoder_3to8;

ARCHITECTURE behaviour OF decoder_3to8 IS 
BEGIN 
    y(0) <= not a(2) and not a(1) and not a(0);  -- 000
    y(1) <= not a(2) and not a(1) and a(0);     -- 001
    y(2) <= not a(2) and a(1) and not a(0);     -- 010
    y(3) <= not a(2) and a(1) and a(0);        -- 011
    y(4) <= a(2) and not a(1) and not a(0);     -- 100
    y(5) <= a(2) and not a(1) and a(0);        -- 101
    y(6) <= a(2) and a(1) and not a(0);        -- 110
    y(7) <= a(2) and a(1) and a(0);            -- 111
END behaviour;
