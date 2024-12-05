library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity unite_gestion_tb is 
end unite_gestion_tb;

Architecture Bench of unite_gestion_tb is
    --signals
    signal CLK : std_logic;
    signal Reset, nPCSel : std_logic := '0';
    signal offset : std_logic_vector(23 downto 0) := (others => '0');
    signal instruction : std_logic_vector(31 downto 0);
begin
    
    unite_gestion : entity work.unite_gestion port map(Reset, CLK, nPCSel, instruction);

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

    process

    begin
        report "Starting unite_gestion testbench";
        --test de instruction memory(0)
        wait for 5 ns;
        assert instruction = x"E3A01020";
        --test de instruction memory(1)
        wait for 8 ns;
        assert instruction = x"E3A02000";
        --test de instruction memory(2)
        wait for 10 ns;
        assert instruction = x"E6110000";
        --test de instruction memory(3)
        wait for 10 ns;
        assert instruction = x"E0822000";
        --test de instruction memory(4)
        wait for 10 ns;
        assert instruction = x"E2811001";
        --test de instruction memory(5)
        wait for 10 ns;
        assert instruction = x"E351002A";
        --test de instruction memory(6)
        wait for 10 ns;
        assert instruction = x"BAFFFFFB";
        --test de instruction memory(7)
        wait for 10 ns;
        assert instruction = x"E6012000";
        --test de instruction memory(8)
        wait for 10 ns;
        assert instruction = x"EAFFFFF7";


        wait;
    end process;
    
    
    
end architecture;