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
        SpecialMemOp : in STD_LOGIC_VECTOR(3 downto 0); 
        -- memory signal
        write_enable : std_logic_vector(3 downto 0); 
        write_data_to_mem : std_logic_vetor(31 downto 0);
        addr : std_logic_vector(31 downto 0);
    );
end DataMemory;

architecture Behavioral of DataMemory is
    variable temp_read_data : STD_LOGIC_VECTOR(31 downto 0);
begin
    process (datamem_addr, write_data, MemWrite, MemRead, SpecialMemwrite)
    begin
        if MemRead = '1' then
            temp_read_data := read_data; 
            if SpecialMemOp = 3 then -- LB
                read_data <= temp_read_data and X"000000FF";
                read_data <= sign_extend(get_bit_range(read_data, 15, 0), 8);
            elsif SpecialMemOp = 4 then -- LH
                read_data <= temp_read_data and X"0000FFFF";
                read_data <= sign_extend(get_bit_range(read_data, 15, 0), 16);
            elsif SpecialMemOp = 5 then -- LBU
                read_data <= temp_read_data and X"000000FF";
            elsif SpecialMemOp = 6 then -- LHU
                read_data <= temp_read_data and X"0000FFFF";
            end if;
        end if;
        
        if MemWrite = '1' then
            if SpecialMemOp = 1 then -- SB
                write_enable <= "0001"; 
                write_data_to_mem := write_data;
            elsif SpecialMemOp = 2 then -- SH
                write_enable <= "0011";
                write_data_to_mem := write_data;
            else
                write_enable <= "1111"; 
                write_data_to_mem <= write_data;
            end if;
        else 
            write_enable <= "0000";           
        end if;
    end process;
end Behavioral;
