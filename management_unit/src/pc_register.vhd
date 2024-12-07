library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity PC_register is
Port(
    CLK, Reset : in std_logic;
    in_nPc : in std_logic_vector(31 downto 0);
    out_Adrr : out std_logic_vector(31 downto 0)
);
end PC_register;

architecture RTL of PC_register is 

--signals
    signal reg : std_logic_vector(31 downto 0) := (others => '0');

begin

    registre : process(CLK, Reset)
    begin
        if Reset = '1' then    

            reg <= (others => '0'); 
            
        elsif rising_edge(CLK) then

            reg <= in_nPc;

        end if;
    end process;
    out_Adrr <= reg;

end architecture;