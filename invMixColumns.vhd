library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity invMixColumns is 
	port(
		data_i:in std_logic_vector(127 downto 0);
		data_o:out std_logic_vector(127 downto 0)
	);
end invMixColumns;

architecture invMixColumns_arch of invMixColumns is
 -----------------------------------------------------------------------------
 -- Component declarations
 -----------------------------------------------------------------------------
	component invMix1Column is 
	port(
        column_in: in std_logic_vector(31 downto 0);
        column_out: out std_logic_vector(31 downto 0)
    );
		end component invMix1Column;
		

 -----------------------------------------------------------------------------
 -- Component instantiations
 -----------------------------------------------------------------------------
	begin


		column0_operation: invMix1Column port map(
        column_in=> data_i (127 downto 96),
        column_out => data_o(127 downto 96)
		);

		column1_operation: invMix1Column port map(
        column_in=> data_i (95 downto 64),
        column_out => data_o(95 downto 64)
		);

		column2_operation: invMix1Column port map(
        column_in=> data_i (63 downto 32),
        column_out => data_o(63 downto 32)
		);

		column3_operation: invMix1Column port map(
        column_in=> data_i (31 downto 0),
        column_out => data_o(31 downto 0)
		);

end invMixColumns_arch;
