library ieee;
use ieee.std_logic_1164.all;



entity mux is
    port (
    I : in bit_vector (3 downto 0); -- Input
    SEL : in bit_vector (1 downto 0); -- Select
    Y : out bit -- Output
    );
end entity mux


architecture behaviour of mux is 
begin 
    process(I, SEL)
    begin
        case SEL is 
            when "00" =>
                Y <= I(0);
            when "01" =>
                Y <= I(1);
            when "10" =>    
                Y <= I(2);
            when "11" =>
                Y <= I(3);
            when others =>
                Y <= '0';
        end case;
    end process;
end architecture behaviour;