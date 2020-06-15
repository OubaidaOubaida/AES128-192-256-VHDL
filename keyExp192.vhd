library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity key_schedule_192 is
    Port (  clk		        :   IN  STD_LOGIC;
            reset           :   IN  STD_LOGIC;
            key_in          :   IN  STD_LOGIC_VECTOR(191 DOWNTO 0);
            key_out         :   OUT STD_LOGIC_VECTOR(191 DOWNTO 0);
            key_reg_mux_sel :   IN  STD_LOGIC;
            round_constant  :    IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            load_key_reg    :    IN  STD_LOGIC
  );
end key_schedule_192;

architecture Behavioral of key_schedule_192 is

--signal declaration
TYPE word_array is array (5 downto 0) of std_logic_vector(31 downto 0); 
SIGNAL key_word, next_key_word : word_array;

SIGNAL T , temp_shift, temp_sbox: std_logic_vector(31 downto 0);
SIGNAL key_reg_in, next_key, key_reg_out : std_logic_vector(191 downto 0);
SIGNAL upperbyte_trans : std_logic_vector(7 downto 0);


--component declaration
COMPONENT s_box_4 
PORT(
    s_word_in    :	IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_word_out   :	OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END COMPONENT;

BEGIN

--key register, which stores a round key:
key0:
PROCESS(reset, clk, key_reg_in, load_key_reg)
BEGIN
    IF(reset='1') THEN
	key_reg_out <= (others =>'0');
    ELSIF(clk'event AND clk='1') THEN
	IF(load_key_reg='1') THEN
	    key_reg_out <= key_reg_in;
	END IF;
    END IF;
END PROCESS key0;

--mux at the input of key register
key_reg_in <= key_in  WHEN key_reg_mux_sel='0' ELSE next_key;

--mapping a vector into array of words
key_word(0) <= key_reg_out(191 downto 160);
key_word(1) <= key_reg_out(159 downto 128);
key_word(2) <= key_reg_out(127 downto 96);
key_word(3) <= key_reg_out(95 downto 64);
key_word(4) <= key_reg_out(63 downto 32);
key_word(5) <= key_reg_out(31 downto 0);


--calculating next key words or next key column
next_key_word(0) <= key_word(0) XOR T;
next_key_word(1) <= key_word(1) XOR key_word(0) XOR T;
next_key_word(2) <= key_word(2) XOR key_word(1) XOR key_word(0) XOR T;
next_key_word(3) <= key_word(3) XOR key_word(2) XOR key_word(1) XOR key_word(0) XOR T;
next_key_word(4) <= key_word(4) XOR key_word(3) XOR key_word(2) XOR key_word(1) XOR key_word(0) XOR T;
next_key_word(5) <= key_word(5) XOR key_word(4) XOR key_word(3) XOR key_word(2) XOR key_word(1) XOR key_word(0) XOR T;
--converting word array back to a vector
next_key <= next_key_word(0) & next_key_word(1) & next_key_word(2) & next_key_word(3)& next_key_word(4) & next_key_word(5);
--below describes the calculation of T:
--left shift
temp_shift <= key_word(5)(23 downto 16) & key_word(5)(15 downto 8) & key_word(5)(7 downto 0) & key_word(5)(31 downto 24);
--key subbyte transformation
sbox_lookup: s_box_4 
PORT MAP(
	s_word_in   => temp_shift,    
	s_word_out  => temp_sbox
	);
	
--XOR the upperbyte and round constant
upperbyte_trans <= temp_sbox(31 downto 24) XOR round_constant;
--finally vector T calculated
T <= upperbyte_trans & temp_sbox(23 downto 0);
--connecting signal to a entity port
key_out <= key_reg_out;  

end Behavioral;
