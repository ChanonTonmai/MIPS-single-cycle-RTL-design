library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mips_core is
  port (
    -- Outputs
    inst_addr     : out STD_LOGIC_VECTOR(29 downto 0);
    mem_addr      : out STD_LOGIC_VECTOR(29 downto 0);
    mem_data_in   : out STD_LOGIC_VECTOR(31 downto 0);
    mem_write_en  : out STD_LOGIC_VECTOR(3 downto 0);
    halted        : out STD_LOGIC;
    -- Inputs
    clk           : in STD_LOGIC;
    inst_excpt    : in STD_LOGIC;
    mem_excpt     : in STD_LOGIC;
    inst          : in STD_LOGIC_VECTOR(31 downto 0);
    rst_b         : in STD_LOGIC
  );
end mips_core;

architecture Behavioral of mips_core is
  -- Your architecture contents here
  signal pc, nextpc, nextnextpc : STD_LOGIC_VECTOR(31 downto 0);
  signal exception_halt, syscall_halt, internal_halt : STD_LOGIC;
  signal load_epc, load_bva, load_bva_sel : STD_LOGIC;
  signal rt_data, rs_data, rd_data, alu_out, r_v0 : STD_LOGIC_VECTOR(31 downto 0);
  signal epc, cause, bad_v_addr : STD_LOGIC_VECTOR(31 downto 0);
  signal cause_code : STD_LOGIC_VECTOR(4 downto 0);

  -- Decode signals
  signal dcd_se_imm, dcd_se_offset, dcd_e_imm, dcd_se_mem_offset : STD_LOGIC_VECTOR(31 downto 0);
  signal dcd_op, dcd_funct2 : STD_LOGIC_VECTOR(5 downto 0);
  signal dcd_rs, dcd_funct1, dcd_rt, dcd_rd, dcd_shamt : STD_LOGIC_VECTOR(4 downto 0);
  signal dcd_offset, dcd_imm : STD_LOGIC_VECTOR(15 downto 0);
  signal dcd_target : STD_LOGIC_VECTOR(25 downto 0);
  signal dcd_code : STD_LOGIC_VECTOR(19 downto 0);
  signal dcd_bczft : STD_LOGIC;

  signal read_data_1, read_data_2, write_data : std_logic_vector(31 downto 0); 
  signal condALU, condNotEq, condBltz, condBlez, condBgtz, condBgez : std_logic;

  component mips_reg is
  port (
    -- Outputs
    read_data_1   : out STD_LOGIC_VECTOR(31 downto 0);
    read_data_2   : out STD_LOGIC_VECTOR(31 downto 0);
    -- Inputs
    read_reg_1    : in STD_LOGIC_VECTOR(4 downto 0);
    read_reg_2    : in STD_LOGIC_VECTOR(4 downto 0);
    write_reg     : in STD_LOGIC_VECTOR(4 downto 0);
    write_data    : in STD_LOGIC_VECTOR(31 downto 0);
    RegWrite      : in STD_LOGIC;
    clk, rst_b    : in STD_LOGIC
  );
  end component;

  component mips_alu is 
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

  component DataMemory is
    Port (
        datamem_addr : in STD_LOGIC_VECTOR(31 downto 0);
        write_data : in STD_LOGIC_VECTOR(31 downto 0);
        read_data : out STD_LOGIC_VECTOR(31 downto 0);
        MemWrite : in STD_LOGIC;
        MemRead : in STD_LOGIC;
        SpecialMemOp : in STD_LOGIC_VECTOR(3 downto 0); 
        -- memory signal
        write_enable : out std_logic_vector(3 downto 0); 
        write_data_to_mem : out std_logic_vector(31 downto 0);
        addr : out std_logic_vector(31 downto 0)
    );
  end component;
  signal datamem_addr: std_logic_vector(31 downto 0); 
  signal write_data_mem, read_data_mem : std_logic_vector(31 downto 0); 

  component mips_ctrl is
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
        SpecialMemOp: out STD_LOGIC_VECTOR(3 downto 0)
    );
  end component;
  signal RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, AndLink, ALR, JalCtrl: std_logic; 
  signal ALUop, BranchType : std_logic_vector(2 downto 0); 
  signal SpecialMemOp : std_logic_vector(3 downto 0); 

  component mips_aluctrl is
    port (
      inst            : in STD_LOGIC_VECTOR(31 downto 0);
      ALUop           : in STD_LOGIC_VECTOR(2 downto 0);
      aluCtrlVal      : out STD_LOGIC_VECTOR(5 downto 0);
      JalCtrl        : out STD_LOGIC
    );
  end component;

  signal PC_reg, PC_next : std_logic_vector(31 downto 0); 
  signal muxRegDst, muxAndLink : std_logic_vector(4 downto 0); 
  signal write_reg, read_reg_1, read_reg_2 : std_logic_vector(4 downto 0); 
  signal dcd_offset_extend : std_logic_vector(31 downto 0); 
  signal a, b, result: std_logic_vector(31 downto 0);
  signal neg, zero : std_logic; 
  signal aluCtrlVal : std_logic_vector(5 downto 0); 
  signal jumpAddr, pcPlusFour2, pcForNextMux1, pcForNextMux2 : std_logic_vector(31 downto 0); 
  signal pcPlusFour, pcForJ : std_logic_vector(31 downto 0); 
  signal seAddr : std_logic_vector(31 downto 0); -- signed extend address
  signal shamt : std_logic_vector(4 downto 0); 
  signal JalrCtrl : std_logic; 
  
  signal BrachType : std_logic_vector(2 downto 0); 
   
begin
   -- Instantiate PCReg, PCReg2, and NextPCAdder here
    process(clk, rst_b) begin 
        if rst_b = '0' then 
            pc_reg <= (others=>'0');    
        elsif rising_edge(clk) then
            pc_reg <= pc_next; 
        end if; 
    end process; 
    inst_addr <= pc_reg; 
   
    -- Instruction decoding
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
    
    

    ctrlMIPS: mips_ctrl 
      Port map(
          inst              => inst,--: in STD_LOGIC_VECTOR(31 downto 0);
          RegDst            => RegDst,--: out STD_LOGIC;
          Jump              => Jump,--: out STD_LOGIC;
          Branch            => Branch,--: out STD_LOGIC;
          MemRead           => MemRead,--: out STD_LOGIC;
          MemtoReg          => MemtoReg,--: out STD_LOGIC;
          ALUop             => ALUop,--: out STD_LOGIC_VECTOR(2 downto 0);
          MemWrite          => MemWrite,--: out STD_LOGIC;
          ALUSrc            => ALUSrc,--: out STD_LOGIC;
          RegWrite          => RegWrite,--:  out STD_LOGIC;
          BranchType        => BranchType,--: out STD_LOGIC_VECTOR(2 downto 0);
          AndLink           => AndLink,--: out STD_LOGIC; 
          ALR               => ALR,--: out STD_LOGIC;
          SpecialMemOp      => SpecialMemOp--: out STD_LOGIC_VECTOR(3 downto 0);
      );

    write_reg <= muxRegDst when ALR = '0' else muxAndLink; 
    muxAndLink <= muxRegDst when Andlink = '0' else std_logic_vector(to_unsigned(31,5)); 
    muxRegDst <= dcd_rd when RegDst = '1' else dcd_rt; 
    read_reg_1 <= dcd_rs; 
    read_reg_2 <= dcd_rt; 
    reg32 : mips_reg 
      port map (
        -- Outputs
        read_data_1   => read_data_1,
        read_data_2   => read_data_2,
        -- Inputs
        read_reg_1    => read_reg_1, 
        read_reg_2    => read_reg_2, 
        write_reg     => write_reg,
        write_data    => write_data,
        RegWrite      => RegWrite,
        clk           => clk, 
        rst_b         => rst_b      
      );
    -- singed_extend 
    dcd_offset_extend(31 downto 16) <= (others => dcd_offset(15));
    dcd_offset_extend(15 downto 0) <= dcd_offset;
    a <= read_data_1; 
    b <= read_data_2 when ALUSrc = '0' else dcd_offset_extend; 
    mipsAlu_32: mips_alu 
    port map (
        a           => a,
        b           => b,
        result      => result,
        shamt       => shamt,
        aluCtrlVal  => aluCtrlVal,
        zero        => zero,
        neg         => neg
    ); 

    aluctrlmips:  mips_aluctrl 
      port map(
        inst            => inst,--VECTOR(31 downto 0);
        ALUop           => ALUop,--VECTOR(2 downto 0);
        aluCtrlVal      => aluCtrlVal,--_VECTOR(5 downto 0);
        JalCtrl        => JalCtrl--
      );


    pcPlusFour <= std_logic_vector(unsigned(pc_reg)+4); 
    jumpAddr <= pcPlusFour(31 downto 28) & dcd_target & "00";  
    seAddr <= dcd_offset_extend(29 downto 0) & "00";      
    pcForJ <= std_logic_vector(unsigned(seAddr) + unsigned(pcPlusFour)); 

    
    -- brach control left 
    process(neg, zero, BranchType, Branch) begin
      if BranchType = std_logic_vector(to_unsigned(1,5)) then 
        condALU <= zero and Branch;
        if condALU = '1' then
            pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4);
        else
            pcPlusFour2 <= std_logic_vector(unsigned(pcPlusFour) - 4);
        end if;  
      elsif BrachType = std_logic_vector(to_unsigned(0,5)) then 
        condNotEq <= (not zero) and Branch;  
        if condNotEq = '1' then
            pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4);
        else
            pcPlusFour2 <= std_logic_vector(unsigned(pcPlusFour) - 4);
        end if;
        --pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4) when condNotEq = '1' else std_logic_vector(unsigned(pcPlusFour) - 4);
      elsif BrachType = std_logic_vector(to_unsigned(2,5)) then 
        condBgez <= (not neg) and Branch;  
        if condBgez = '1' then
            pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4);
        else
            pcPlusFour2 <= std_logic_vector(unsigned(pcPlusFour) - 4);
        end if;
        --pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4) when condBgez = '1' else std_logic_vector(unsigned(pcPlusFour) - 4);
      elsif BrachType = std_logic_vector(to_unsigned(3,5)) then 
        condBltz <= neg and Branch;  
        if condBltz = '1' then
            pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4);
        else
            pcPlusFour2 <= std_logic_vector(unsigned(pcPlusFour) - 4);
        end if;
        --pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4) when condBltz = '1' else std_logic_vector(unsigned(pcPlusFour) - 4);
      elsif BrachType = std_logic_vector(to_unsigned(4,5)) then 
        condBlez <= (neg or zero) and Branch;  
        if condBlez = '1' then
            pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4);
        else
            pcPlusFour2 <= std_logic_vector(unsigned(pcPlusFour) - 4);
        end if;
        --pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4) when condBlez = '1' else std_logic_vector(unsigned(pcPlusFour) - 4);
      elsif BrachType = std_logic_vector(to_unsigned(5,5)) then 
        condBgtz <= ((not neg) or (not zero)) and Branch;  
        if condBgtz = '1' then
            pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4);
        else
            pcPlusFour2 <= std_logic_vector(unsigned(pcPlusFour) - 4);
        end if;
        --pcPlusFour2 <= std_logic_vector(unsigned(pcForJ) - 4) when condBgtz = '1' else std_logic_vector(unsigned(pcPlusFour) - 4);
      end if; 
    end process;

    pcForNextMux1 <= pcPlusFour2 when Branch = '0' else pcForJ; 
    pcForNextMux2 <= pcForNextMux1 when Jump = '0' else jumpAddr; 
    pc_next <= read_data_1 when JalrCtrl = '1' else pcForNextMux2;

    datamem_addr <= result; 
    write_data_mem <= read_data_2;      
    memMIPS: DataMemory 
      Port map(
          datamem_addr  => datamem_addr,
          write_data    => write_data_mem,
          read_data     => read_data_mem,
          MemWrite      => MemWrite,
          MemRead       => MemRead,
          SpecialMemOp  => SpecialMemOp,
          -- memory signal
          write_enable      => mem_write_en,
          write_data_to_mem => mem_data_in,
          addr              => mem_addr 
      );
    write_data <= read_data_mem when memtoReg = '1' else result; 
end Behavioral;


