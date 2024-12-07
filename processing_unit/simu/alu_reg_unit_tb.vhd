library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity alu_reg_unit_tb is
end alu_reg_unit_tb;

architecture bench of alu_reg_unit_tb is
    signal CLK, WE, Reset : std_logic;
    signal OP : std_logic_vector(2 downto 0);
    signal N, Zero, C, V : std_logic;
    signal Rw, Ra, Rb : std_logic_vector(3 downto 0);
    signal sortie_affiche : std_logic_vector(31 downto 0);

begin
    --assignments
    alu_reg_unit : entity work.alu_reg_unit port map(CLK, WE, Reset, OP, N, Zero, C, V, Rw, Ra, Rb, sortie_affiche);

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
        Reset <= '0';
        OP <= "000";
        WE <= '0';

        --verification of R(1) = R(15), operation Y = B so OP = "001" (B) so R(1) contains value 48
        Rb <= "1111"; -- Rb = 15 for transmission to ALU
        OP <= "001"; --value in R(15) goes to output
        wait for 5 ns; --wait for next rising edge of CLK, as we cannot use the same one, a small delay is needed

        --writing ALU output
        WE <= '1';
        Rw <= "0001"; --register bank writes value to R(1)        
        wait for 5 ns;
        WE <= '0';

        assert N = '0' report "positive value while sign bit is negative"
        severity error;

        --verification of R(1) = R(1) + R(15), operation Y = A + B so OP = "000" (ADD) so R(1) contains value 96, 2*R(15)
        Ra <= "0001"; --A takes value of R(1)
        Rb <= "1111"; --B takes value of R(15)
        OP <= "000";
        wait for 5 ns;

        --writing ALU output
        WE <= '1';
        Rw <= "0001"; --register bank writes value to R(1)
        Rb <= "0001";
        wait for 5 ns;
        WE <= '0';

        --verification
        assert N = '0' report "positive value while sign bit is negative"
        severity error;

        --verification of R(2) = R(1) + R(15), operation Y = A + B so OP = "000" (ADD) so R(2) contains value 3*R(15)
        Ra <= "0001"; --A takes value of R(1)
        Rb <= "1111"; --B takes value of R(15)
        OP <= "010";
        wait for 5 ns;

        --writing ALU output
        WE <= '1';
        Rw <= "0011"; --register bank writes value to R(3)        
        wait for 5 ns;
        WE <= '0';

        --verification
        assert N = '0' report "positive value while sign bit is negative"
        severity error;
        wait for 5 ns;

        --verification of R(5) = R(7) - R(15), operation Y = A - B so OP = "010" (SUB) so R(3) contains value -R(15)
        Ra <= "0111"; --A takes value of R(7)
        Rb <= "1111"; --B takes value of R(15)
        wait for 1 ps;
        OP <= "010";
        wait for 5 ns;

        --writing ALU output
        WE <= '1';
        Rw <= "0101"; --register bank writes value to R(5)        
        wait for 5 ns;
        WE <= '1';

        --verification
        assert N = '1' report "negative value while sign bit is positive"
        severity error;
        wait for 5 ns;

        wait;        
    end process;

end architecture;