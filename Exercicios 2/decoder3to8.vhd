
-- 1 - Projete e descreva em VHDL um decodificador 3 para 8. Utilize a seguinte entidade para
-- descrever sua solução em VHDL:


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY decoder_to8 IS 
    PORT (
        A: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Y: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE behavioral OF decoder_to8 IS 
BEGIN 
    PROCESS(A)
    BEGIN 
        Y <= "00000000";
        CASE A IS 
            WHEN "000" => Y(0) <= '1';
            WHEN "001" => Y(1) <= '1'; 
            WHEN "010" => Y(2) <= '1';
            WHEN "011" => Y(3) <= '1';
            WHEN "100" => Y(4) <= '1';
            WHEN "101" => Y(5) <= '1';
            WHEN "110" => Y(6) <= '1';
            WHEN "111" => Y(7) <= '1';
            WHEN OTHERS => NULL;
        END CASE;
    END PROCESS;
END ARCHITECTURE;