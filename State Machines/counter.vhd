LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- 1 to 5
ENTITY state_counter IS
    PORT(
        ORDER: IN STD_LOGIC;
        CLOCK: IN STD_LOGIC;
        RESET: IN STD_LOGIC;
        FINAL: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral of state_counter IS
TYPE state IS(A,B,C,D,E);
SIGNAL current: state;
BEGIN 
    PROCESS(RESET, CLOCK)
    BEGIN 
        IF(RESET = '1') THEN
            current <= A;
        ELSIF(RISING_EDGE(CLOCK)) THEN
            IF(ORDER = '1') THEN
                CASE CURRENT IS 
                    WHEN A => CURRENT <= B;
                    WHEN B => CURRENT <= C;
                    WHEN C => CURRENT <= D;
                    WHEN D => CURRENT <= E;
                    WHEN E => CURRENT <= A;
                END CASE;
            ELSIF (ORDER = '0') THEN
                CASE CURRENT IS 
                    WHEN A => CURRENT <= E;
                    WHEN B => CURRENT <= A;
                    WHEN C => CURRENT <= B;
                    WHEN D => CURRENT <= C;
                    WHEN E => CURRENT <= D;
                END CASE;
            END IF;
        END IF;
    END PROCESS;
    WITH CURRENT SELECT
        FINAL <= "000" WHEN A,
                    "001" WHEN B,
                    "010" WHEN C,
                    "011" WHEN D,
                    "100" WHEN E;
END ARCHITECTURE behavioral;