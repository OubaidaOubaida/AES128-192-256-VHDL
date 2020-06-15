library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY mix_column IS
PORT (
       mixcolumn_in : IN  STD_LOGIC_VECTOR (127 downto 0);
       mixcolumn_out : OUT  STD_LOGIC_VECTOR (127 downto 0)
       );
end mix_column;

architecture Behavioral of mix_column is
--signal p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15:std_logic_vector(7 downto 0);

component mixcolumn32 is
    Port ( i1,i2,i3,i4: in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0)
		 );
end component;
 
begin

 z1: mixcolumn32 port map(i1 => mixcolumn_in(127 downto 120),i2 => mixcolumn_in(119 downto 112),i3 =>mixcolumn_in(111 downto 104),i4 =>mixcolumn_in(103 downto 96),data_out => mixcolumn_out(127 downto 120)); 
 z2: mixcolumn32 port map(i1 => mixcolumn_in(119 downto 112),i2 => mixcolumn_in(111 downto 104),i3 =>mixcolumn_in(103 downto 96),i4 =>mixcolumn_in(127 downto 120),data_out => mixcolumn_out(119 downto 112)); 
 z3: mixcolumn32 port map(i1 => mixcolumn_in(111 downto 104),i2 =>mixcolumn_in(103 downto 96),i3 =>mixcolumn_in(127 downto 120),i4 =>mixcolumn_in(119 downto 112),data_out => mixcolumn_out(111 downto 104)); 
 z4: mixcolumn32 port map(i1 => mixcolumn_in(103 downto 96),i2 =>mixcolumn_in(127 downto 120),i3 =>mixcolumn_in(119 downto 112),i4 =>mixcolumn_in(111 downto 104),data_out => mixcolumn_out(103 downto 96)); 

 z5: mixcolumn32 port map(i1 => mixcolumn_in(95 downto 88),i2 =>mixcolumn_in(87 downto 80),i3 =>mixcolumn_in(79 downto 72),i4 =>mixcolumn_in(71 downto 64),data_out => mixcolumn_out(95 downto 88));         
 z6: mixcolumn32 port map(i1 => mixcolumn_in(87 downto 80),i2 =>mixcolumn_in(79 downto 72),i3 =>mixcolumn_in(71 downto 64),i4 =>mixcolumn_in(95 downto 88),data_out => mixcolumn_out(87 downto 80));         
 z7: mixcolumn32 port map(i1 => mixcolumn_in(79 downto 72),i2 =>mixcolumn_in(71 downto 64),i3 =>mixcolumn_in(95 downto 88),i4 =>mixcolumn_in(87 downto 80),data_out => mixcolumn_out(79 downto 72));        
 z8: mixcolumn32 port map(i1 => mixcolumn_in(71 downto 64),i2 =>mixcolumn_in(95 downto 88),i3 =>mixcolumn_in(87 downto 80),i4 =>mixcolumn_in(79 downto 72),data_out => mixcolumn_out(71 downto 64));        

 z9: mixcolumn32 port map(i1 => mixcolumn_in(63 downto 56),i2 =>mixcolumn_in(55 downto 48),i3 =>mixcolumn_in(47 downto 40),i4 =>mixcolumn_in(39 downto 32),data_out => mixcolumn_out(63 downto 56));       
 z10: mixcolumn32 port map(i1 => mixcolumn_in(55 downto 48),i2 =>mixcolumn_in(47 downto 40),i3 =>mixcolumn_in(39 downto 32),i4 =>mixcolumn_in(63 downto 56),data_out => mixcolumn_out(55 downto 48));       
 z11: mixcolumn32 port map(i1 => mixcolumn_in(47 downto 40),i2 =>mixcolumn_in(39 downto 32),i3 =>mixcolumn_in(63 downto 56),i4 =>mixcolumn_in(55 downto 48),data_out => mixcolumn_out(47 downto 40));      
 z12: mixcolumn32 port map(i1 => mixcolumn_in(39 downto 32),i2 =>mixcolumn_in(63 downto 56),i3 =>mixcolumn_in(55 downto 48),i4 =>mixcolumn_in(47 downto 40),data_out => mixcolumn_out(39 downto 32));      

 z13: mixcolumn32 port map(i1 => mixcolumn_in(31 downto 24),i2 =>mixcolumn_in(23 downto 16),i3 =>mixcolumn_in(15 downto 8),i4 =>mixcolumn_in(7 downto 0),data_out => mixcolumn_out(31 downto 24));         
 z14: mixcolumn32 port map(i1 => mixcolumn_in(23 downto 16),i2 =>mixcolumn_in(15 downto 8),i3 =>mixcolumn_in(7 downto 0),i4 =>mixcolumn_in(31 downto 24),data_out => mixcolumn_out(23 downto 16));         
 z15: mixcolumn32 port map(i1 => mixcolumn_in(15 downto 8),i2 =>mixcolumn_in(7 downto 0),i3 =>mixcolumn_in(31 downto 24),i4 =>mixcolumn_in(23 downto 16),data_out => mixcolumn_out(15 downto 8));        
 z16: mixcolumn32 port map(i1 => mixcolumn_in(7 downto 0),i2 =>mixcolumn_in(31 downto 24),i3 =>mixcolumn_in(23 downto 16),i4 =>mixcolumn_in(15 downto 8),data_out => mixcolumn_out(7 downto 0));         

end Behavioral;
