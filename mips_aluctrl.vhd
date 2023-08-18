library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Define your entity here
entity mips_aluctrl is
  port (
    inst            : in STD_LOGIC_VECTOR(31 downto 0);
    ALUop           : in STD_LOGIC_VECTOR(2 downto 0);
    aluCtrlVal      : out STD_LOGIC_VECTOR(5 downto 0);
    JalCtrl;        : out STD_LOGIC
  );
end mips_aluctrl;

architecture beh of mips_aluctrl is 

signal tempAluLine : std_logic_vector(5 downto 0);
signal opcode_operation : STD_LOGIC_VECTOR(5 downto 0);

begin

    opcode_operation <= inst(31 downto 26);

process(ALUop, inst)
begin

    if ALUop = "10" then
        
        
        case to_integer(unsigned(opcode_operation)) is
            when OP0_ADD    => tempAluLine <= ADD;
            when OP0_ADDU   => 
            when OP0_SUB    => tempAluLine <= SUB;
            when OP0_SUBU
            when OP0_AND   => tempAluLine <= AND;
            when OP0_NOR   => tempAluLine <= NOR;
            when OP0_OR    => tempAluLine <= OR;
            when OP0_SLL   => tempAluLine <= SLL;
            when OP0_SLLV  => tempAluLine <= SLLV;
            when OP0_SLT  => tempAluLine <= SLT;
            when OP0_SLTU   => 
            when OP0_SRA   => tempAluLine <= SRA;
            when OP0_SRAV  => tempAluLine <= SRAV;
            when OP0_SRL   => tempAluLine <= SRL;
            when OP0_SRLV  => tempAluLine <= SRLV;
            when OP0_XOR   => tempAluLine <= XOR;
            when OP0_SYSCALL    => tempAluLine <= ADD; RUN_BIT <= '0';
            when OP0_JALR => tempAluLine <= ADD; JalrCtrl <= '1';
            when OP0_MULT  => tempAluLine <= MULT;
            when OP0_MULTU => tempAluLine <= MULTU;
            when OP0_DIV   => tempAluLine <= MULT;
            when OP0_DIVU  => tempAluLine <= MULTU;
            when OP0_MFHI  => tempAluLine <= MFHI;
            when OP0_MFLO  => tempAluLine <= MFLO;
            when OP0_MTHI  => tempAluLine <= MTHI;
            when OP0_MTLO  => tempAluLine <= MTLO;
            when others => tempAluLine <= ADD; -- Default case
        end case;
    elsif ALUop = "01" then
        tempAluLine <= SUB;
    else
        case to_integer(unsigned(opcode_operation)) is
            when OPCODE_LUI => tempAluLine <= SHIFT_UPPER;
            when OPCODE_LW => 
            when OPCODE_SW
            when OPCODE_ADDI
            when OPCODE_ORI =>
            when OPCODE_XORI =>
                tempAluLine <= ADD;
            when OPCODE_SLTI =>
                tempAluLine <= SLT;
            when OPCODE_SLTIU 
            when others =>
                -- printf("error something\n");
                tempAluLine <= ADD; -- Default case
        end case;
    end if;
    
    ALUctrlLine <= tempAluLine;
    -- printf("alu ctrl line : %d\n", ALUctrlLine);
end process;

end beh; 