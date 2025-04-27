    LIBRARY ieee;
    USE ieee.std_logic_1164.all;


    ENTITY decoder1to8 IS 
        PORT(
            A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            SEL : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            S0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            S1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            S2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            S3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            S4 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            S5 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            S6 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            S7 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END ENTITY decoder1to8; 


    ARCHITECTURE behavioral of decoder1to8 IS 
    BEGIN 
        PROCESS(A, SEL)
            BEGIN
            S0 <= "0000000000000000";
            S1 <= "0000000000000000";
            S2 <= "0000000000000000";
            S3 <= "0000000000000000";
            S4 <= "0000000000000000";
            S5 <= "0000000000000000";
            S6 <= "0000000000000000";
            S7 <= "0000000000000000";
            CASE SEL IS 
                WHEN "000" => S0 <= A;
                WHEN "001" => S1 <= A;
                WHEN "010" => S2 <= A;
                WHEN "011" => S3 <= A;
                WHEN "100" => S4 <= A;
                WHEN "101" => S5 <= A;
                WHEN "110" => S6 <= A;
                WHEN "111" => S7 <= A;
                WHEN OTHERS => NULL;
            END CASE;
        END PROCESS;
    END ARCHITECTURE behavioral;