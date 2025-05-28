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
                cards := 0;
                enemy_cards := 0;
            ELSE 
                CASE(current_state) IS 
                    WHEN sort => 
                    -- Aqui é necessário completar mais tarde com
                    -- o algoritmo de geração aleatoria
                    current_state <= decide;
                    WHEN decide
                    =>  IF(cards > 21) THEN
                            current_state <= lose;
                        ELSE
                            IF(STAY = '0' AND HIT = '1') THEN
                                -- Aqui foi melhor deixar 
                                -- voltando pra decide
                                current_state <= decide;
                            ELSIF(STAY = '1' AND HIT = '0') THEN
                                current_state <= enemy;
                            ELSIF(STAY = '0' AND HIT = '0') THEN
                                current_state <= decide;
                            END IF;
                        END IF;
                        
                    -- Aqui a lógica é baseada na pontuação.
                    WHEN enemy =>
                        -- Fazer a comparação depois de gerar
                        -- as cartas do "inimigo"
                        current_state <= compare;
                    WHEN compare
                    =>
                        IF(cards > enemy_cards) THEN
                            current_state <= win;
                        ELSIF(cards = enemy_cards) THEN 
                            current_state <= tie;
                        ELSIF(cards < enemy_cards) THEN 
                            current_state <= lose;
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