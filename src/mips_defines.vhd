library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mips_defines is 
    -- MIPS Defines: Numerical parameters of the MIPS processor
    -- USEFUL CONSTANTS
    -- Mask for the coprocessor number from the opcode
    constant OP__ZMASK : std_logic_vector(5 downto 0) := "000011"; 

    -- Mask to force word-alignment of addresses
    constant ADDR_ALIGN_MASK : std_logic_vector(31 downto 0) := x"fffffffc";

    -- Mask particular bytes
    constant BYTE_0_MASK     : std_logic_vector(31 downto 0) := x"000000ff";
    constant BYTE_1_MASK     : std_logic_vector(31 downto 0) := x"0000ff00";
    constant BYTE_2_MASK     : std_logic_vector(31 downto 0) := x"00ff0000";
    constant BYTE_3_MASK     : std_logic_vector(31 downto 0) := x"ff000000";
    constant BYTE_0_1_MASK   : std_logic_vector(31 downto 0) := x"0000ffff";
    constant BYTE_0_2_MASK   : std_logic_vector(31 downto 0) := x"00ff00ff";
    constant BYTE_0_3_MASK   : std_logic_vector(31 downto 0) := x"ff0000ff";
    constant BYTE_1_2_MASK   : std_logic_vector(31 downto 0) := x"00ffff00";
    constant BYTE_1_3_MASK   : std_logic_vector(31 downto 0) := x"ff00ff00";
    constant BYTE_2_3_MASK   : std_logic_vector(31 downto 0) := x"ffff0000";
    constant BYTE_0_1_2_MASK : std_logic_vector(31 downto 0) := x"00ffffff";
    constant BYTE_0_1_3_MASK : std_logic_vector(31 downto 0) := x"ff00ffff";
    constant BYTE_0_2_3_MASK : std_logic_vector(31 downto 0) := x"ffff00ff";
    constant BYTE_1_2_3_MASK : std_logic_vector(31 downto 0) := x"ffffff00";


    --OPCODES
    --Main opcodes (op field)
    constant OP_OTHER0 : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(0, 6));
    constant OP_OTHER1 : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(1, 6));
    constant OP_J      : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(2, 6));
    constant OP_JAL    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(03, 6));
    constant OP_BEQ    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(4, 6));
    constant OP_BNE    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(5, 6));
    constant OP_BLEZ   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(6, 6));
    constant OP_BGTZ   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(7, 6));
    constant OP_ADDI   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(8, 6));
    constant OP_ADDIU  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(9, 6));
    constant OP_SLTI   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(10, 6));
    constant OP_SLTIU  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(11, 6));
    constant OP_ANDI   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(12, 6));
    constant OP_ORI    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(13, 6));
    constant OP_XORI   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(14, 6));
    constant OP_LUI    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(15, 6));
    constant OP_Z0     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16, 6));
    constant OP_Z1     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(17, 6));
    constant OP_Z2     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(18, 6));
    constant OP_Z3     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(19, 6));
    constant OP_LB     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(32, 6));
    constant OP_LH     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(33, 6));
    constant OP_LWL    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(34, 6));
    constant OP_LW     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(35, 6));
    constant OP_LBU    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(36, 6));
    constant OP_LHU    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(37, 6));
    constant OP_LWR    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(38, 6));
    constant OP_SB     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(40, 6));
    constant OP_SH     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(41, 6));
    constant OP_SWL    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(42, 6));
    constant OP_SW     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(43, 6));
    constant OP_SWR    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(46, 6));
    constant OP_LWC0   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(48, 6));
    constant OP_LWC1   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(49, 6));
    constant OP_LWC2   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(50, 6));
    constant OP_LWC3   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(51, 6));
    constant OP_SWC0   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(56, 6));
    constant OP_SWC1   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(57, 6));
    constant OP_SWC2   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(58, 6));
    constant OP_SWC3   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(59, 6));

    -- Secondary opcodes (rs field; OP_Z[0-3])
    constant OPZ_MFCZ  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(0, 5)); 
    constant OPZ_CFCZ  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(2, 5)); 
    constant OPZ_MTCZ  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(4, 5)); 
    constant OPZ_CTCZ  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(6, 5)); 
    constant OPZ_BCZ   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(8, 5)); 
    constant OPZ_COPZS : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(16, 5)); 
    constant OPZ_COPZD : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(17, 5)); 


    -- -- Secondary opcodes (rt field; OP_OTHER1)
    constant OP1_BLTZ    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(0,5)); --5'h00
    constant OP1_BGEZ    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(1,5)); --5'h01
    constant OP1_BLTZAL  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16,5)); --5'h10
    constant OP1_BGEZAL  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(17,5)); --5'h11

    -- Secondary opcodes (funct2 field; OP_OTHER0)
    constant OP0_SLL     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(0, 6));   
    constant OP0_SRL     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(2, 6));   
    constant OP0_SRA     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(3, 6));   
    constant OP0_SLLV    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(4, 6));   
    constant OP0_SRLV    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(6, 6));   
    constant OP0_SRAV    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(7, 6));   
    constant OP0_JR      : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(8, 6));   
    constant OP0_JALR    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(9, 6));   
    constant OP0_SYSCALL : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(13, 6));  
    constant OP0_BREAK   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(14, 6));  
    constant OP0_MFHI    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16, 6));  
    constant OP0_MTHI    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(17, 6));  
    constant OP0_MFLO    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(18, 6));  
    constant OP0_MTLO    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(19, 6));  
    constant OP0_MULT    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(24, 6));  
    constant OP0_MULTU   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(25, 6));  
    constant OP0_DIV     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(26, 6));  
    constant OP0_DIVU    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(27, 6));  
    constant OP0_ADD     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(32, 6));  
    constant OP0_ADDU    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(33, 6));  
    constant OP0_SUB     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(34, 6));  
    constant OP0_SUBU    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(35, 6));  
    constant OP0_AND     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(36, 6));  
    constant OP0_OR      : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(37, 6));  
    constant OP0_XOR     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(38, 6));  
    constant OP0_NOR     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(39, 6));  
    constant OP0_SLT     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(42, 6));  
    constant OP0_SLTU    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(43, 6));  

    -- Tertiary opcodes (funct2 field; OP_Z1 && (OPZ_COPZS || OPZ_COPZD))
    -- constant OPF_ADDF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"00", 6)); 
    -- constant OPF_SUBF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"01", 6)); 
    -- constant OPF_MULF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"02", 6)); 
    -- constant OPF_DIVF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"03", 6)); 
    -- constant OPF_ABSF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"05", 6)); 
    -- constant OPF_MOVF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"06", 6)); 
    -- constant OPF_NEGF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"07", 6)); 
    -- constant OPF_CVTSF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"20", 6)); 
    -- constant OPF_CVTDF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"21", 6)); 
    -- constant OPF_CVTWF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"24", 6)); 
    -- constant OPF_CFF    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"30", 6)); 
    -- constant OPF_CUNF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"31", 6)); 
    -- constant OPF_CEQF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"32", 6)); 
    -- constant OPF_CUEQF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"33", 6)); 
    -- constant OPF_COLTF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"34", 6)); 
    -- constant OPF_CULTF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"35", 6)); 
    -- constant OPF_COLEF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"36", 6)); 
    -- constant OPF_CULEF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"37", 6)); 
    -- constant OPF_CSFF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"38", 6)); 
    -- constant OPF_CNGLEF : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"39", 6)); 
    -- constant OPF_CSEQF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"3a", 6)); 
    -- constant OPF_CNGLF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"3b", 6)); 
    -- constant OPF_CLTF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"3c", 6)); 
    -- constant OPF_CNGEF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"3d", 6)); 
    -- constant OPF_CLEF   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"3e", 6)); 
    -- constant OPF_CNGTF  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(x"3f", 6)); 


    ---- Register Mnemonics
    -- Main processor
    constant R_ZERO : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(0 , 5)); 
    constant R_AT   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(1 , 5)); 
    constant R_V0   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(2 , 5)); 
    constant R_V1   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(3 , 5)); 
    constant R_A0   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(4 , 5)); 
    constant R_A1   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(5 , 5)); 
    constant R_A2   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(6 , 5)); 
    constant R_A3   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(7 , 5)); 
    constant R_T0   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(8 , 5)); 
    constant R_T1   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(9 , 5)); 
    constant R_T2   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(10, 5)); 
    constant R_T3   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(11, 5)); 
    constant R_T4   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(12, 5)); 
    constant R_T5   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(13, 5)); 
    constant R_T6   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(14, 5)); 
    constant R_T7   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(15, 5)); 
    constant R_S0   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(16, 5)); 
    constant R_S1   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(17, 5)); 
    constant R_S2   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(18, 5)); 
    constant R_S3   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(19, 5)); 
    constant R_S4   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(20, 5)); 
    constant R_S5   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(21, 5)); 
    constant R_S6   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(22, 5)); 
    constant R_S7   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(23, 5)); 
    constant R_T8   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(24, 5)); 
    constant R_T9   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(25, 5)); 
    constant R_K0   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(26, 5)); 
    constant R_K1   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(27, 5)); 
    constant R_GP   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(28, 5)); 
    constant R_SP   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(29, 5)); 
    constant R_FP   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(30, 5)); 
    constant R_RA   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(31, 5)); 

    -- Exception codes
    constant EX_INT   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(0 , 5)); 
    constant EX_MOD   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(1 , 5)); 
    constant EX_TLBL  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(2 , 5)); 
    constant EX_TLBS  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(3 , 5)); 
    constant EX_ADEL  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(4 , 5)); 
    constant EX_ADES  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(5 , 5)); 
    constant EX_IBE   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(6 , 5)); 
    constant EX_DBE   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(7 , 5)); 
    constant EX_SYS   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(8 , 5)); 
    constant EX_BP    : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(9 , 5)); 
    constant EX_RI    : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(10, 5)); 
    constant EX_CPU   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(11, 5)); 
    constant EX_OV    : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(12, 5)); 
    constant EX_TR    : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(13, 5)); 
    constant EX_VCEI  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(14, 5)); 
    constant EX_FPE   : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(15, 5)); 
    constant EX_WATCH : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(23, 5)); 
    constant EX_VCED  : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(31, 5)); 

    -- System calls
    constant SYS_EXIT : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(10, 31)); 


    --Multiply unit opcodes
    constant MUL_MFHI  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(0, 4)); 
    constant MUL_MTHI  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(1, 4)); 
    constant MUL_MFLO  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(2, 4)); 
    constant MUL_MTLO  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(3, 4)); 
    constant MUL_MULT  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(4, 4)); 
    constant MUL_MULTU : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(5, 4)); 
    constant MUL_DIV   : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(6, 4)); 
    constant MUL_DIVU  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(7, 4)); 
    
    constant FUNC_ADD    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(0,6)); 
    constant FUNC_ADDU   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(1,6)); 
    constant FUNC_SUB    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(2,6)); 
    constant FUNC_SUBU   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(3,6)); 
    constant FUNC_AND    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(4,6)); 
    constant FUNC_OR     : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(5,6)); 
    constant FUNC_XOR    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(6,6)); 
    constant FUNC_SLL    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(7,6)); 
    constant FUNC_SRL    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(8,6)); 
    constant FUNC_SRA    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(9,6)); 
    constant FUNC_SLT    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(10,6)); 
    constant FUNC_NOR    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(11,6));  
    constant FUNC_SLLV   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(12,6)); 
    constant FUNC_SRLV   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(13,6)); 
    constant FUNC_SRAV   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(14,6)); 
    constant FUNC_MULT   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(15,6)); 
    constant FUNC_MULTU  : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16,6)); 
    constant FUNC_DIV    : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(17,6)); 
    constant FUNC_DIVU   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(18,6)); 
    constant FUNC_MFHI   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(19,6)); 
    constant FUNC_MFLO   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(20,6)); 
    constant FUNC_MTHI   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(21,6)); 
    constant FUNC_MTLO   : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(22,6)); 


end package; 