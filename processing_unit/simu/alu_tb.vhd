library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity ALU_tb is 
end ALU_tb;

Architecture Bench of ALU_tb is

    signal OP : std_logic_vector(2 downto 0) :=(others => '-');
    signal N,Zero,C,V : std_logic;
    signal A, B, S : std_logic_vector(31 downto 0);
    signal nb_testA, nb_testB : integer range INTEGER'low to INTEGER'high; 

begin

    nb_testA <= 3;
    nb_testB <= -4;
    A <= std_logic_vector(to_signed(nb_testA,32));
    B <= std_logic_vector(to_signed(nb_testB,32));

    ALU : entity work.ALU port map( OP => OP, N => N, A => A, B => B, S => S, Zero => Zero, C => C, V => V);

    process
        begin
        report "Starting ALU testbench";

            OP <= "000";         --S = A + B
            wait for 10ns;

            OP <= "001";         --S = B
            wait for 10ns;

            OP <= "010";         --S = A - B
            wait for 10ns;

            OP <= "011";         --S = A
            wait for 10ns;

            OP <= "100";         --S = A or B
            wait for 10ns;

            OP <= "101";         --S = A and B
            wait for 10ns;

            OP <= "110";         --S = A xor B
            wait for 10ns;

            OP <= "110";         --S = A xor B
            wait for 10ns;

            OP <= "111";         --S = not(A) 
            wait for 10ns;

            wait;
    end process;



end architecture;
