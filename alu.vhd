library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
    port (
        a           : in std_logic_vector(31 downto 0); 
        b           : in std_logic_vector(31 downto 0);    
        result      : out std_logic_vector(31 downto 0); 
        shamt       : in std_logic_vector(5 downto 0);
        aluCtrlVal  : in std_logic_vector(5 downto 0);
        zero        : out std_logic; 
        neg         : out std_logic
    ); 
end alu; 

architecture Behavioral of ALU is
    signal mult_temp : std_logic_vector(63 downto 0);
    signal div : std_logic_vector(31 downto 0);
    signal mod : std_logic_vector(31 downto 0);
    signal rd, rs : std_logic_vector(4 downto 0);
begin
    process (a, b, shamt, ALU_ctrl_val)
    begin
        case ALU_ctrl_val is
            when 0 => -- ADD
                result <= std_logic_vector(signed(a) + signed(b));
            when 0 => -- ADDU
                result <= std_logic_vector(unsigned(a) + unsigned(b));
            when 1 => -- SUB
                result <= std_logic_vector(signed(a) - signed(b));
            when 2 => -- SUBU
                result <= std_logic_vector(unsigned(a) - unsigned(b));
            when 3 => -- AND
                result <= a and b;
            when 4 => -- OR
                result <= a or b;
            when 5 => -- XOR
                result <= a xor b;
            when 6 => -- SLL
                result <= a sll shamt;
            when 7 => -- SRL
                result <= a srl shamt;
            when 8 => -- SRA
                result <= a sra shamt;
            when 9 => -- SLT
                result <= '1' when signed(a) < signed(b) else '0';
            when 10 => -- NOR
                result <= not (a or b);
            when 11 =>
                result <= std_logic_vector(signed(b) sll (unsigned(a) and x"00000001F")); 
            when 12 =>
                result <= std_logic_vector(signed(b) srl (unsigned(a) and x"00000001F")); 
            when 13 =>
                result <= std_logic_vector(signed(b) sra (signed(a) and x"00000001F")); 
            when 14 =>
                mult_temp <= std_logic_vector(signed(a) * signed(b));
                result <= mult_temp(63 downto 0);
            when 15 =>
                mult_temp <= std_logic_vector(unsigned(a) * unsigned(b));
                result <= mult_temp(63 downto 0);
            when others =>
                result <= (others => '0');
        end case;

        zero <= '1' when result = (others => '0') else '0';
        neg <= result(31);
    end process;

end Behavioral;