library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity processor_tb is 
end processor_tb;

Architecture Bench of processor_tb is
    --signals
    signal CLK : std_logic := '0';
    signal affichage : std_logic_vector(31 downto 0) := (others => '0');
    signal Reset : std_logic := '0';
    signal HEX0, HEX1, HEX2, HEX3 : std_logic_vector(0 to 6) := (others => '0');
begin
    
    proc : entity work.processor port map(Reset, CLK, affichage, HEX0, HEX1, HEX2, HEX3);

    clock : process
    begin
        while (now <= 600 ns) loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    process

    begin
        report "Starting processor testbench";

        wait;
    end process;
    
    
    
end architecture;