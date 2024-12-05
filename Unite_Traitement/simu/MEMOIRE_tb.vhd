library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity MEMOIRE_tb is
end MEMOIRE_tb;

architecture bench of MEMOIRE_tb is
    type etat_testbench is (INIT,OK,FALSE);
    --signals
    signal state : etat_testbench :=INIT;
    signal CLK, WrEn, Reset : std_logic;
    signal Addr : std_logic_vector(5 downto 0) := "000000";
    signal DataIn, DataOut : std_logic_vector(31 downto 0) := (others => '0');


begin
    --affectations
    memory : entity work.MEMOIRE port map(CLK, WrEn, Reset, DataIn, Addr, DataOut);

    clock : process
    begin
        while (now <= 30 ns) loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    test : process
        begin
        report "Starting REGISTERS testbench";
            Reset <= '0';
            WrEn <= '0';
            wait for 5 ns;
            --test de l'écriture 
            WrEn <= '1';
            DataIn <= X"00000008"; --donnée à écrire = 8
            Addr <= "001001"; --adresse = 9
            wait for 5 ns;

            WrEn <= '0';
            wait for 5 ns;
            WrEn <= '1';
            Addr <= "011000"; --adresse = 8
            DataIn <= X"0000000A"; --donnée à écrire = 10
            wait for 5 ns;
            WrEn <= '0';

            --test de la lecture
            Addr <= "001001"; --adresse = 9

            wait for 5 ns;
            --vérification du testbench
            if (DataOut = X"00000008") then
                state <= OK;
            else 
                state <= FALSE;
            end if;

            Addr <= "011000"; --adresse = 24

            wait for 5 ns;
            --vérification du testbench
            if (DataOut = X"0000000A") then
                state <= OK;
            else 
                state <= FALSE;
            end if;


            wait for 5 ns;
            Reset <= '1';
            wait for 5 ns;
            Reset <= '0';
            wait;
    end process;
end architecture;
