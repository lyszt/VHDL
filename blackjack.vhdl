LIBRARY ieee;
use ieee.std_logic_1164.all;


ENTITY blackjack IS 
    PORT(
        START: IN STD_LOGIC;
        STAY: IN STD_LOGIC;
        HIT : IN STD_LOGIC;
        CLOCK: IN STD_LOGIC;
        WIN, TIE, LOSE: OUT STD_LOGIC
    );
END ENTITY blackjack;

ARCHITECTURE behavioral OF blackjack IS
TYPE game_state IS (initial,sort,decide,ace,enemy,compare,win,tie,lose, ending);
SIGNAL current_state: game_state := initial;
SIGNAL cards: INTEGER := 0;
SIGNAL enemy_cards: INTEGER := 0;
BEGIN 
    PROCESS(CLOCK)
    BEGIN 
        IF(RISING_EDGE(CLOCK)) THEN
        -- Somente ocorrem mudanças com o aperto do clock
            -- O jogador só pode "resetar" (começar, recomeçar) no fim e no inicio
            IF(START = '1' AND (current_state = initial OR current_state = ending)) THEN
                current_state <= sort;
            ELSE 
                CASE(current_state) IS 
                    WHEN sort => current_state <= decide;
                    WHEN decide
                    => IF(STAY = '0' AND HIT = '1') THEN
                            current_state <= sort;
                        ELSIF(STAY = '1' AND HIT = '0') THEN
                            current_state <= enemy;
                        ELSIF(STAY = '0' AND HIT = '0') THEN
                            current_state <= decide;
                        END IF;
                    -- Aqui a lógica é baseada na pontuação.
                    WHEN enemy =>

                    WHEN compare
                    =>
                        IF(cards > enemy_cards) THEN
                            current_state <= win;
                        ELSIF(cards = enemy_cards) THEN 
                            current_state <= tie;
                        ELSIF(cards < enemy_cards) THEN 
                            current_state <= lose;
                        ELSE THEN
                            current_state <= tie;
                        END IF;
                    WHEN win
                    =>
                        current_state <= ending;
                    WHEN tie
                    => current_state <= ending;
                    WHEN lose
                    => current_state <= ending;
                    WHEN OTHERS =>
                        current_state <= initial;
                END CASE;
            END IF;
        END IF;
    
    END PROCESS;
END ARCHITECTURE behavioral;