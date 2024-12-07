library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity REGISTERS_tb is
end REGISTERS_tb;

architecture bench of REGISTERS_tb is
    type etat_testbench is (INIT, OK, FALSE);
    --signals
    signal state : etat_testbench := INIT;
    signal CLK, WE, Reset : std_logic;
    signal W : std_logic_vector(31 downto 0);
    signal Rw : std_logic_vector(3 downto 0);
    signal Ra, Rb : std_logic_vector(3 downto 0);
    signal A, B : std_logic_vector(31 downto 0);

begin
    --assignments
    REGISTERS : entity work.REGISTERS port map(CLK, WE, Reset, W, Rw, Ra, Rb, A, B);

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
        WE <= '0';
        wait for 5 ns;
        --test of writing 
        WE <= '1';
        Rw <= "1001"; --address = 9
        W <= X"00000008"; --data to write = 8
        wait for 5 ns;

        WE <= '0';
        wait for 5 ns;
        WE <= '1';
        Rw <= "1000"; --address = 8
        W <= X"0000000A"; --data to write = 10
        wait for 5 ns;
        WE <= '0';

        --test of reading
        Ra <= "1001"; --address = 9
        Rb <= "1000"; --address = 8

        wait for 5 ns;
        --verification of the testbench
        if (A = X"00000008") and (B = X"0000000A") then
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