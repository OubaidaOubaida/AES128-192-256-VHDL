library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SRAM192 is
port(
       Clock   :		in std_logic;
       RE      :		in std_logic;	
       WE          :	in std_logic;		
       Read_Addr   :    in natural ;
       Write_Addr :     in natural ; 
       Data_in    :     in std_logic_vector(191 downto 0);
       Data_out   :     out std_logic_vector(127 downto 0)
    );
end SRAM192;

architecture Behavioral of SRAM192 is

  	type STATE is array (natural range <>) of std_logic_vector (31 downto 0);
	signal tmp_ram :   STATE ( 0 to 53);                                                
begin

   -- Write Functional Section
    process(Clock)
    begin
    if (Clock'event and Clock='1') then
        if (WE='1')then

      tmp_ram(Write_Addr)   <= Data_in(191 downto 160 );
      tmp_ram(Write_Addr + 1)<=Data_in(159 downto 128);
      tmp_ram(Write_Addr + 2)<=Data_in(127 downto 96);
      tmp_ram(Write_Addr + 3)<=Data_in(95 downto 64);
      tmp_ram(Write_Addr + 4)<=Data_in(63 downto 32 );
      tmp_ram(Write_Addr + 5)<=Data_in(31 downto 0);
      
    end if;
    end if;
    end process;
    
    
  -- Read Functional Section
    process(Clock)
    begin
    if (Clock'event and Clock='1') then
           if (RE ='1') then
          Data_out <= tmp_ram(Read_Addr)&tmp_ram(Read_Addr+1)&tmp_ram(Read_Addr+2)&tmp_ram(Read_Addr+3); 
    end if;
    end if;
    end process;
 
end Behavioral;
