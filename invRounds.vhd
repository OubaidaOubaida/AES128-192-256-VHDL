LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY invRound IS
PORT(
    e_in    :	IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key	    :	IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    last_mux_sel:	IN  STD_LOGIC;
    d_out   :	OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END invRound;

ARCHITECTURE beh OF invRound IS
--component instantiation
COMPONENT invsub_bytes is
      port ( sub_in  : in std_logic_vector (127 downto 0);
             sub_out : out std_logic_vector (127 downto 0)
		    );
END COMPONENT;

COMPONENT inv_shift_row IS
PORT(
    stateIn     :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    stateOut    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;

COMPONENT addRoundKey is
	port ( data_i : in  std_logic_vector (127 downto 0);
			key_i : in   std_logic_vector (127 downto 0);
			data_o  : out  std_logic_vector (127 downto 0)
			);
END COMPONENT;

COMPONENT invMixColumns is 
	port(
		data_i:in std_logic_vector(127 downto 0);
		data_o:out std_logic_vector(127 downto 0)
	);
END COMPONENT;
--internal signal instantiation
SIGNAL invSubByte_out, invShiftrow_out, invMixcolumn_out, addKey: STD_LOGIC_VECTOR(127 DOWNTO 0);

BEGIN
 

	    
invShiftRow:  inv_shift_row
PORT MAP(
	stateIn => e_in,
	stateout => invShiftrow_out
	);
	
invsubByte:  invsub_bytes
    PORT MAP(
         sub_in => invShiftrow_out,
         sub_out => invSubByte_out
         );
	
addRoundKeyy: addRoundKey 
   PORT MAP ( data_i => invSubByte_out  ,
                key_i  => key  ,
                data_o => addKey
                );
invMixColumn: invMixColumns
PORT MAP(   
	data_i => addKey,
	data_o => invMixcolumn_out
	);
	
	
--mux to skip mix column operation
WITH last_mux_sel SELECT d_out <= invMixcolumn_out WHEN '0',
	                                  addKey WHEN OTHERS;
	                                 
	                               

END beh;			    
			 
