library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity MULTI2_tb is 
end MULTI2_tb;

architecture bench of MULTI2_tb is

    type etat_testbench is (INIT, OK, FALSE);

    signal N : integer := 31; --test sur 32 bits
    signal A, B, S : std_logic_vector(N downto 0) := (others => '0');
    signal COM : std_logic;

    signal state : etat_testbench := INIT;


    
begin

    multi : entity work.MULTI2 generic map (N) port map (A, B, S, COM);
    
    test : process
    begin
        --test de S = A
        COM <= '0';
        A <= X"0000000A"; -- A = 10
        wait for 1 ps; --laisser le temps à l'affectation de se faire avant de tester le signal

        --verification
        if S /= X"0000000A" then
            state <= FALSE;
        end if; 
        wait for 5 ns;

        --test de S = B
        COM <= '1';
        B <= X"00000007"; -- B = 7
        wait for 1 ps; 

        --verification
        if S /= X"00000007" then
            state <= FALSE;
        end if; 
        wait for 5 ns;

        --verification testbench
        if state = INIT then
            state <= OK;
        end if;
        wait for 5 ns;

        wait;

    end process;
end architecture;