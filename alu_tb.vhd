library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_Testbench is
end ALU_Testbench;

architecture test of ALU_Testbench is
    signal a, b, result : std_logic_vector(31 downto 0);
    signal shamt, aluCtrlVal : std_logic_vector(5 downto 0);
    signal zero, neg : std_logic;

    component ALU
        port (
            a           : in std_logic_vector(31 downto 0); 
            b           : in std_logic_vector(31 downto 0);    
            result      : out std_logic_vector(31 downto 0); 
            shamt       : in std_logic_vector(5 downto 0);
            aluCtrlVal  : in std_logic_vector(5 downto 0);
            zero        : out std_logic; 
            neg         : out std_logic
        );
    end component;

begin
    a <= x"0000000A";
    b <= x"00000005";
    shamt <= "000011"; -- 3 in decimal

    -- Test ADD
    uut: ALU port map (a, b, result, shamt, aluCtrlVal, zero, neg);

    process
    begin

        aluCtrlVal <= "000000"; -- ADD
        report "ADD Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "000001"; -- ADDU
        report "ADDU Result: " & to_string(result); wait for 10ns; 

        aluCtrlVal <= "000010"; -- SUB
        report "SUB Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "000011"; -- SUBU
        report "SUBU Result: " & to_string(result); wait for 10ns; 

        aluCtrlVal <= "000100"; -- AND
        report "AND Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "000101"; -- OR
        report "OR Result: " & to_string(result);   wait for 10ns; 

        aluCtrlVal <= "000110"; -- XOR
        report "XOR Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "000111"; -- SLL
        report "SLL Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "001000"; -- SRL
        report "SRL Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "001001"; -- SRA
        report "SRA Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "001010"; -- SLT
        report "SLT Result: " & to_string(result);  wait for 10ns; 

        aluCtrlVal <= "001011"; -- NOR
        report "NOR Result: " & to_string(result);  wait for 10ns; 
 
        aluCtrlVal <= "001100"; -- SLLV
        report "SLLV Result: " & to_string(result); wait for 10ns; 

        aluCtrlVal <= "001101"; -- SRLV
        report "SRLV Result: " & to_string(result); wait for 10ns; 

        aluCtrlVal <= "001110"; -- SRAV
        report "SRAV Result: " & to_string(result); wait for 10ns; 
 
        aluCtrlVal <= "001111"; -- MULT
        report "MULT Result: " & to_string(result); wait for 10ns; 

        aluCtrlVal <= "010000"; -- MULTU
        report "MULTU Result: " & to_string(result); wait for 10ns; 
            wait;
        end process;

end test;
