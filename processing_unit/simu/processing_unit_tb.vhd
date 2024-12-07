library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity processing_unit_tb is
end processing_unit_tb;

architecture bench of processing_unit_tb is
    signal CLK, WE, Reset, WrEn, COM1, COM2 : std_logic;
    signal OP : std_logic_vector(2 downto 0) := (others => '0');
    signal N, Zero, C, V : std_logic;
    signal Rw, Ra, Rb : std_logic_vector(3 downto 0) := (others => '0');
    signal sortie_affiche : std_logic_vector(31 downto 0) := (others => '0');
    signal Imm : std_logic_vector(7 downto 0) := (others => '0');

begin

    traitement : entity work.processing_unit port map(CLK, WE, Reset, WrEn, COM1, COM2, OP, N, Zero, C, V, Rw, Ra, Rb,sortie_affiche, Imm);

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
        
    --addition of 2 registers
    Ra <= "0000";
    Rb <= "1111"; --value 48 stored in R(15)
    wait for 5 ns;
    COM1 <= '0'; --S <= B, bus B passes through the mux
    wait for 5 ns;
    OP <= "000"; 
    wait for 5 ns;

    assert N = '0' report "positive value while sign bit is negative"
                        severity error;

    --addition of a register with an immediate value
    Ra <= "0000"; --value 0 stored at address 0
    Imm <= X"0F"; 
    wait for 5 ns;
    COM1 <= '1'; --S <= Imm
    wait for 5 ns;
    OP <= "000"; 
    wait for 5 ns;

    assert N = '0' report "positive value while sign bit is negative"
                        severity error;

    --subtraction of 2 registers
    Ra <= "0000";
    Rb <= "1111"; --value 48 stored in R(15)
    wait for 5 ns;
    COM1 <= '0'; --S <= A
    wait for 5 ns;
    OP <= "010"; 
    wait for 5 ns;

    --the overflow bit will trigger because it's a subtraction between 2 positive numbers, leading to a negative result
    --in unsigned this bit is useless
    assert N = '1' report "negative value while sign bit is positive"
                        severity error;

    --subtraction of an immediate value from a register
    Ra <= "0000"; --value 0 stored at address 0
    Imm <= X"0F"; 
    wait for 5 ns;
    COM1 <= '1'; --S <= Imm
    wait for 5 ns;
    OP <= "010"; 
    wait for 5 ns;

    assert N = '1' report "negative value while sign bit is positive"
                        severity error;

    --copying value from one register to another register R(15) copied to R(1)
    Rb <= "1111";
    wait for 5 ns;
    COM1 <= '0'; --S <= B
    wait for 5 ns;
    OP <= "001";  --Y = B
    COM2 <= '0'; --S <= B
    wait for 5 ns;

    WE <= '1';
    Rw <= "0001";
    wait for 15 ns;

    --reading for verification
    WE <= '0';
    Ra <= "0001"; 
    wait for 1 ps; --small delay needed before changing OP so this Ra value is taken into account
    --otherwise there will be a 1ns zero flag peak because the old value would be considered for a very short time

    OP <= "011";  --Y = A
    wait for 5 ns;

    assert N = '0' report "positive value while sign bit is negative"
                        severity error;

    --reading from a register into a memory word
    COM2 <= '1'; --memory output will pass through final multiplexer
    --this is the value stored at address given by first 5 bits of bus B, at address 48 (value = 0)
    wait for 5 ns;

    --verification
    WE <= '1';
    Rw <= "0010"; --writing to R(2) the value read from memory for reading
    wait for 5 ns;

    Ra <= "0010"; --reading this value
    OP <= "011"; --transmitting value to ALU for sign bit verification (Y = A)
    wait for 5 ns;

    assert N = '0' report "positive value while sign bit is negative"
                        severity error;

    wait;
    end process;

end architecture;