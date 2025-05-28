    LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

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
    -- Geração de numero pseudoaleatório feito a partir de uma
    -- função matemática
    -- x⁸ + x⁶ + x⁵ + x⁴ + 1 com XOR
    -- "Linear feedback shift register"
    SIGNAL linear_feedback : STD_LOGIC_VECTOR(7 DOWNTO 0) := "10110101";


    BEGIN 
        PROCESS(CLOCK)
            VARIABLE feedback_bit : STD_LOGIC;
            VARIABLE card_value : INTEGER := 0;
            VARIABLE random_integer : INTEGER := 0;
        BEGIN 
            IF(RISING_EDGE(CLOCK)) THEN
                -- Gera um número aleatório toda mudada de clock
                -- poderia ser só no sort, mas enfim
                feedback_bit := linear_feedback(7) XOR linear_feedback(5) XOR linear_feedback(4) XOR linear_feedback(3);
                linear_feedback <= linear_feedback(6 DOWNTO 0) & feedback_bit;
            -- Somente ocorrem mudanças com o aperto do clock
                -- O jogador só pode "resetar" (começar, recomeçar) no fim e no inicio
                IF(START = '1' AND (current_state = initial OR current_state = ending)) THEN
                    current_state <= sort;
                    cards := 0;
                    enemy_cards := 0;
                ELSE 
                    CASE(current_state) IS 
                        WHEN sort => 
                            random_integer := to_integer(unsigned(linear_feedback));
                            card_value := (random_integer mod 13) + 1;
                            cards <= cards + card_value;
                            -- Módulo pra manter o numero dentro dos limites
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
                            -- Mesma coisa que em sort aqui

                            random_integer := to_integer(unsigned(linear_feedback));
                            card_value := (random_integer mod 13) + 1;
                            enemy_cards <= enemy_cards + card_value;
                            -- O inimigo aqui é bem ambicioso
                            IF(enemy_cards < 17) THEN
                                current_state <= enemy;
                            ELSIF(enemy_cards >= 17) THEN
                            -- compare equivale ao stay do inimigo
                                current_state <= compare;
                            END IF;
                            -- Fazer a comparação depois de gerar
                            -- as cartas do "inimigo"
                        WHEN compare
                        =>
                            IF(cards > enemy_cards) THEN
                                current_state <= win;
                            ELSIF(cards = enemy_cards) THEN 
                                current_state <= tie;
                            ELSE
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