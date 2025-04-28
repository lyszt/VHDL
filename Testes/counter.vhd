LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY counter IS 
    PORT(
        clk: in STD_LOGIC;
        final: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY counter;

ARCHITECTURE behavioral OF counter IS 
SIGNAL current: INTEGER := 0;
BEGIN 
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF current = 9 THEN
                current <= 0;
            ELSE
                current <= current + 1;
            END IF;
        END IF;
    END PROCESS;
    final <= std_logic_vector(to_unsigned(current,4));
END ARCHITECTURE;