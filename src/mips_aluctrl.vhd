library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mips_defines.ALL; 

-- Define your entity here
entity mips_aluctrl is
  port (
    inst            : in STD_LOGIC_VECTOR(31 downto 0);
    ALUop           : in STD_LOGIC_VECTOR(2 downto 0);
    aluCtrlVal      : out STD_LOGIC_VECTOR(5 downto 0);
    JalCtrl        : out STD_LOGIC
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
            when OP0_ADD        => tempAluLine <= FUNC_ADD;
            when OP0_ADDU       => tempAluLine <= FUNC_ADDU;
            when OP0_SUB        => tempAluLine <= FUNC_SUB;
            when OP0_SUBU       => tempAluLine <= FUNC_SUBU;
            when OP0_AND        => tempAluLine <= FUNC_AND;
            when OP0_NOR        => tempAluLine <= FUNC_NOR;
            when OP0_OR         => tempAluLine <= FUNC_OR;
            when OP0_SLL        => tempAluLine <= FUNC_SLL;
            when OP0_SLLV       => tempAluLine <= FUNC_SLLV;
            when OP0_SLT        => tempAluLine <= FUNC_SLT;
            when OP0_SLTU       => tempAluLine <= FUNC_SUB;
            when OP0_SRA        => tempAluLine <= FUNC_SRA;
            when OP0_SRAV       => tempAluLine <= FUNC_SRAV;
            when OP0_SRL        => tempAluLine <= FUNC_SRL;
            when OP0_SRLV       => tempAluLine <= FUNC_SRLV;
            when OP0_XOR        => tempAluLine <= FUNC_XOR;
            when OP0_SYSCALL    => tempAluLine <= FUNC_ADD; RUN_BIT <= '0';
            when OP0_JALR       => tempAluLine <= FUNC_ADD; JalrCtrl <= '1';
            when OP0_MULT       => tempAluLine <= FUNC_MULT;
            when OP0_MULTU      => tempAluLine <= FUNC_MULTU;
            when OP0_DIV        => tempAluLine <= FUNC_DIV;
            when OP0_DIVU       => tempAluLine <= FUNC_DIVU;
            when OP0_MFHI       => tempAluLine <= FUNC_MFHI;
            when OP0_MFLO       => tempAluLine <= FUNC_MFLO;
            when OP0_MTHI       => tempAluLine <= FUNC_MTHI;
            when OP0_MTLO       => tempAluLine <= FUNC_MTLO;
            when others         => tempAluLine <= FUNC_ADD; -- Default case
        end case;
    elsif ALUop = "01" then
        tempAluLine <= FUNC_SUB;
    else
        case to_integer(unsigned(opcode_operation)) is
            when OPCODE_LUI     => tempAluLine <= SHIFT_UPPER;
            when OPCODE_LW      => tempAluLine <= FUNC_ADD;
            when OPCODE_SW      => tempAluLine <= FUNC_ADD;
            when OPCODE_ADDI    => tempAluLine <= FUNC_ADD;
            when OPCODE_ANDI    => tempAluLine <= FUNC_AND;
            when OPCODE_ORI     => tempAluLine <= FUNC_OR;
            when OPCODE_XORI    => tempAluLine <= FUNC_XOR;
            when OPCODE_SLTI    => tempAluLine <= FUNC_SLT;
            when OPCODE_SLTIU   => tempAluLine <= FUNC_SLT;
            when others         => tempAluLine <= FUNC_ADD; -- Default case
        end case;
    end if;
    
    ALUctrlLine <= tempAluLine;
    -- printf("alu ctrl line : %d\n", ALUctrlLine);
end process;

end beh; 