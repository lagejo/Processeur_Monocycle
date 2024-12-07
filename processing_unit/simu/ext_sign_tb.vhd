library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity EXT_SIGN_tb is
end entity;

architecture bench of EXT_SIGN_tb is

    type etat_testbench is (INIT,OK,FALSE);

    signal N : integer := 23; --test on a 24-bit input signal
    signal E : std_logic_vector(N downto 0) := (others => '0'); 
    signal S : std_logic_vector(31 downto 0) := (others => '0');
    signal state : etat_testbench;

begin

    EXTSIGN : entity work.EXT_SIGN generic map (N) port map (E, S);

    test : process
    begin
        --test negative number
        E <= X"FFFFF2"; --test with any value of E
        wait for 1 ps;
        --for the sign extension to work correctly, S 
        --must equal E + 8 added ones (preserving the negative sign)

        if (S /= X"FFFFFFF2") then
            state <= FALSE;
        end if;

        --test positive number
        E <= X"0FFFF2"; --test with any value of E
        wait for 1 ps;
        --for the sign extension to work correctly, S
        --must equal E + 8 added zeros (preserving the positive sign)

        --testbench verification
        if (S= X"000FFFF2") and state = INIT then
            state <= OK;
        else
            state <= FALSE;
        end if;
        wait for 1 ps;
        wait;
    end process;

end architecture;