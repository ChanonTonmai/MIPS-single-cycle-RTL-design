library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Define your entity here
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

  signal read_data_1, read_data_2 : std_logic_vector(31 downto 0); 


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
    mem_data_out  : in STD_LOGIC_VECTOR(31 downto 0);
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
        write_enable : std_logic_vector(3 downto 0); 
        write_data_to_mem : std_logic_vetor(31 downto 0);
        addr : std_logic_vector(31 downto 0);
    );
end component;

  signal PC_reg, PC_next; 
  signal muxRegDst, muxAndLink : std_logic_vector(4 downto 0); 
  signal write_reg, read_reg_1, read_reg_2 : std_logic_vector(4 downto 0); 
  signal read_data_1, read_data_2 : std_logic_vector(31 downto 0); 
  signal dcd_offset_extend : std_logic_vector(31 downto 0); 
  signal a, b, result: std_logic_vector(31 downto 0);
  signal neg, zero : std_logic; 
  signal aluCtrlVal : std_logic_vector(5 downto 0); 
  signal jumpAddr : std_logic_vector(31 downto 0); 
  signal pcPlusFour, pcForJ : std_logic_vector(31 downto 0); 
  signal seAddr : std_logic_vector(31 downto 0); -- signed extend address
   
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
    dcd_se_mem_offset <= (others => dcd_offset(15)) & dcd_offset;
    dcd_imm <= inst(15 downto 0);
    dcd_e_imm <= (others => '0') & dcd_imm;
    dcd_se_imm <= (others => dcd_imm(15)) & dcd_imm;
    dcd_target <= inst(25 downto 0);
    dcd_code <= inst(25 downto 6);

   

    write_reg <= muxRegDst when ALR = 0 else muxAndLink; 
    muxAndLink <= muxRegDst when Andlink = 0 else std_logic_vector(to_unsigned(31,5)); 
    muxRegDst <= dcd_rd when RegDst = 1 else dcd_rt; 
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
    dcd_offset_extend <= (others => dcd_offset(15)) & dcd_offset;
    a <= read_data_1; 
    b <= read_data_2 when ALUSrc = 0 else dcd_offset_extend; 
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

    pcPlusFour <= std_logic_vector(unsigned(pc_reg)+4); 
    jumpAddr <= pcPlusFour(31 downto 28) & dcd_target & "00";  
    seAddr <= dcd_offset_extend(29 downto 0) & "00";      
    pcForJ <= std_logic_vector(unsigned(seAddr) + unsigned(pcPlusFour)); 

    pcForNextMux1 <= pcPlusFour when Branch = 0 else pcForJ; 
    pcForNextMux2 <= pcForNext1 when Jump = 0 else jumpAddr; 
    pc_next <= pcForNextMux2; 

    datamem_addr <= result; 
    write_data_mem <= read_data_2;      
    memMIPS: DataMemory 
      Port (
          datamem_addr  => datamem_addr,
          write_data    => write_data_mem,
          read_data     => read_data_mem,
          MemWrite      => MemWrite,
          MemRead       => MemRead,
          SpecialMemOp  => SpecialMemOp,
          -- memory signal
          write_enable      => write_enable,
          write_data_to_mem => write_data_to_mem,
          addr              => addr,
      );
    write_data <= read_data_mem when memtoReg = 1 else result; 



    signal alu__sel : STD_LOGIC_VECTOR(3 downto 0);
    signal ctrl_RI, ctrl_Sys, ctrl_we : STD_LOGIC;
    -- Define your other wire signals here

    -- Instantiate mips_decode
    -- Generate control signal here
    Decoder: entity work.mips_decode
        port map (
        ctrl_we => ctrl_we,
        ctrl_Sys => ctrl_Sys,
        ctrl_RI => ctrl_RI,
        alu__sel => alu__sel(3 downto 0),
        dcd_op => dcd_op(5 downto 0),
        dcd_funct2 => dcd_funct2(5 downto 0)
        -- Connect other ports here
        );

end Behavioral;


