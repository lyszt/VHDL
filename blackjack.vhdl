    LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    ENTITY blackjack IS 
        PORT(
            START: IN STD_LOGIC;
            STAY: IN STD_LOGIC;
            HIT : IN STD_LOGIC;
            CLOCK: IN STD_LOGIC;
            CARTA1, CARTA2 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            CARTAINIMIGO : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            ganha, empata, perde: OUT STD_LOGIC
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
            VARIABLE card_value_1 : INTEGER := 0;
            VARIABLE card_value_2 : INTEGER := 0;
            VARIABLE random_integer : INTEGER := 0;
        BEGIN 
            IF(RISING_EDGE(CLOCK)) THEN
                -- Por que colocar aqui e não no initial?
                -- Pra ele só piscar uma vez pra mostrar o resultado
                -- Apertar o clock pra apagar
                    ganha <= '0';
                    empata <= '0';
                    perde <= '0';
                -- Gera um número aleatório toda mudada de clock
                -- poderia ser só no sort, mas enfim
                feedback_bit := linear_feedback(7) XOR linear_feedback(5) XOR linear_feedback(4) XOR linear_feedback(3);
                linear_feedback <= linear_feedback(6 DOWNTO 0) & feedback_bit;
            -- Somente ocorrem mudanças com o aperto do clock
                -- O jogador só pode "resetar" (começar, recomeçar) no fim e no inicio
                IF(START = '1' AND (current_state = initial OR current_state = ending)) THEN
                    current_state <= sort;
                    cards <= 0;
                    enemy_cards <= 0; 
                ELSE 
                    CASE(current_state) IS 
                        WHEN sort => 
                            -- mod 10, se ultrapassa 10 (ace), ganha 1, então não é 0
                            -- e isso é às
                            random_integer := to_integer(unsigned(linear_feedback));
                            card_value_1  := (random_integer mod 10) + 1;
                            random_integer := to_integer(unsigned(linear_feedback));
                            card_value_2   := ((random_integer + 7) mod 10) + 1;
                            carta1 <= std_logic_vector(to_unsigned(card_value_1,5));
                            carta2 <= std_logic_vector(to_unsigned(card_value_2,5));
                            cards <= cards + card_value_1 + card_value_2;
                            -- Módulo pra manter o numero dentro dos limites
                        current_state <= decide;
                        WHEN decide
                        =>  IF(cards > 21) THEN
                                current_state <= lose;
                            ELSE
                                IF(STAY = '0' AND HIT = '1') THEN
                                    -- Aqui foi melhor deixar 
                                    -- voltando pra decide
                                    random_integer := to_integer(unsigned(linear_feedback));
                                    card_value_1 := ((random_integer mod 10) + 1);
                                    cards <= cards + card_value_1;
                                    cartainimigo <= std_logic_vector(to_unsigned(card_value_1,5));
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
                            -- O inimigo aqui é bem ambicioso
                            IF(enemy_cards < 17) THEN
                            random_integer := to_integer(unsigned(linear_feedback));
                            enemy_cards    <= enemy_cards + ((random_integer mod 10) + 1);
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
                                ganha <= '1';
                            ELSIF(cards = enemy_cards) THEN 
                                current_state <= tie;
                                empata <= '1';
                            ELSE
                                current_state <= lose;
                                perde <= '1';
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