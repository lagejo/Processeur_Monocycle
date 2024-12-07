library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity MULTI2 is 
    generic(
        N : integer range 0 to 31
    );
    port(
        A, B : in std_logic_vector(N downto 0);
        S : out std_logic_vector(N downto 0);
        COM : in std_logic
    );
end entity;

architecture RTL of MULTI2 is

begin

    multi : process(A, B, COM) --combinatorial process
    begin
        if COM = '1' then
            S <= B;
        elsif COM = '0' then
            S <= A;
        end if;
    --other cases where COM is not defined are thus excluded
    end process;

end architecture;