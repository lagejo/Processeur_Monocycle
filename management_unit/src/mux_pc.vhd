library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity mux_pc is 

    port(
        pc, ext : in std_logic_vector(31 downto 0);
        S : out std_logic_vector(31 downto 0);
        nPCSel : in std_logic
    );
end entity;

architecture RTL of mux_pc is

begin

    mux : process(pc,ext,nPCSel) --combinatorial process
    begin
        if nPCSel = '0' then

            S <= std_logic_vector(signed(pc) + 1);      --addition pc + 1

        else 

            S <= std_logic_vector(signed(pc) + signed(ext) + 1); --addition PC + 1 + SignExt(offset)

        end if;
    --other cases where nPCSel is not defined are thus excluded
    end process;

end architecture;