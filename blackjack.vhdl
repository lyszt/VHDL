LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY blackjack IS 
    PORT(
        START: IN STD_LOGIC;
        STAY: IN STD_LOGIC;
        HIT : IN STD_LOGIC;
        CLOCK: IN STD_LOGIC;
        RESET: IN STD_LOGIC;
        YOUR_TURN: OUT STD_LOGIC;
        CARTA1: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        ganha, empata, perde: OUT STD_LOGIC
        TENTH  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
        UNIT: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        CHOOSE_DISPLAYS: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)  
    );
END ENTITY blackjack;

ARCHITECTURE behavioral OF blackjack IS
TYPE game_state IS (initial,sort,decide,enemy,compare,win,tie,lose, ending);
SIGNAL current_state: game_state := initial;
SIGNAL cards: INTEGER := 0;
SIGNAL enemy_cards: INTEGER := 0;

SIGNAL tenths_player : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL units_player : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL tenths_enemy : STD_LOGIC_VECTOR(3 DOWNTO 0);



-- Geração de numero pseudoaleatório feito a partir de uma
-- função matemática
-- x⁸ + x⁶ + x⁵ + x⁴ + 1 com XOR
-- "Linear feedback shift register"
SIGNAL linear_feedback : STD_LOGIC_VECTOR(7 DOWNTO 0) := "10110101";
SIGNAL hit_signal : STD_LOGIC := '0';
SIGNAL stay_signal : STD_LOGIC := '0';

CHOOSE_DISPLAYS <= "000"
-- anodo ou o outro

BEGIN
    PROCESS(cards, enemy_cards)
    BEGIN
        tenths_player <= STD_LOGIC_VECTOR(TO_UNSIGNED(cards MOD 10, 4));
        units_player <= STD_LOGIC_VECTOR(TO_UNSIGNED(cards / 10, 4));
        -- Forma matemática de pegar o ultimo digito e a dezena acima
        tenths_enemy       <= STD_LOGIC_VECTOR(TO_UNSIGNED(enemy_cards / 10, 4));
        -- faz-se isso pra dezena do jogador e pra dezena do inimigo (que aparece no 3° display)
    END PROCESS;

    -- achei isso mais pratico do que fazer componentes, preguiça
    WITH units_player SELECT
        UNIT <=
            "0111111" WHEN "0000", 
            "0000110" WHEN "0001", 
            "1011011" WHEN "0010", 
            "1001111" WHEN "0011",
            "1100110" WHEN "0100", 
            "1101101" WHEN "0101", 
            "1111101" WHEN "0110", 
            "0000111" WHEN "0111", 
            "1111111" WHEN "1000", 
            "1101111" WHEN "1001", 
            "0000000" WHEN OTHERS;

    WITH tenths_player SELECT
        TENTH <=
            "0111111" WHEN "0000", 
            "0000110" WHEN "0001", 
            "1011011" WHEN "0010", 
            "1001111" WHEN "0011",
            "1100110" WHEN "0100", 
            "1101101" WHEN "0101", 
            "1111101" WHEN "0110", 
            "0000111" WHEN "0111", 
            "1111111" WHEN "1000", 
            "1101111" WHEN "1001", 
            "0000000" WHEN OTHERS;

    WITH tenths_enemy SELECT
        CARTA1 <=
            "0111111" WHEN "0000", 
            "0000110" WHEN "0001", 
            "1011011" WHEN "0010", 
            "1001111" WHEN "0011",
            "1100110" WHEN "0100", 
            "1101101" WHEN "0101", 
            "1111101" WHEN "0110", 
            "0000111" WHEN "0111", 
            "1111111" WHEN "1000", 
            "1101111" WHEN "1001", 
            "0000000" WHEN OTHERS;

    PROCESS(CLOCK)
        VARIABLE v_cards: INTEGER := 0;
        VARIABLE v_enemy_cards: INTEGER := 0;
        VARIABLE feedback_bit : STD_LOGIC;
        VARIABLE card_value_1 : INTEGER := 0;
        VARIABLE card_value_2 : INTEGER := 0;
        VARIABLE random_integer : INTEGER := 0;
    
    BEGIN 
        IF(RISING_EDGE(CLOCK)) THEN
            IF(current_state /= decide) THEN
                YOUR_TURN <= '0';
            ELSE 
                YOUR_TURN <= '1';
            END IF;

            hit_signal <= hit;
            stay_signal <= stay;
            
            
            
            -- Gera um número aleatório toda mudada de clock
            -- poderia ser só no sort, mas enfim
            
        -- Somente ocorrem mudanças com o aperto do clock
            -- O jogador só pode "resetar" (começar, recomeçar) no fim e no inicio

                IF(RESET = '1') THEN
                    current_state <= ending;
                    cards <= 0;
                    enemy_cards <= 0;
                    digit_type <= '0'
                    CHOOSE_DISPLAYS <= "111"
                    -- tenho q ver se isso funciona na fpga
                ELSIF(START = '1' AND (current_state = initial OR current_state = ending)) THEN
                    current_state <= sort;
                    cards <= 0;
                    enemy_cards <= 0;
                    CHOOSE_DISPLAYS <= "000"

                -- Apertar o clock pra apagar
                    ganha <= '0';
                    empata <= '0';
                    perde <= '0';
            ELSE 
                feedback_bit := linear_feedback(7) XOR linear_feedback(5) XOR linear_feedback(4) XOR linear_feedback(3);
                linear_feedback <= linear_feedback(6 DOWNTO 0) & feedback_bit;
                CASE(current_state) IS 
                    WHEN sort => 
                        -- mod 10, se ultrapassa 10 (ace), ganha 1, então não é 0
                        -- e isso é às
                        random_integer := to_integer(unsigned(linear_feedback));
                        card_value_1  := (random_integer mod 10) + 1;
                        random_integer := to_integer(unsigned(linear_feedback));
                        card_value_2   := ((random_integer + 7) mod 10) + 1;
                        cards <= cards + card_value_1 + card_value_2;
                        -- Módulo pra manter o numero dentro dos limites
                        current_state <= decide;
                    WHEN decide
                    =>  IF(cards > 21) THEN
                            current_state <= lose;
                        ELSIF(cards = 21) THEN
                            current_state <= enemy;
                        ELSIF(HIT = '1' AND STAY = '1') THEN
                            current_state <= decide;
                        ELSIF(HIT = '0' AND hit_signal = '1') THEN
                                -- Aqui foi melhor deixar 
                                -- voltando pra decide
                                random_integer := to_integer(unsigned(linear_feedback));
                                card_value_1 := ((random_integer mod 10) + 1);
                                cards <= cards + card_value_1;
                                
                                IF((cards + card_value_1) > 21) THEN
                                    current_state <= lose;
                                ELSE
                                    current_state <= decide;
                                END IF;
                        ELSIF(STAY = '0' AND stay_signal = '1') THEN
                            current_state <= enemy;
                        END IF;
                        
                    -- Aqui a lógica é baseada na pontuação.
                    WHEN enemy =>
                        -- Mesma coisa que em sort aqui
                        -- O inimigo aqui é bem ambicioso

                        IF(enemy_cards < 17) THEN
                            random_integer := to_integer(unsigned(linear_feedback));
                            card_value_1 := ((random_integer mod 10) + 1);
                            enemy_cards <= enemy_cards + card_value_1;

                            current_state <= enemy;
                        ELSIF(enemy_cards >= 17) THEN
                        -- compare equivale ao stay do inimigo
                            current_state <= compare;
                        ELSE 
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
                    WHEN ending 
                    => NULL;
                    WHEN win
                    =>
                        current_state <= ending;
                        ganha <= '1';
                    WHEN tie
                    => current_state <= ending;
                        empata <= '1';
                    WHEN lose
                    => current_state <= ending;
                        perde <= '1';
                    WHEN OTHERS =>
                        current_state <= initial;
                END CASE;
            END IF;
            IF (current_state /= initial AND current_state /= ending AND RESET = '0') THEN
                CHOOSE_DISPLAYS <= "000";
            END IF;

        END IF;
        
END PROCESS;
END ARCHITECTURE behavioral;

