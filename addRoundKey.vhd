library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addRoundKey is
	port ( data_i : in  std_logic_vector (127 downto 0);
			key_i : in   std_logic_vector (127 downto 0);
			data_o  : out  std_logic_vector (127 downto 0)
			);
			
end addRoundKey;

architecture Behavioral of addRoundKey is

begin

data_o <= key_i xor data_i;

end Behavioral;
