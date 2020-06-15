library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity invMix1Column is 
	port(
		column_in: in std_logic_vector(31 downto 0);
		column_out: out std_logic_vector(31 downto 0)
	);
end invMix1Column;

architecture invMix1Column_arch of invMix1Column is
	type array_bit9 is array (3 downto 0) of std_logic_vector(8 downto 0);
	subtype bit8 is std_logic_vector(7 downto 0);
	type column_state is array(0 to 3) of bit8;
	signal col2_s:column_state; --column_i * 2
	signal col4_s:column_state; --column_i * 4
	signal col8_s:column_state; --column_i * 8
	signal temp2_s, temp4_s, temp8_s:array_bit9;
    signal column_i,column_o: column_state;
	begin	
	 column_i(0) <= column_in(31 downto 24);
	 column_i(1) <= column_in(23 downto 16);
	 column_i(2) <= column_in(15 downto 8);
	 column_i(3) <= column_in(7 downto 0);
	 
		gen_column_multiplication: for i in 0 to 3 generate
			temp2_s(i) <= column_i(i) & '0' when column_i(i)(7) = '0' 
			                                 else (column_i(i) & '0') xor b"100011011";
			col2_s(i) <= temp2_s(i)(7 downto 0);

			temp4_s(i) <= col2_s(i) & '0' when col2_s(i)(7) = '0' else (col2_s(i) & '0') xor b"100011011";
			col4_s(i) <= temp4_s(i)(7 downto 0);

			temp8_s(i) <= col4_s(i) & '0' when col4_s(i)(7) = '0' else (col4_s(i) & '0') xor b"100011011";
			col8_s(i) <= temp8_s(i)(7 downto 0);
		end generate gen_column_multiplication;


		column_o(0) <=	(col8_s(0) xor col4_s(0) xor col2_s(0)) xor --0x0E
						(col8_s(1) xor col2_s(1) xor column_i(1)) xor --0x0B
						(col8_s(2) xor col4_s(2) xor column_i(2)) xor --0x0D
						(col8_s(3) xor column_i(3)); --0x09
						
		column_o(1) <=	(col8_s(1) xor col4_s(1) xor col2_s(1)) xor --0x0E
						(col8_s(2) xor col2_s(2) xor column_i(2)) xor --0x0B
						(col8_s(3) xor col4_s(3) xor column_i(3)) xor --0x0D
						(col8_s(0) xor column_i(0)); --0x09

		column_o(2) <=	(col8_s(2) xor col4_s(2) xor col2_s(2)) xor --0x0E
						(col8_s(3) xor col2_s(3) xor column_i(3)) xor --0x0B
						(col8_s(0) xor col4_s(0) xor column_i(0)) xor --0x0D
						(col8_s(1) xor column_i(1)); --0x09

		column_o(3) <=	(col8_s(3) xor col4_s(3) xor col2_s(3)) xor --0x0E
						(col8_s(0) xor col2_s(0) xor column_i(0)) xor --0x0B
						(col8_s(1) xor col4_s(1) xor column_i(1)) xor --0x0D
						(col8_s(2) xor column_i(2)); --0x09
						
 column_out (31 downto 24) <= column_o(0);
  column_out (23 downto 16) <= column_o(1);
  column_out (15 downto 8) <= column_o(2);
  column_out (7 downto 0) <= column_o(3);
  
	end invMix1Column_arch;
