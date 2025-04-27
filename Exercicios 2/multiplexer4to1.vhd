LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux IS
    PORT (
        I: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Y: OUT STD_LOGIC
    );
END ENTITY mux;

ARCHITECTURE behavioral OF mux IS 
BEGIN 
    PROCESS(I, SEL)
    BEGIN 
        CASE SEL IS 
            WHEN "00" => Y <= I(0);
            WHEN "01" => Y <= I(1);
            WHEN "10" => Y <= I(2);
            WHEN "11"  => Y <= I(3);
	        WHEN OTHERS => Y <= '0';
        END CASE;
    END PROCESS;
END ARCHITECTURE;