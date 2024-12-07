library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity ALU is
    Port(
        OP : in std_logic_vector(2 downto 0);
        A, B : in std_logic_vector(31 downto 0);
        S : out std_logic_vector(31 downto 0);
        N, Zero, C, V : out std_logic
    );
end ALU;

architecture RTL of ALU is

    --signals
    signal A2, B2 : signed(31 downto 0) := (others => '0');
    signal S2 : std_logic_vector(31 downto 0) := (others => '-');

begin

    operations : process (OP, A, B)
    begin
        case OP is 
            when "000" => S2 <= std_logic_vector(signed(A) + signed(B)); --std_logic_vector(A2 + B2);
            when "001" => S2 <= B;
            when "010" => S2 <= std_logic_vector(signed(A) - signed(B));           
            when "011" => S2 <= A;
            when "100" => S2 <= A or B;
            when "101" => S2 <= A and B;
            when "110" => S2 <= A xor B;
            when "111" => S2 <= not(A);
            when others => S2 <= (others => '-');
        end case;
    end process;

    check : process(OP, A, B, S2)
    begin

        --carry if one of the msb is 1 and the result has an msb = 0
        if OP = "000" or OP = "010" then --there can be no carry if there is a sum
            --in signed C does not work, it is anyway useless
            if (((A(31) = '1') or (B(31) = '1')) and (S2(31) = '0')) then
                C <= '1';
            else
                C <= '0';   
            end if;
        else
            C <= '0';
        end if;
        --overflow
        if OP = "000" or OP = "010" then --there can be no carry if there is a sum
            if (((A(31) = '1') and (B(31) = '1')) and (S2(31) = '0')) then
                V <= '1';
            elsif (((A(31) = '0') and (B(31) = '0')) and (S2(31) = '1')) then
                V <= '1';
            else
                V <= '0';
            end if;
        else 
            V <= '0';
        end if;
        --zero
        if S2 = X"00000000" then    
            Zero <= '1';
        elsif S2 /= X"00000000" then
            Zero <= '0';
        end if;
    end process;
    S <= S2; 
    N <= S2(31); --sign bit, last bit of the signal

end architecture;