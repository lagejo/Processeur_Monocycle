library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity decoder is
Port(
    nPCSel, RegWr, RegSel, ALUSrc, RegAff, PSREn, WrSrc, MemWr : out std_logic;
    ALUCtr : out std_logic_vector(2 downto 0);
    instruction, RegFlags : in std_logic_vector(31 downto 0)    
);
end decoder;

architecture RTL of decoder is 

    type enum_instructions is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT);
--signals
    signal instr_courante : enum_instructions;

begin

    sortie_instr : process(instruction)
        begin

            -- ADDi and ADDr
            if instruction(24 downto 21) = "0100" then
                if instruction(25) = '0' then
                    instr_courante <= ADDr;
                else
                    instr_courante <= ADDi;
                end if;
            end if;

            -- BAL and BLT
            if instruction(27 downto 25) = "101" then
                if instruction(31 downto 28) = "1011" then
                    instr_courante <= BLT;
                else
                    instr_courante <= BAL;
                end if;
            end if;

            -- CMP
            if instruction(24 downto 21) = "1010" then
                instr_courante <= CMP;
            end if;

            -- LDR and STR
            if instruction(27 downto 26) = "01" then
                if instruction(20) = '1' then
                    instr_courante <= LDR;
                else
                    instr_courante <= STR;
                end if;
            end if;

            -- MOV
            if instruction(24 downto 21) = "1101" then
                instr_courante <= MOV;
            end if;

        end process;

    commandes : process(instruction, instr_courante, RegFlags) 
    begin
        case instr_courante is 
            when ADDi =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtr <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when ADDr =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '0';
                ALUCtr <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when BAL =>
                nPCSel <= '1';
                RegWr <= '0';
                ALUSrc <= '0';
                ALUCtr <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when BLT =>
                --branch condition, if negative (N=1, on bit 31 of RegFlags) then sign extension
                if RegFlags(31) = '1' then 
                    nPCSel <= '1';
                else
                    nPCSel <= '0';
                end if;
                PSREn <= '0';
                RegWr <= '0';
                ALUSrc <= '0';
                ALUCtr <= "000";
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when CMP =>
                nPCSel <= '0';
                RegWr <= '0';
                ALUSrc <= '1';
                ALUCtr <= "010";
                PSREn <= '1';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when LDR =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '0';
                ALUCtr <= "011";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when MOV =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtr <= "001";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when STR =>
                nPCSel <= '0';
                RegWr <= '0';
                ALUSrc <= '0';
                ALUCtr <= "011";
                PSREn <= '0';
                MemWr <= '1';
                WrSrc <= '0';
                RegSel <= '1';
                RegAff <= '0';
        end case;


        
    end process;

end architecture;