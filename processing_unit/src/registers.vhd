library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity REGISTERS is
    Port(
        CLK, WE, Reset : in std_logic;
        W : in std_logic_vector(31 downto 0);
        Rw, Ra, Rb : in std_logic_vector(3 downto 0);
        A, B : out std_logic_vector(31 downto 0)
    );
end REGISTERS;

architecture RTL of REGISTERS is 

    --signals
    -- Declaration of memory array type
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);

    -- Initialization function for the Register Bank
    function init_banc return table is
        variable result : table;
    begin
        for i in 15 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        -- result(15):=X"00000030"; --last value of the result array initialized to 48
        return result;
    end init_banc;

    -- Declaration and Initialization of the 16x32 bits Register Bank
    signal Banc: table := init_banc;

    -- Function to check if the signal used as an index for the array is defined
    function is_defined (s : std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        case s is --returns 0 if s is not usable as an index
            when "UUUU" | "ZZZZ" | "XXXX" | "WWWW" | "----" => return "0000";
            when others => NULL;
        end case;
        if s < X"0" then    
            return X"0";
        end if;
        return "1111"; --1 otherwise, the signal is defined
    end is_defined;

begin

--reading, combinatorial and simultaneous
--use process if it doesn't work
    --if the signal Ra or Rb is not correctly defined then A and B take the value of Banc 0
    A <= Banc(to_integer(unsigned(Ra))); --is_defined performs a mask --and is_defined(Ra)
    B <= Banc(to_integer(unsigned(Rb and is_defined(Rb))));

--writing, synchronous on rising edge of CLK
writing : process(CLK, Reset)
begin
    if Reset = '1' then
        Banc <= init_banc;
    elsif rising_edge(CLK) and WE = '1' and is_defined(Rw) = "1111" then
        --if the signal Rw is not correctly defined then there is no writing
        Banc(to_integer(unsigned(Rw))) <= W;
    end if;
end process;

end architecture;