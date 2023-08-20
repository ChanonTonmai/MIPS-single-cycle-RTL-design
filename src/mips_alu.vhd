library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_alu is 
    port (
        a           : in std_logic_vector(31 downto 0); 
        b           : in std_logic_vector(31 downto 0);    
        result      : out std_logic_vector(31 downto 0); 
        shamt       : in std_logic_vector(4 downto 0);
        aluCtrlVal  : in std_logic_vector(5 downto 0);
        zero        : out std_logic; 
        neg         : out std_logic
    ); 
end mips_alu; 

architecture Behavioral of mips_alu is
    signal mult_temp : std_logic_vector(63 downto 0);
    signal div : std_logic_vector(31 downto 0);
    signal mod_d : std_logic_vector(31 downto 0);
    signal rd, rs : std_logic_vector(4 downto 0);
begin
    process (a, b, shamt, aluCtrlVal)
    begin
        case to_integer(unsigned(aluCtrlVal)) is
            when 0 => -- ADD
                result <= std_logic_vector(signed(a) + signed(b));
            when 1 => -- ADDU
                result <= std_logic_vector(unsigned(a) + unsigned(b));
            when 2 => -- SUB
                result <= std_logic_vector(signed(a) - signed(b));
            when 3 => -- SUBU
                result <= std_logic_vector(unsigned(a) - unsigned(b));
            when 4 => -- AND
                result <= a and b;
            when 5 => -- OR
                result <= a or b;
            when 6 => -- XOR
                result <= a xor b;
            when 7 => -- SLL
                result <= std_logic_vector(a sll to_integer(unsigned(shamt)));
            when 8 => -- SRL
                result <= std_logic_vector(a srl to_integer(unsigned(shamt)));
            when 9 => -- SRA
                result <= std_logic_vector(shift_right(signed(a), to_integer(unsigned(shamt))));
            when 10 => -- SLT
                result <= x"00000001" ; --when signed(a) < signed(b) else x"00000000"; 
            when 11 => -- NOR
                result <= not (a or b);
            when 12 =>
                result <= std_logic_vector(signed(b) sll to_integer(unsigned(a) and x"00000001F")); 
            when 13 =>
                result <= std_logic_vector(signed(b) srl to_integer(unsigned(a) and x"00000001F")); 
            when 14 =>
                result <= std_logic_vector(signed(b) sra to_integer(signed(a) and x"00000001F")); 
            when 15 =>
                mult_temp <= std_logic_vector(signed(a) * signed(b));
                result <= mult_temp(31 downto 0); -- temp
            when 16 =>
                mult_temp <= std_logic_vector(unsigned(a) * unsigned(b));
                result <= mult_temp(31 downto 0); -- temp
            when others =>
                result <= (others => '0');
        end case;


    end process;
    zero <= '1' when result = x"00000000" else '0';
    neg <= result(31);

end Behavioral;