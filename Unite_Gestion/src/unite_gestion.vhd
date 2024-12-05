library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity unite_gestion is
    Port(
        Reset, CLK : in std_logic;
        -- offset : in std_logic_vector(23 downto 0);
        nPCSel : in std_logic;
        sortie : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of unite_gestion is

    --signals
    signal busAddr, busPC, busext : std_logic_vector(31 downto 0) := (others => '0'); 
    signal instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal offset : std_logic_vector(23 downto 0) := (others => '0');

begin
    offset <= instruction(23 downto 0);
    registre : entity work.registre_pc port map(CLK => CLK, Reset => Reset,in_nPc => busPC, out_Adrr => busAddr);
    extender : entity work.pc_extender port map(offset, busext); --bus_instructions was offset
    multi : entity work.mux_pc port map(pc => busAddr, ext => busext, S => busPC, nPCSel => nPCSel);
    memoire : entity work.instruction_memory port map(PC => busAddr, instruction => instruction);
    sortie <= instruction;

end architecture;