library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity UNIT_ALU_REG is
    Port(
        -- W : in std_logic_vector(31 downto 0);
        Reset, CLK, WE : in std_logic;
        Rw, Ra, Rb : in std_logic_vector(3 downto 0);
        OP : in std_logic_vector(2 downto 0);
        -- S : out std_logic_vector(31 downto 0);
        N,C,V,Zero : out std_logic
    );
end UNIT_ALU_REG;

architecture RTL of UNIT_ALU_REG is

    --signals
    signal busA, busB, busW : std_logic_vector(31 downto 0) := (others => '0'); 

begin

    REG : entity work.REGISTERS port map(CLK, WE, Reset, busW, Rw, Ra, Rb, A => busA, B => busB);
    ALU : entity work.ALU port map(OP, A => busA, B => busB, S=> busW, N =>N, C=>C, V => V, Zero => Zero);

end architecture;