library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity MEMOIRE is
    Port(
        CLK, WrEn, Reset : in std_logic;
        DataIn : in std_logic_vector(31 downto 0);
        Addr : in std_logic_vector(5 downto 0);
        DataOut: out std_logic_vector(31 downto 0)
    );
end MEMOIRE;

architecture RTL of MEMOIRE is 

    --signals
    -- Declaration Type Tableau Memoire
    type table_data is array(63 downto 0) of std_logic_vector(31 downto 0);

    -- Fonction d'Initialisation du Banc de Registres
    function init_banc return table_data is
        variable result : table_data;
    begin
        for i in 63 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        -- result(63):=X"00000030"; --dernière valeur du tableau result initialisée à 48
        return result;
    end init_banc;

    -- Déclaration et Initialisation du Banc de Registres 16x32 bits
    signal Banc_data : table_data:=init_banc;

    --fonction pour vérifier que le signal qui servira d'index du tableau est défini
    function is_defined (s : std_logic_vector(5 downto 0)) return std_logic_vector is
    begin
        case s is --retourne 0 si s n'est pas utilisable comme index
            when "UUUUUU" | "ZZZZZZ" | "XXXXXX" | "WWWWWW" | "------" => return "000000";
            when others => NULL;
        end case;
        return "111111"; --1 sinon, le signal est défini
    end is_defined;

begin

--lecture, combinatoire et simultanée

    --si le signal Addr n'est pas défini correctement alors DataOut prend la valeur de Banc 0
    DataOut <= Banc_data(to_integer(unsigned(Addr and is_defined(Addr)))); --is_defined effectue un masque
     
--ecriture, synchrone sur front montant de CLK
writing : process(CLK,Reset)
begin
    if Reset = '1' then
        banc_data <= init_banc;
    elsif rising_edge(CLK) and WrEn = '1' and is_defined(Addr) = "111111" then
            --si le signal Rw n'est pas défini correctement alors il n'y a pas d'écriture
                Banc_data(to_integer(unsigned(Addr))) <= DataIn;
    end if;
end process;

end architecture;