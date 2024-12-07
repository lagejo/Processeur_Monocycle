library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity EXT_SIGN is
    generic( 
        N : integer range 0 to 31
        );
    port(
        E : in std_logic_vector(N downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of EXT_SIGN is
begin

    S <= std_logic_vector(resize(signed(E), 32));

end architecture;