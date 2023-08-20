library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mips_defines.ALL; 

entity mips_ctrl is
    Port (
        inst: in STD_LOGIC_VECTOR(31 downto 0);
        RegDst: out STD_LOGIC;
        Jump: out STD_LOGIC;
        Branch: out STD_LOGIC;
        MemRead: out STD_LOGIC;
        MemtoReg: out STD_LOGIC;
        ALUop: out STD_LOGIC_VECTOR(2 downto 0);
        MemWrite: out STD_LOGIC;
        ALUSrc: out STD_LOGIC;
        RegWrite: out STD_LOGIC;
        BranchType: out STD_LOGIC_VECTOR(2 downto 0);
        AndLink : out STD_LOGIC; 
        ALR: out STD_LOGIC;
        SpecialMemOp: out STD_LOGIC_VECTOR(2 downto 0)
    );
end mips_ctrl;

architecture beh of mips_ctrl is 
  -- Decode signals
  signal dcd_se_imm, dcd_se_offset, dcd_e_imm, dcd_se_mem_offset : STD_LOGIC_VECTOR(31 downto 0);
  signal dcd_op, dcd_funct2 : STD_LOGIC_VECTOR(5 downto 0);
  signal dcd_rs, dcd_funct1, dcd_rt, dcd_rd, dcd_shamt : STD_LOGIC_VECTOR(4 downto 0);
  signal dcd_offset, dcd_imm : STD_LOGIC_VECTOR(15 downto 0);
  signal dcd_target : STD_LOGIC_VECTOR(25 downto 0);
  signal dcd_code : STD_LOGIC_VECTOR(19 downto 0);
  signal dcd_bczft : STD_LOGIC;

begin 
    dcd_op <= inst(31 downto 26);
    dcd_rs <= inst(25 downto 21);
    dcd_rt <= inst(20 downto 16);
    dcd_rd <= inst(15 downto 11);
    dcd_shamt <= inst(10 downto 6);
    dcd_bczft <= inst(16);
    dcd_funct1 <= inst(4 downto 0);
    dcd_funct2 <= inst(5 downto 0);
    dcd_offset <= inst(15 downto 0);
    dcd_se_offset <= (others => dcd_offset(15));
    dcd_se_mem_offset(31 downto 16) <= (others => dcd_offset(15)) ;
    dcd_se_mem_offset(15 downto 0) <= dcd_offset;
    dcd_imm <= inst(15 downto 0);
    dcd_e_imm(31 downto 16) <= (others => '0') ; 
    dcd_e_imm(15 downto 0) <= dcd_imm;
    dcd_se_imm(31 downto 16) <= (others => dcd_imm(15)); 
    dcd_se_imm(15 downto 0) <= dcd_imm;
    dcd_target <= inst(25 downto 0);
    dcd_code <= inst(25 downto 6);
    
    process(dcd_op, dcd_rs, dcd_rt, dcd_rd, dcd_funct2) begin 
    if dcd_op = OP_OTHER0 then
        RegDst      <= '1'; 
        ALUSrc      <= '0'; 
        MemtoReg    <= '0';
        RegWrite    <= '1'; 
        MemRead     <= '0'; 
        MemWrite    <= '0'; 
        Jump        <= '0'; 
        AndLink     <= '0'; 
        ALR         <= '0'; 
        Branch      <= '0'; 
        BranchType  <= (others=>'0');
        ALUop <= std_logic_vector(to_unsigned(2,3));    
        if dcd_funct2 = OP0_JALR  then
            AndLink    <= '1';
            ALR        <= '1'; 
            Jump       <= '1'; 
        end if; 
        if (dcd_funct2 = OP0_JR) then
            AndLink    <= '0';
            ALR        <= '0'; 
            Jump       <= '1'; 
        end if; 
    elsif dcd_op = OP_OTHER1 then 
        if dcd_rt = OP1_BGEZ then
            RegDst <= 'X';  
            ALUSrc <= '0'; 
            MemtoReg <= 'X';
            RegWrite <= '0'; 
            MemRead <= '0'; 
            MemWrite <= '1'; 
            Jump <= '0'; 
            AndLink <= '0';
            Branch <= '1'; 
            BranchType <= std_logic_vector(to_unsigned(2,3)); -- 2 = BGEZ
            ALUop <= std_logic_vector(to_unsigned(1,3));
        elsif dcd_rt = OP1_BGEZAL then
            RegDst <= 'X';  
            ALUSrc <= '0'; 
            MemtoReg <= 'X';
            RegWrite <= '1'; 
            MemRead <= '0'; 
            MemWrite <= '1'; 
            Jump <= '0'; 
            AndLink <= '1';
            Branch <= '1'; 
            BranchType <= std_logic_vector(to_unsigned(2,3)); -- 2 = BGEZ
            ALUop <= std_logic_vector(to_unsigned(1,3));
        elsif dcd_rt = OP1_BLTZ then
            RegDst <= 'X';  
            ALUSrc <= '0'; 
            MemtoReg <= 'X';
            RegWrite <= '0'; 
            MemRead <= '0'; 
            MemWrite <= '1'; 
            Jump <= '0'; 
            AndLink <= '0';
            Branch <= '1'; 
            BranchType <= std_logic_vector(to_unsigned(3,3)); -- 3 = BLTZ
            ALUop <= std_logic_vector(to_unsigned(1,3));
        elsif dcd_rt = OP1_BLTZAL then
            RegDst <= 'X';  
            ALUSrc <= '0'; 
            MemtoReg <= 'X';
            RegWrite <= '1'; 
            MemRead <= '0'; 
            MemWrite <= '1'; 
            Jump <= '0'; 
            AndLink <= '1';
            Branch <= '1'; 
            BranchType <= std_logic_vector(to_unsigned(3,3)); -- 3 = BLTZ
            ALUop <= std_logic_vector(to_unsigned(1,3));
        end if;
    elsif dcd_op = OP_LUI then 
        RegDst <= '0';  
        ALUSrc <= '1'; 
        MemtoReg <= '0';
        RegWrite <= '1'; 
        MemRead <= '0'; 
        MemWrite <= '0'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(0,3)); 
    elsif dcd_op = OP_LW then 
        RegDst <= '0';  
        ALUSrc <= '1'; 
        MemtoReg <= '1';
        RegWrite <= '1'; 
        MemRead <= '1'; 
        MemWrite <= '0'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(0,3)); 
    elsif dcd_op = OP_BEQ then 
        RegDst <= 'X';  
        ALUSrc <= '0'; 
        MemtoReg <= 'X';
        RegWrite <= '0'; 
        MemRead <= '0'; 
        MemWrite <= '1'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '1'; 
        BranchType <= std_logic_vector(to_unsigned(1,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3));
    elsif dcd_op = OP_BNE then 
        RegDst <= 'X';  
        ALUSrc <= '0'; 
        MemtoReg <= 'X';
        RegWrite <= '0'; 
        MemRead <= '0'; 
        MemWrite <= '1'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '1'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3)); 
    elsif dcd_op = OP_SW then
        RegDst <= 'X';  
        ALUSrc <= '1'; 
        MemtoReg <= 'X';
        RegWrite <= '0'; 
        MemRead <= '0'; 
        MemWrite <= '1'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3));   
    elsif ((dcd_op = OP_ADDI) or (dcd_op = OP_ANDI) or (dcd_op = OP_ORI) or (dcd_op = OP_ADDIU) or
            (dcd_op = OP_XORI) or (dcd_op = OP_SLTI) or (dcd_op = OP_SLTIU)) then 
        RegDst <= '0';  
        ALUSrc <= '1'; 
        MemtoReg <= '0';
        RegWrite <= '1'; 
        MemRead <= '0'; 
        MemWrite <= '0'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(0,3)); 
    elsif (dcd_op = OP_J) then 
        RegDst <= '0';  
        ALUSrc <= '0'; 
        MemtoReg <= '0';
        RegWrite <= '0'; 
        MemRead <= '0'; 
        MemWrite <= '0'; 
        Jump <= '1'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3));   
    elsif (dcd_op = OP_JAL) then 
        RegDst <= '0';  
        ALUSrc <= '0'; 
        MemtoReg <= '0';
        RegWrite <= '0'; 
        MemRead <= '0'; 
        MemWrite <= '0'; 
        Jump <= '1'; 
        AndLink <= '1';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3));               
    elsif (dcd_op = OP_BLEZ) then 
        RegDst <= 'X';  
        ALUSrc <= '0'; 
        MemtoReg <= 'X';
        RegWrite <= '0'; 
        MemRead <= '0'; 
        MemWrite <= '1'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '1'; 
        BranchType <= std_logic_vector(to_unsigned(4,3)); -- 4 branch less than
        ALUop <= std_logic_vector(to_unsigned(1,3));
    elsif (dcd_op = OP_BGTZ) then 
        RegDst <= 'X';  
        ALUSrc <= '0'; 
        MemtoReg <= 'X';
        RegWrite <= '0'; 
        MemRead <= '0'; 
        MemWrite <= '1'; 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '1'; 
        BranchType <= std_logic_vector(to_unsigned(5,3)); -- 5 brach greater than
        ALUop <= std_logic_vector(to_unsigned(1,3));   
    elsif (dcd_op = OP_SB) then 
        RegDst <= 'X';  
        ALUSrc <= '1'; 
        MemtoReg <= 'X';
        RegWrite <= '0'; 
        MemRead <= '1'; 
        MemWrite <= '1'; SpecialMemOp <= std_logic_vector(to_unsigned(1,3)); 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3)); 
    elsif dcd_op = OP_SH then 
        RegDst <= 'X';  
        ALUSrc <= '1'; 
        MemtoReg <= 'X';
        RegWrite <= '0'; 
        MemRead <= '1'; 
        MemWrite <= '1'; SpecialMemOp <= std_logic_vector(to_unsigned(2,3)); 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3)); 
    elsif dcd_op = OP_LB then 
        RegDst <= '0';  
        ALUSrc <= '1'; 
        MemtoReg <= '1';
        RegWrite <= '1'; 
        MemRead <= '1'; 
        MemWrite <= '0'; SpecialMemOp <= std_logic_vector(to_unsigned(3,3)); 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3)); 
    elsif dcd_op = OP_LH then 
        RegDst <= '0';  
        ALUSrc <= '1'; 
        MemtoReg <= '1';
        RegWrite <= '1'; 
        MemRead <= '1'; 
        MemWrite <= '0'; SpecialMemOp <= std_logic_vector(to_unsigned(4,3)); 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3)); 
    elsif dcd_op = OP_LBU then 
        RegDst <= '0';  
        ALUSrc <= '1'; 
        MemtoReg <= '1';
        RegWrite <= '1'; 
        MemRead <= '1'; 
        MemWrite <= '0'; SpecialMemOp <= std_logic_vector(to_unsigned(5,3)); 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3)); 
    elsif dcd_op = OP_LHU then
        RegDst <= '0';  
        ALUSrc <= '1'; 
        MemtoReg <= '1';
        RegWrite <= '1'; 
        MemRead <= '1'; 
        MemWrite <= '0'; SpecialMemOp <= std_logic_vector(to_unsigned(6,3)); 
        Jump <= '0'; 
        AndLink <= '0';
        Branch <= '0'; 
        BranchType <= std_logic_vector(to_unsigned(0,3)); 
        ALUop <= std_logic_vector(to_unsigned(1,3)); 
    end if; 
  end process;   

end beh; 