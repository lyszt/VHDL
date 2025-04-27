LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY counterto9 IS
    PORT(
        enable: IN STD_LOGIC;
        clock: IN STD_LOGIC;
        reset: IN STD_LOGIC;
        ov: OUT STD_LOGIC;
        count: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY counterto9;

ARCHITECTURE behavioral OF counterto9 IS 

signal current : std_logic_vector(3 DOWNTO 0);
signal change : std_logic;
BEGIN   
    PROCESS(CLOCK, ENABLE, RESET, CURRENT)
    BEGIN   
    
    IF enable = '1' THEN
        CASE RESET IS
            WHEN '1' => current <= "0000";
            WHEN OTHERS => NULL;
        END CASE;
        IF rising_edge(clock) THEN
            CASE CURRENT IS
                WHEN "0000" =>  current <= "0001";
                WHEN "0001" => current <= "0010";
                WHEN "0010" => current <= "0011";
                WHEN "0011" => current <= "0100";
                WHEN "0100" => current <= "0101";
                WHEN "0101" => current <= "0110";
                WHEN "0110" => current <= "0111";
                WHEN "0111" => current <= "1000";
                WHEN "1000" => current <= "1001";
                WHEN "1001" =>
                    current <= "0000";
                    change <= '1';
                WHEN OTHERS => NULL;
            END CASE;
        END IF;
    ELSE 
        current <= "0000";
    END IF;
    END PROCESS;
    count <= current;
    ov <= change;
END ARCHITECTURE;