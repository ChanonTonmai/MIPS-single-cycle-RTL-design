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
begin
  -- Declarations and statements go here
  
end Behavioral;
