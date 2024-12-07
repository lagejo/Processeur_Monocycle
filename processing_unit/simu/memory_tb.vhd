library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity memory_tb is
end memory_tb;

architecture bench of memory_tb is
    type etat_testbench is (INIT,OK,FALSE);
    
    --signals
    signal state : etat_testbench :=INIT;
    signal CLK, WrEn, Reset : std_logic;
    signal Addr : std_logic_vector(5 downto 0) := "000000";
    signal DataIn, DataOut : std_logic_vector(31 downto 0) := (others => '0');


begin
    --assignments
    memory : entity work.memory port map(CLK, WrEn, Reset, DataIn, Addr, DataOut);

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
            --test of writing
            WrEn <= '1';
            DataIn <= X"00000008"; --data to write = 8
            Addr <= "001001"; --address = 9
            wait for 5 ns;

            WrEn <= '0';
            wait for 5 ns;
            WrEn <= '1';
            DataIn <= X"0000000A"; --data to write = 10
            Addr <= "001000"; --address = 8
            wait for 5 ns;
            WrEn <= '0';

            --test of reading
            Addr <= "001001"; --address = 9
            wait for 5 ns;
            --verification
            if DataOut /= X"00000008" then
                state <= FALSE;
            end if;
            wait for 5 ns;

            Addr <= "001000"; --address = 8
            wait for 5 ns;
            if DataOut /= X"0000000A" then
                state <= FALSE;
            end if;
            wait for 5 ns;

            --testbench verification
            if state = INIT then
                state <= OK;
            end if;

            Reset <= '1';
            wait for 5 ns;
            Reset <= '0';
            wait;
        end process;

end architecture;