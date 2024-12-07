library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity memory is
    Port(
        CLK, WrEn, Reset : in std_logic;
        DataIn : in std_logic_vector(31 downto 0);
        Addr : in std_logic_vector(5 downto 0);
        DataOut: out std_logic_vector(31 downto 0)
    );
end memory;

architecture RTL of memory is 

    --signals
    -- Declaration of memory array type
    type table_data is array(63 downto 0) of std_logic_vector(31 downto 0);

    -- Initialization function for the Register Bank
    function init_banc return table_data is
        variable result : table_data;
    begin
        for i in 63 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        -- result(63):=X"00000030"; --last value of the result array initialized to 48
        return result;
    end init_banc;

    -- Declaration and Initialization of the 64x32 bits Register Bank
    signal Banc_data : table_data := init_banc;

    -- Function to check if the signal used as an index for the array is defined
    function is_defined (s : std_logic_vector(5 downto 0)) return std_logic_vector is
    begin
        case s is --returns 0 if s is not usable as an index
            when "UUUUUU" | "ZZZZZZ" | "XXXXXX" | "WWWWWW" | "------" => return "000000";
            when others => NULL;
        end case;
        return "111111"; --1 otherwise, the signal is defined
    end is_defined;

begin

    --reading, combinatorial and simultaneous
    --use process if it doesn't work
    --if the signal Addr is not correctly defined then DataOut takes the value of Banc_data 0
    DataOut <= Banc_data(to_integer(unsigned(Addr and is_defined(Addr))));

    --writing, synchronous on rising edge of CLK
    writing : process(CLK, Reset)
    begin
        if Reset = '1' then
            Banc_data <= init_banc;
        elsif rising_edge(CLK) and WrEn = '1' and is_defined(Addr) = "111111" then
            --if the signal Addr is not correctly defined then there is no writing
            Banc_data(to_integer(unsigned(Addr))) <= DataIn;
        end if;
    end process;

end architecture;