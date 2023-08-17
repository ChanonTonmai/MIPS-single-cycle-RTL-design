library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Define your entity here
entity mips_reg is
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
end mips_reg;

architecture Behavioral of mips_reg is
    type word is array(31 downto 0) of std_logic_vector(31 downto 0);
    signal mem: word; 
begin

process(clk, rst_b) begin
    if rst_b == 0 then 
        mem_zero : for k in 0 to 31 loop
            mem(k) <= (others=>'0'); 
        end loop; 
    elsif rising_edge(clk) then
        if RegWrite == '1' and write_reg != std_logic_vector(to_unsigned(0,4)) then
            mem(to_integer(unsigned(write_reg))) <= write_data; 
        end if; 
    end if; 
end process;

read_data_1 <= (others=>'0') when read_reg_1 = std_logic_vector(to_unsigned(0,4)) else mem(to_integer(unsigned(read_reg_1)))  
read_data_2 <= (others=>'0') when read_reg_2 = std_logic_vector(to_unsigned(0,4)) else mem(to_integer(unsigned(read_reg_2)))  

end Behavioral; 