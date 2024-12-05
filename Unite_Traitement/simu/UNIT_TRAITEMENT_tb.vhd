library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity UNIT_TRAITEMENT_tb is
end UNIT_TRAITEMENT_tb;

architecture bench of UNIT_TRAITEMENT_tb is

    signal CLK, Reset, WE, WrEn, COM1, COM2, N, C, V, Zero : std_logic := '0';
    signal OP : std_logic_vector(2 downto 0) := (others => '0');
    signal Rw, Ra, Rb : std_logic_vector(3 downto 0) := (others => '0');
    signal Imm : std_logic_vector(7 downto 0) := (others => '0');
    signal sortie_affiche : std_logic_vector(31 downto 0) := (others => '0');



begin

    traitement : entity work.UNIT_TRAITEMENT port map(CLK, WE, Reset, WrEn, COM1, COM2, OP, N, Zero, C, V, Rw, Ra, Rb,sortie_affiche, Imm);

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

    test : process
    begin 
        
    --addition de 2 registres
    Ra <= "0000";
    Rb <= "1111"; --valeur 48 stockée dans R(15)
    wait for 5 ns;
    COM1 <= '0'; --S <= B, le bus B passe dans le mux
    wait for 5 ns;
    OP <= "000"; 
    wait for 5 ns;

    assert N = '0' report "valeur positive alors que le bit de signe est négatif"
                        severity error;

    --addition d'un registre avec une valeur immédiate
    Ra <= "0000"; --valeur 0 stockée à l'adresse 0
    Imm <= X"0F"; 
    wait for 5 ns;
    COM1 <= '1'; --S <= Imm
    wait for 5 ns;
    OP <= "000"; 
    wait for 5 ns;

    assert N = '0' report "valeur positive alors que le bit de signe est négatif"
                        severity error;

    --soustraction de 2 registres
    Ra <= "0000";
    Rb <= "1111"; --valeur 48 stockée dans R(15)
    wait for 5 ns;
    COM1 <= '0'; --S <= A
    wait for 5 ns;
    OP <= "010"; 
    wait for 5 ns;

    --le bit d'overflow va se déclencher car il s'agit d'une soustraction entre 2 nombres positif, menant à un résultat négatif
    --en non signé ce bit est inutile

    assert N = '1' report "valeur negative alors que le bit de signe est positif"
                        severity error;

    --soustraction d'une valeur immédiate à un registre
    Ra <= "0000"; --valeur 0 stockée à l'adresse 0
    Imm <= X"0F"; 
    wait for 5 ns;
    COM1 <= '1'; --S <= Imm
    wait for 5 ns;
    OP <= "010"; 
    wait for 5 ns;

    assert N = '1' report "valeur negative alors que le bit de signe est positif"
                        severity error;
    --copie de la valeur d'un registre dans un autre registre R(15) copié dans R(1)
    Rb <= "1111";
    wait for 5 ns;
    COM1 <= '0'; --S <= B
    wait for 5 ns;
    OP <= "001";  --Y = B
    COM2 <= '0'; --S <= B
    wait for 5 ns;

    WE <= '1';
    Rw <= "0001";
    wait for 15 ns;

    --lecture pour vérification
    WE <= '0';
    Ra <= "0001"; 
    wait for 1 ps; --il faut laisser un petit délai avant de changer OP pour que ce soit bien cette valeur de Ra qui
    --soit prise en compte, sinon on aura un pic de 1 ns du flag zero parce que ce sera l'ancinne valeur qui aura été prise en compte pendant un très cours 
    --laps de temps

    OP <= "011";  --Y = A
    wait for 5 ns;

    assert N = '0' report "valeur positive alors que le bit de signe est negatif"
                        severity error;

    --lecture d'un registre dans un mot de la mémoire
    COM2 <= '1'; --la sortie de la mémoire passera dans le multiplexeur final
    --il s'agit de la valeur qui est stcokée à l'adresse des 5 premiers bits contenue dans le bus B, à l'adresse 48 (valeur = 0)
    wait for 5 ns;

    --verification
    WE <= '1';
    Rw <= "0010"; --écriture à R(2) de la valeur lue dans la mémoire pour la lire
    wait for 5 ns;

    Ra <= "0010"; --lecture de cette valeur
    OP <= "011"; --tranmission de la valeur à l'ALU pour vérification du bit de signe (Y = A)
    wait for 5 ns;


    assert Zero = '1' report "bit de Zero à 0 alors que la valeur vaut 0"
                        severity error;

    assert N = '0' report "valeur positive alors que le bit de signe est negatif"
                        severity error;
    wait for 5 ns;

    wait;

    end process;

end architecture;