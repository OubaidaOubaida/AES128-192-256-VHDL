Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity invsub_bytes is
      port ( sub_in  : in std_logic_vector (127 downto 0);
             sub_out : out std_logic_vector (127 downto 0)
		    );
end invsub_bytes;

architecture Behavioral of invsub_bytes is

component invSBox is
	port (i : in std_logic_vector (7downto 0);
			o : out std_logic_vector (7downto 0)
			);
end component;

begin

s1: invSbox port map (i => sub_in(127 downto 120),o =>sub_out(127 downto 120)); 
s2  : invSbox port map (i => sub_in(119 downto 112),o =>sub_out(119 downto 112)); 
s3  : invSbox port map (i => sub_in(111 downto 104),o =>sub_out(111 downto 104)); 
s4  : invSbox port map (i => sub_in(103 downto 96),o =>sub_out (103 downto 96)); 
s5  : invSbox port map (i => sub_in(95 downto 88),o =>sub_out (95 downto 88)); 
s6  : invSbox port map (i => sub_in(87 downto 80),o =>sub_out (87 downto 80)); 
s7  : invSbox port map (i => sub_in(79 downto 72),o =>sub_out (79 downto 72)); 
s8  : invSbox port map (i => sub_in(71 downto 64),o =>sub_out (71 downto 64)); 
s9  : invSbox port map (i => sub_in(63 downto 56),o =>sub_out (63 downto 56)); 
s10 : invSbox port map (i => sub_in(55 downto 48),o =>sub_out (55 downto 48)); 
s11 : invSbox port map (i => sub_in(47 downto 40),o =>sub_out (47 downto 40)); 
s12 : invSbox port map (i => sub_in(39 downto 32),o =>sub_out (39 downto 32)); 
s13 : invSbox port map (i => sub_in(31 downto 24),o =>sub_out (31 downto 24)); 
s14 : invSbox port map (i => sub_in(23 downto 16),o =>sub_out (23 downto 16)); 
s15 : invSbox port map (i => sub_in(15 downto 8),o =>sub_out (15 downto 8)); 
s16 : invSbox port map (i => sub_in(7 downto 0),o =>sub_out   (7 downto 0)); 

end Behavioral;
