library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity UNIT_ALU_REG_tb is
end UNIT_ALU_REG_tb;

architecture bench of UNIT_ALU_REG_tb is

    -- type etat_testbench is (INIT, STEP1_OK, STEP2_OK, STEP3_OK, STEP4_OK, STEP5_OK, OK,FALSE);

    signal Reset, CLK, WE, N, C, V, Zero : std_logic;
    signal Rw, Ra, Rb : std_logic_vector(3 downto 0);
    signal OP : std_logic_vector(2 downto 0);
    -- signal state : etat_testbench := INIT;

begin

    UNIT : entity work.UNIT_ALU_REG port map(Reset, CLK, WE, Rw, Ra, Rb, OP, N, C, V, Zero);

    clock : process
    begin
        while (now <= 100 ns) loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    --verification de R(1) = R(15), opération Y = B donc OP ="01"

    operations : process
    begin 
    --initialisation de tous les signaux à 0
        Reset <= '0';
        Ra <= "0000";
        Rb <= "0000";
        Rw <= "0000";
        OP <= "000";
        WE <= '0';

        -- --test du zéro
        -- Rb <= "1110"; -- Rb = 14 pour transmission à l'ALU
        -- OP <= "001"; --la valeur contenue dans R(15) part en sortie
        -- -- wait for 10 ns; --attendre le prochain front montant de CLK, car on ne peut pas utiliser le même, il y a besoin d'un petit délai

        -- --ecriture de la sortie de l'ALU
        -- WE <= '0';
        -- -- Rw <= "0001"; --le banc de registres écrit la valeur en R(1)        
        -- wait for 5 ns;

        -- assert N = '0' report "valeur positive alors que le bit de signe est négatif"
        -- severity error;

    -- --verification de R(1) = R(15), opération Y = B donc OP = "001" (B) donc à R(1) il y a la valeur 48

        Rb <= "1111"; -- Rb = 15 pour transmission à l'ALU
        OP <= "001"; --la valeur contenue dans R(15) part en sortie
        wait for 5 ns; --attendre le prochain front montant de CLK, car on ne peut pas utiliser le même, il y a besoin d'un petit délai

        --ecriture de la sortie de l'ALU
        WE <= '1';
        Rw <= "0001"; --le banc de registres écrit la valeur en R(1)        
        wait for 5 ns;
        WE <= '0';


        assert N = '0' report "valeur positive alors que le bit de signe est négatif"
        severity error;



    --verification de R(1) = R(1) + R(15), opération Y = A + B donc OP = "000" (ADD) donc à R(1) il y a la valeur 96, 2*R(15)
            
        Ra <= "0001"; --A prend la valeur de R(1)
        Rb <= "1111"; --B prend la valeur de R(15)
        -- wait for 1 ps;
        OP <= "000";
        wait for 5 ns;

        --ecriture de la sortie de l'ALU
        WE <= '1';
        Rw <= "0001"; --le banc de registres écrit la valeur en R(1)
        Rb <= "0001";
        wait for 5 ns;
        WE <= '0';

    -- verification
        assert N = '0' report "valeur positive alors que le bit de signe est négatif"
        severity error;


    -- --verification de R(2) = R(1) + R(15), opération Y = A + B donc OP = "000" (ADD) donc à R(2) il y a la valeur  3*R(15)
        Ra <= "0001"; --A prend la valeur de R(1)
        Rb <= "1111"; --B prend la valeur de R(15)
        OP <= "000";
        wait for 5 ns;

        --ecriture de la sortie de l'ALU
        WE <= '1';
        Rw <= "0010"; --le banc de registres écrit la valeur en R(2)
        OP <= "011";
        Rb <= "0001";    
        wait for 5 ns;
        WE <= '0';

        --verification
        assert N = '0' report "valeur positive alors que le bit de signe est négatif"
        severity error;
        wait for 5 ns;
    


    --verification de R(3) =  R(1) - R(15), opération Y = A - B donc OP = "010" (SUB) donc à R(3) il y a la valeur  2*R(15)
        Ra <= "0001"; --A prend la valeur de R(1)
        Rb <= "1111"; --B prend la valeur de R(15)
        wait for 1 ps; --petit délai necessaire sinon Z
        OP <= "010";
        wait for 5 ns;

        --ecriture de la sortie de l'ALU
        WE <= '1';
        Rw <= "0011"; --le banc de registres écrit la valeur en R(3)        
        wait for 5 ns;
        WE <= '0';


        --verification
        assert N = '0' report "valeur positive alors que le bit de signe est négatif"
        severity error;
        wait for 5 ns;


    
    --verification de R(5) =  R(7) - R(15), opération Y = A - B donc OP = "010" (SUB) donc à R(3) il y a la valeur  -R(15)
        Ra <= "0111"; --A prend la valeur de R(7)
        Rb <= "1111"; --B prend la valeur de R(15)
        wait for 1 ps;
        OP <= "010";
        wait for 5 ns;

        --ecriture de la sortie de l'ALU
        WE <= '1';
        Rw <= "0101"; --le banc de registres écrit la valeur en R(5)        
        wait for 5 ns;
        WE <= '1';

        --verification
        assert N = '1' report "valeur negative alors que le bit de signe est positif"
        severity error;
        wait for 5 ns;

        wait;        
    end process;

end architecture;