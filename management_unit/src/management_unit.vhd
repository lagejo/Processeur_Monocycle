library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity management_unit is
    Port(
        Reset, CLK : in std_logic;
        nPCSel : in std_logic;
        sortie : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of management_unit is

    --signals
    signal busAddr, busPC, busext : std_logic_vector(31 downto 0) := (others => '0'); 
    signal instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal offset : std_logic_vector(23 downto 0) := (others => '0');

begin
    
    offset <= instruction(23 downto 0);
    registre : entity work.PC_register port map(CLK => CLK, Reset => Reset,in_nPc => busPC, out_Adrr => busAddr);
    extender : entity work.pc_extender port map(offset, busext); 
    multi : entity work.mux_pc port map(pc => busAddr, ext => busext, S => busPC, nPCSel => nPCSel);
    memory : entity work.instruction_memory port map(PC => busAddr, instruction => instruction);
    sortie <= instruction;

end architecture;