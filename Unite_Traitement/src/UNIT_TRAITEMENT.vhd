library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity UNIT_TRAITEMENT is
    Port(
        CLK, WE, Reset, WrEn, COM1, COM2 : in std_logic;
        OP : in std_logic_vector(2 downto 0);
        N, Zero, C, V : out std_logic;
        Rw, Ra, Rb : in std_logic_vector(3 downto 0);
        sortie_affiche :out std_logic_vector(31 downto 0);
        Imm : in std_logic_vector(7 downto 0)

    );
end UNIT_TRAITEMENT;

architecture RTL of UNIT_TRAITEMENT is

    --signals
    signal busW, busA, busB, extImm, sMux1, sMux2, ALUout, sMem : std_logic_vector(31 downto 0) := (others => '0');


begin

    sortie_affiche <= busB;

    REG : entity work.REGISTERS port map(CLK, WE, Reset, busW, Rw, Ra, Rb, A => busA, B => busB);

    EXTENDER : entity work.EXT_SIGN generic map (7) port map(Imm, extImm);

    MUX : entity work.MULTI2 generic map (31) port map(busB, extImm, sMux1, COM1);

    ALU : entity work.ALU port map(OP, busA, sMux1, ALUout, N, Zero, C, V);

    memory : entity work.MEMOIRE port map(CLK, WrEn, Reset, busB, ALUout(5 downto 0), sMem);

    MUX2 : entity work.MULTI2 generic map(31) port map(ALUout, sMem, busW, COM2);
    


end architecture;