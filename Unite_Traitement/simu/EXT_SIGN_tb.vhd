library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity EXT_SIGN_tb is
end entity;

architecture bench of EXT_SIGN_tb is

    type etat_testbench is (INIT,OK,FALSE);

    signal N : integer := 23; --test sur un signal d'entrée de 24 bits
    signal E : std_logic_vector(N downto 0) := (others => '0'); 
    signal S : std_logic_vector(31 downto 0) := (others => '0');
    signal state : etat_testbench;

begin

    EXTSIGN : entity work.EXT_SIGN generic map (N) port map (E, S);

    test : process
    begin
        --test nombre négatif
        E <= X"FFFFF2"; --test avec une valeur quelquonque de E
        wait for 1 ps;
        --pour que l'extension de signe ait bien fonctionnée S 
        --doit être égal à E + 8 uns rajoutés, (conservation du signe -)

        if (S /= X"FFFFFFF2") then
            state <= FALSE;
        end if;

        --test nombre pistif
        E <= X"0FFFF2"; --test avec une valeur quelquonque de E
        wait for 1 ps;
        --pour que l'extension de signe ait bien fonctionnée S 
        --doit être égal à E + 8 zéros rajoutés, (conservation du signe +)

        --vérification du testbench
        if (S= X"000FFFF2") and state = INIT then
            state <= OK;
        else
            state <= FALSE;
        end if;
        wait for 1 ps;


        wait;
    end process;

end architecture;