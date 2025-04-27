LIBRARY IEEE;
USE ieee.std_logic_1164.all;



ENTITY decoder2to4 IS 
    PORT (
        EN: IN STD_LOGIC;
        A: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Y_L: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral of decoder2to4 IS
BEGIN
    PROCESS(EN,A)
    BEGIN 
        Y_L <= "0000";
        IF EN = '1' THEN
            CASE A IS
                WHEN "00" => Y_L(0) <= '1';
                WHEN "01" => Y_L(1) <= '1';
                WHEN "10" => Y_L(2) <= '1';
                WHEN "11" => Y_L(3) <= '1';
                WHEN OTHERS => NULL;
            END CASE;
         ELSE 
            Y_L <= "0000";
        END IF;
    END PROCESS;    
END ARCHITECTURE;