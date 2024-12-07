-- SevenSeg.vhd

-- Notes :
--   A=Seg(1)
--    -----
-- F |     | B=Seg(2)
--   |  G  |
--    -----
-- E |     | C=Seg(3)
--   |     |
--    -----
--   D=Seg(4)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity seven_seg is
    port (
        Data : in std_logic_vector(3 downto 0);
        Pol : in std_logic;

        Segout : out std_logic_vector(1 to 7)
    );
end entity seven_seg;

Architecture COMB of seven_seg is
-- Signals
signal sSegout : std_logic_vector(1 to 7);

-- Content
begin
    -- Asign signals to output
    Segout(1) <= sSegout(1) xor Pol;
	 Segout(2) <= sSegout(2) xor Pol;
	 Segout(3) <= sSegout(3) xor Pol;
	 Segout(4) <= sSegout(4) xor Pol;
	 Segout(5) <= sSegout(5) xor Pol;
	 Segout(6) <= sSegout(6) xor Pol;
	 Segout(7) <= sSegout(7) xor Pol;	 

    with Data select
        sSegout <= "1111110" when x"0",
                    "0110000" when x"1",
                    "1101101" when x"2",
                    "1111001" when x"3",
                    "0110011" when x"4",

                    "1011011" when x"5",
                    "1011111" when x"6",
                    "1110000" when x"7",
                    "1111111" when x"8",

                    "1111011" when x"9",

                    "1110111" when x"A",
                    "0011111" when x"B",
                    "1001110" when x"C",
                    "0111101" when x"D",
                    "1001111" when x"E",
                    "0011111" when x"F",


                
                    "-------" when others;

end architecture COMB;

