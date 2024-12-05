library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity processeur is
    Port(
        Reset, CLK : in std_logic;
        affichage : out std_logic_vector(31 downto 0);
        HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(0 to 6)

    );
end processeur;

architecture RTL of processeur is

    --signals
    --bus du décodeur
    signal nPCSel, RegWr, RegSel, ALUSrc, RegAff, MemWr, PSREn, WrSrc : std_logic := '0';

    signal ALUCtr : std_logic_vector(2 downto 0) := (others => '0');

    signal instructions : std_logic_vector(31 downto 0) := (others => '0');

    signal Imm8 : std_logic_vector(7 downto 0) := (others => '0');

    signal busPSR_Decodeur : std_logic_vector(31 downto 0) := (others => '0');

    signal N, Zero, C, V : std_logic := '0';

    signal Rd, Rm, Rn, Rb : std_logic_vector(3 downto 0) := (others => '0');

    signal sortie_affiche : std_logic_vector(31 downto 0);

    signal offset : std_logic_vector(23 downto 0);

begin

    offset <= instructions(23 downto 0);
    unite_de_gestion : entity work.unite_gestion port map(Reset, CLK, nPCSel, instructions);

    --unite controle
    decodeur : entity work.decodeur port map(nPCSel, RegWr, RegSel, ALUSrc, RegAff, PSREn, WrSrc, MemWr, ALUCtr, instructions, busPSR_Decodeur);
    RegPSR : entity work.registrePSR port map(CLK, Reset, PSREn, N, Zero, C, V, busPSR_Decodeur);

    --unite traitement

    MUX : entity work.MULTI2 generic map (3) port map(Rm, Rd, Rb, RegSel);
    unite_de_traitement : entity work.unit_traitement port map(CLK, RegWr, Reset, MemWr,ALUSrc,WrSrc, ALUCtr, N, Zero, C, V, Rd, Rn, Rb, sortie_affiche, Imm8);

    --affichage
    affichage <= sortie_affiche;
	SevenSegDecoder1 : entity work.seven_seg port map(sortie_affiche(3 downto 0), RegAff, HEX0);
	SevenSegDecoder2 : entity work.seven_seg port map(sortie_affiche(7 downto 4), RegAff, HEX1);
	SevenSegDecoder3 : entity work.seven_seg port map(sortie_affiche(11 downto 8), RegAff, HEX2);
	SevenSegDecoder4 : entity work.seven_seg port map(sortie_affiche(15 downto 12), RegAff, HEX3);

    Imm8 <= instructions(7 downto 0);
    Rd <= instructions(15 downto 12);--sur bits 12 à 15?
    Rm <= instructions(3 downto 0); --sur bits 0 à 3?
    Rn <= instructions(19 downto 16); --sur bits 16 à 19?



end architecture;