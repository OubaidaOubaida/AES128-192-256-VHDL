LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY round IS
PORT(
    e_in    :	IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key	    :	IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    last_mux_sel:	IN  STD_LOGIC;
    d_out   :	OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END round;

ARCHITECTURE beh OF round IS
--component instantiation
COMPONENT sub_bytes is
      port ( sub_in  : in std_logic_vector (127 downto 0);
             sub_out : out std_logic_vector (127 downto 0)
		    );
END COMPONENT;

COMPONENT shift_row 
PORT(
    stateIn     :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    stateOut    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;

COMPONENT mix_column 
PORT(
    mixcolumn_in     :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    mixcolumn_out    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;

COMPONENT addRoundKey is
	port ( data_i : in  std_logic_vector (127 downto 0);
			key_i : in   std_logic_vector (127 downto 0);
			data_o  : out  std_logic_vector (127 downto 0)
			);
END COMPONENT;
--internal signal instantiation
SIGNAL bytesub_out, shiftrow_out, mixcolumn_out, mux_out : STD_LOGIC_VECTOR(127 DOWNTO 0);

BEGIN
 
subByte:  sub_bytes
PORT MAP(
	 sub_in => e_in(127 downto 0),
	 sub_out => bytesub_out(127 downto 0)
	 );
	    
ShiftRow:  shift_row
PORT MAP(
	stateIn => bytesub_out,
	stateout => shiftrow_out
	);
MixColumn: mix_column
PORT MAP(   
	mixcolumn_in => shiftrow_out,
	mixcolumn_out => mixcolumn_out
	);
	
	
--mux to skip mix column operation
WITH last_mux_sel SELECT mux_out <= mixcolumn_out WHEN '0',
	                                 shiftrow_out WHEN OTHERS;
	                                 
addRoundKeyy: addRoundKey 
PORT MAP ( 
       data_i => mux_out  ,
       key_i  => key  ,
       data_o => d_out
          );	                                 


END beh;			    
			 
