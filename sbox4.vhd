LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY s_box_4 IS
PORT(
    s_word_in    :	IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_word_out   :	OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END s_box_4;

ARCHITECTURE beh OF s_box_4 IS
--component instantiation
COMPONENT sbox IS
PORT(
    sbox_in    :	IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    sbox_out   :	OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END COMPONENT;

BEGIN
s1: 	sbox
    PORT MAP(
	    sbox_in => s_word_in(31 downto 24),
	    sbox_out => s_word_out(31 downto 24)
	    );
s2: 	sbox
    PORT MAP(
	    sbox_in => s_word_in(23 downto 16),
	    sbox_out => s_word_out(23 downto 16)
	    );
 s3:  	sbox
    PORT MAP(
	    sbox_in => s_word_in(15 downto 8),
	    sbox_out => s_word_out(15 downto 8)
	    );
s4:   sbox
    PORT MAP(
	    sbox_in => s_word_in(7 downto 0),
	    sbox_out => s_word_out(7 downto 0)
	    );	    


END beh;			    
			    
