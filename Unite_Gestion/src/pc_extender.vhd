library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity pc_extender is
    port(
        offset : in std_logic_vector(23 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of pc_extender is
begin

    S <= std_logic_vector(resize(signed(offset), 32));

end architecture;