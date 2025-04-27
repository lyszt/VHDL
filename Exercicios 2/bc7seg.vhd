LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY bc7seg IS 
    PORT(
        EN: IN STD_LOGIC;
        D: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        S: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
END ENTITY bc7seg;


ARCHITECTURE behavioral OF bc7seg IS 
BEGIN 
    PROCESS(EN,D)
    BEGIN 
        IF EN = '0' THEN
            S <= "0000000";
        ELSE 
            CASE D IS 
                WHEN "0000" => S <= "1111110";
                WHEN "0001" => S <=  "0110000";
                WHEN "0010" => S <=  "1101101";
                WHEN "0011" => S <=  "1111001";
                WHEN "0100" => S <=  "0110011";
                WHEN "0101" => S <=  "1011011";
                WHEN "0110" => S <=  "1011111";
                WHEN "0111" => S <=  "1110000";
                WHEN "1000" => S <=  "1111111";
                WHEN "1001" => S <=  "1111011";
                WHEN OTHERS => NULL;
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE;