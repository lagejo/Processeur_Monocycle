library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;


entity REGISTERS is
    Port(
        CLK, WE, Reset : in std_logic;
        W : in std_logic_vector(31 downto 0);
        Rw, Ra,Rb : in std_logic_vector(3 downto 0);
        A, B : out std_logic_vector(31 downto 0)
    );
end REGISTERS;

architecture RTL of REGISTERS is 

    --signals
    -- Declaration Type Tableau Memoire
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);

    -- Fonction d'Initialisation du Banc de Registres
    function init_banc return table is
        variable result : table;
    begin
        for i in 15 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        -- result(15):=X"00000030"; --dernière valeur du tableau result initialisée à 48
        return result;
    end init_banc;

    -- Déclaration et Initialisation du Banc de Registres 16x32 bits
    signal Banc: table:=init_banc;

    --fonction pour vérifier que le signal qui servira d'index du tableau est défini
    function is_defined (s : std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        case s is --retourne 0 si s n'est pas utilisable comme index
            when "UUUU" | "ZZZZ" | "XXXX" | "WWWW" | "----" => return "0000";
            when others => NULL;
        end case;
        if s < X"0" then    
            return X"0";
        end if;
        return "1111"; --1 sinon, le signal est défini
    end is_defined;

begin

--lecture, combinatoire et simultanée
--mettre process si ça marche pas
    --si le signal Ra ou Rb n'est pas défini correctement alors A et B prennent la valeur de Banc 0
    A <= Banc(to_integer(unsigned(Ra ))); --is_defined effectue un masque --and is_defined(Ra)
    B <= Banc(to_integer(unsigned(Rb and is_defined(Rb))));
     
--ecriture, synchrone sur front montant de CLK
writing : process(CLK,Reset)
begin
    if Reset = '1' then
        banc <= init_banc;
    elsif rising_edge(CLK) and WE = '1' and is_defined(Rw) = "1111" then
            --si le signal Rw n'est pas défini correctement alors il n'y a pas d'écriture
                Banc(to_integer(unsigned(Rw))) <= W;
    end if;
end process;

end architecture;