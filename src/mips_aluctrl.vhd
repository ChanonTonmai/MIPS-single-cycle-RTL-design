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
    JalrCtrl        : out STD_LOGIC
  );
end mips_aluctrl;

architecture beh of mips_aluctrl is 

signal tempAluLine : std_logic_vector(5 downto 0);
signal opcode_operation : STD_LOGIC_VECTOR(5 downto 0);
signal function_operation : std_logic_vector(5 downto 0); 
begin

    function_operation <= inst(5 downto 0);
    opcode_operation <= inst(31 downto 26); 

process(ALUop, inst, opcode_operation, function_operation)
begin
    if ALUop = "010" then
        case to_integer(unsigned(function_operation)) is
            when to_integer(unsigned(OP0_ADD     ))  => tempAluLine <= FUNC_ADD;
            when to_integer(unsigned(OP0_ADDU    ))  => tempAluLine <= FUNC_ADDU;
            when to_integer(unsigned(OP0_SUB     ))  => tempAluLine <= FUNC_SUB;
            when to_integer(unsigned(OP0_SUBU    ))  => tempAluLine <= FUNC_SUBU;
            when to_integer(unsigned(OP0_AND     ))  => tempAluLine <= FUNC_AND;
            when to_integer(unsigned(OP0_NOR     ))  => tempAluLine <= FUNC_NOR;
            when to_integer(unsigned(OP0_OR      ))  => tempAluLine <= FUNC_OR;
            when to_integer(unsigned(OP0_SLL     ))  => tempAluLine <= FUNC_SLL;
            when to_integer(unsigned(OP0_SLLV    ))  => tempAluLine <= FUNC_SLLV;
            when to_integer(unsigned(OP0_SLT     ))  => tempAluLine <= FUNC_SLT;
            when to_integer(unsigned(OP0_SLTU    ))  => tempAluLine <= FUNC_SLTU;
            when to_integer(unsigned(OP0_SRA     ))  => tempAluLine <= FUNC_SRA;
            when to_integer(unsigned(OP0_SRAV    ))  => tempAluLine <= FUNC_SRAV;
            when to_integer(unsigned(OP0_SRL     ))  => tempAluLine <= FUNC_SRL;
            when to_integer(unsigned(OP0_SRLV    ))  => tempAluLine <= FUNC_SRLV;
            when to_integer(unsigned(OP0_XOR     ))  => tempAluLine <= FUNC_XOR;
            when to_integer(unsigned(OP0_SYSCALL ))  => tempAluLine <= FUNC_ADD; 
            when to_integer(unsigned(OP0_JALR    ))  => tempAluLine <= FUNC_ADD; JalrCtrl <= '1';
            when to_integer(unsigned(OP0_MULT    ))  => tempAluLine <= FUNC_MULT;
            when to_integer(unsigned(OP0_MULTU   ))  => tempAluLine <= FUNC_MULTU;
            when to_integer(unsigned(OP0_DIV     ))  => tempAluLine <= FUNC_DIV;
            when to_integer(unsigned(OP0_DIVU    ))  => tempAluLine <= FUNC_DIVU;
            when to_integer(unsigned(OP0_MFHI    ))  => tempAluLine <= FUNC_MFHI;
            when to_integer(unsigned(OP0_MFLO    ))  => tempAluLine <= FUNC_MFLO;
            when to_integer(unsigned(OP0_MTHI    ))  => tempAluLine <= FUNC_MTHI;
            when to_integer(unsigned(OP0_MTLO    ))  => tempAluLine <= FUNC_MTLO;
            when others         => tempAluLine <= FUNC_ADD; -- Default case
        end case;
    elsif ALUop = "001" then
        tempAluLine <= FUNC_SUB;
    else
        case to_integer(unsigned(opcode_operation)) is
            when to_integer(unsigned(OP_LUI   ))  => tempAluLine <= SHIFT_UPPER;
            when to_integer(unsigned(OP_LW    ))  => tempAluLine <= FUNC_ADD;
            when to_integer(unsigned(OP_ADDIU ))  => tempAluLine <= FUNC_ADD;
            when to_integer(unsigned(OP_SW    ))  => tempAluLine <= FUNC_ADD;
            when to_integer(unsigned(OP_ADDI  ))  => tempAluLine <= FUNC_ADD;
            when to_integer(unsigned(OP_ANDI  ))  => tempAluLine <= FUNC_AND;
            when to_integer(unsigned(OP_ORI   ))  => tempAluLine <= FUNC_OR;
            when to_integer(unsigned(OP_XORI  ))  => tempAluLine <= FUNC_XOR;
            when to_integer(unsigned(OP_SLTI  ))  => tempAluLine <= FUNC_SLT;
            when to_integer(unsigned(OP_SLTIU ))  => tempAluLine <= FUNC_SLT;
            when others         => tempAluLine <= FUNC_ADD; -- Default case
        end case;
    end if;
    
  
    -- printf("alu ctrl line : %d\n", ALUctrlLine);
end process;
  aluCtrlVal <= tempAluLine;

end beh; 