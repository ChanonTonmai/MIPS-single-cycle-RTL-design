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
    mem_data_out  : in STD_LOGIC_VECTOR(31 downto 0);
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


   -- PC Management
   component PCReg
     generic (
       width : positive;
       initial_value : STD_LOGIC_VECTOR(width - 1 downto 0)
     );
     port (
       q, d : out STD_LOGIC_VECTOR(width - 1 downto 0);
       clk : in STD_LOGIC;
       enable, rst_b : in STD_LOGIC
     );
   end component;
   
   component PCReg2
     generic (
       width : positive;
       initial_value : STD_LOGIC_VECTOR(width - 1 downto 0)
     );
     port (
       q, d : out STD_LOGIC_VECTOR(width - 1 downto 0);
       clk : in STD_LOGIC;
       enable, rst_b : in STD_LOGIC
     );
   end component;
   
   component NextPCAdder
     generic (
       add_value : positive
     );
     port (
       out : out STD_LOGIC_VECTOR(31 downto 0);
       in1 : in STD_LOGIC_VECTOR(31 downto 0);
       in2 : in STD_LOGIC_VECTOR(31 downto 0);
       sub : in STD_LOGIC
     );
   end component;
   signal PC_reg, PC_next; 
   
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

    -- Debugging display
    --    process(clk)
    --    begin
    --      if rst_b = '0' then
    --        $display ( "=== Simulation Cycle %d ===", now );
    --        $display ( "[pc=%x, inst=%x] [op=%x, rs=%d, rt=%d, rd=%d, imm=%x, f2=%x] [reset=%d, halted=%d]",
    --                    pc, inst, dcd_op, dcd_rs, dcd_rt, dcd_rd, dcd_imm, dcd_funct2, not rst_b, halted);
    --      end if;
    --    end process;

    -- Automatic wires
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

    -- Register File
    -- Instantiate the register file from reg_file.vhd here
    -- Connect the "halted" signal to trigger the register dump

    -- Automatic wires (commented out due to VHDL's strong type checking)
    -- signal alu__sel : STD_LOGIC_VECTOR(3 downto 0);
    -- signal ctrl_RI, ctrl_Sys, ctrl_we : STD_LOGIC;
    -- Instantiate mips_decode and connect automatic wires
    -- Also connect other signals accordingly

    -- Register file instantiation (to be completed)
    -- Instantiate registers and connect them to the register file

    -- Execution
    -- Instantiate the ALU (mips_ALU entity) and connect signals
    ALU: entity work.mips_ALU
        port map (
        alu__out => alu_out,
        alu__op1 => rs_data,
        alu__op2 => dcd_se_imm,
        alu__sel => alu__sel
        );

    -- Miscellaneous stuff (Exceptions, syscalls, and halt)
    -- Define exception_unit and syscall_unit units here

    -- Other signal assignments and instances here
end Behavioral;


