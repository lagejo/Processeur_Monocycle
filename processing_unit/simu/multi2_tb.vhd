library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity MULTI2_tb is
end MULTI2_tb;

architecture bench of MULTI2_tb is

    --signals
    constant N : integer := 31;
    type etat_testbench is (INIT, OK, FALSE);
    signal state : etat_testbench := INIT;
    signal A, B : std_logic_vector(N downto 0) := (others => '0');
    signal S : std_logic_vector(N downto 0);
    signal COM : std_logic := '0';

begin

    multi : entity work.MULTI2 generic map (N) port map (A, B, S, COM);
    
    test : process
    begin
        --test of S = A
        COM <= '0';
        A <= X"0000000A"; -- A = 10
        wait for 1 ps; --allow time for the assignment to complete before testing the signal

        --verification
        if S /= X"0000000A" then
            state <= FALSE;
        end if; 
        wait for 5 ns;

        --test of S = B
        COM <= '1';
        B <= X"00000007"; -- B = 7
        wait for 1 ps;

        --verification
        if S /= X"00000007" then
            state <= FALSE;
        end if; 
        wait for 5 ns;

        --testbench verification
        if state = INIT then
            state <= OK;
        end if;
        wait for 5 ns;

        wait;

    end process;
end architecture;