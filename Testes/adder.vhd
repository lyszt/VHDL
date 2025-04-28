LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY fourbitadder IS 
    PORT (
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        CLK: IN STD_LOGIC;
        S : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END ENTITY fourbitadder;


ARCHITECTURE behavioral of fourbitadder IS
signal s1: INTEGER := 0;
BEGIN 
    PROCESS(A,B, CLK)
    BEGIN
        IF(rising_edge(CLK)) THEN
            s1 <= to_integer(unsigned(A)) + to_integer(unsigned(B));
        END IF;
    END PROCESS;
    S <= std_logic_vector(to_unsigned(s1, 5));
END ARCHITECTURE behavioral;