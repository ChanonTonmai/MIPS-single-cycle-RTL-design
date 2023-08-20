library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemory is
    Port (
        datamem_addr : in STD_LOGIC_VECTOR(31 downto 0);
        write_data : in STD_LOGIC_VECTOR(31 downto 0);
        read_data : out STD_LOGIC_VECTOR(31 downto 0);
        MemWrite : in STD_LOGIC;
        MemRead : in STD_LOGIC;
        SpecialMemOp : in STD_LOGIC_VECTOR(2 downto 0); 
        -- memory signal
        write_enable :  out std_logic_vector(3 downto 0); 
        write_data_to_mem : out std_logic_vector(31 downto 0);
        read_data_from_mem : in std_logic_vector(31 downto 0); 
        addr : out std_logic_vector(31 downto 0)
    );
end DataMemory;

architecture Behavioral of DataMemory is
    signal temp_read_data : STD_LOGIC_VECTOR(31 downto 0);
begin
    process (datamem_addr, write_data, MemWrite, MemRead, SpecialMemop)
    begin
        if MemRead = '1' then
            temp_read_data <= read_data_from_mem; 
            if SpecialMemOp = std_logic_vector(to_unsigned(3,3)) then -- LB
                temp_read_data <= temp_read_data and X"000000FF";
            elsif SpecialMemOp = std_logic_vector(to_unsigned(4,3)) then -- LH
                temp_read_data <= temp_read_data and X"0000FFFF";
            elsif SpecialMemOp = std_logic_vector(to_unsigned(5,3)) then -- LBU
                temp_read_data <= temp_read_data and X"000000FF";
            elsif SpecialMemOp = std_logic_vector(to_unsigned(6,3)) then -- LHU
                temp_read_data <= temp_read_data and X"0000FFFF";
            end if;
        end if;
        
        if MemWrite = '1' then
            if SpecialMemOp = std_logic_vector(to_unsigned(1,3)) then -- SB
                write_enable <= "0001"; 
                write_data_to_mem <= write_data;
            elsif SpecialMemOp = std_logic_vector(to_unsigned(2,3)) then -- SH
                write_enable <= "0011";
                write_data_to_mem <= write_data;
            else
                write_enable <= "1111"; 
                write_data_to_mem <= write_data;
            end if;
        else 
            write_enable <= "0000";           
        end if;
    end process;
end Behavioral;
