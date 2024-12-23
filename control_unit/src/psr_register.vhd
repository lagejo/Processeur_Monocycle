library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity psr_register is
Port(
    CLK, Reset, WE : in std_logic;
    N,Zero,C,V : in std_logic;
    DATAOUT : out std_logic_vector(31 downto 0)
);
end psr_register;

architecture RTL of psr_register is 

--signals
    signal reg : std_logic_vector(31 downto 0) := (others => '0');

begin

    registre : process(CLK, Reset)
    begin
        if Reset = '1' then    

            reg <= (others => '0'); 
            
        elsif rising_edge(CLK) then
            if WE = '1' then
                reg(31) <= N;
                reg(30) <= Zero;
                reg(29) <= C;
                reg(28) <= V;
            end if;
        end if;
    end process;
    DATAOUT <= reg;

end architecture;