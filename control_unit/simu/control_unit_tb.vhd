library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity control_unit_tb is 
end control_unit_tb;

Architecture Bench of control_unit_tb is
    --signals
    signal CLK : std_logic;
    signal Reset : std_logic := '0';
    signal nPCSel, RegWr, RegSel, ALUSrc, RegAff, PSREn, WrSrc, MemWr : std_logic := '0';
    signal ALUCtr : std_logic_vector(2 downto 0) := (others => '0');
    signal instruction, RegFlags, DATAIN, DATAOUT, busDecod_PSR : std_logic_vector(31 downto 0) := (others => '0');
    signal busPSR : std_logic;
begin
    
    decoder : entity work.decoder port map(nPCSel, RegWr, RegSel, ALUSrc, RegAff, PSREn, WrSrc, MemWr, ALUCtr, instruction, busDecod_PSR);
    regPSR : entity work.psr_register port map(CLK, Reset, busPSR, DATAIN, DATAOUT);
    busPSR <= PSREn;
    busDecod_PSR <= DATAOUT;

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

    process

    begin
        report "Starting control_unit testbench";
            --the signal instr_courante was added directly to the tb
            --to verify more easily
            instruction(25 downto 21) <= "00100"; --ADDr
            wait for 5 ns;
            instruction(25 downto 21) <= "10100"; --ADDi
            wait for 5 ns;
            instruction(31 downto 25) <= "1011101"; --BLT
            wait for 5 ns;
            instruction(28 downto 25) <= "0101"; --BAL
            wait for 5 ns;
            instruction(24 downto 21) <= "1010"; --CMP
            wait for 5 ns;
            --LDR
            instruction(27 downto 26) <= "01";
            instruction(20) <= '1';
            wait for 5 ns;
            --STR
            instruction(20) <= '0';
            wait for 5 ns;
            --MOV
            instruction(24 downto 21) <= "1101";
            wait for 5 ns;
            instruction <= X"00000000";


            DATAIN(31) <= '1';
            --test condition of BLT
            instruction(31 downto 25) <= "1011101"; --BLT
            wait for 5 ns; --we must be on a rising edge of the clock for it to write
            wait for 1 ns;
            assert nPCSel = '1';
    end process;
end Bench;