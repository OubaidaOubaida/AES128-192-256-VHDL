LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY control_128 IS
PORT(
    reset	    :   IN  STD_LOGIC;
    clk		    :   IN  STD_LOGIC;
    RE             : OUT STD_LOGIC;
    WE              :OUT STD_LOGIC;
    Read_Addr   :    OUT natural ;
    Write_Addr :     OUT natural ; 
    data_reg_mux_sel:   OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    load_data_reg   :   OUT STD_LOGIC;
    key_reg_mux_sel :   OUT STD_LOGIC;
    round_const	    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    last_mux_sel    :	OUT STD_LOGIC;
    load_key_reg    :	OUT STD_LOGIC
    );
END control_128;

ARCHITECTURE beh OF control_128 IS
--state declaration
TYPE control_type IS (init,  round0_1,round0_2, load_input0, load_input1, load_input2, load_input3, load_input4, round1, round2, round3, round4, round5,
		      round6, round7, round8, round9, round10, round11, round0);  
SIGNAL control_ps, control_ns : control_type;			     

BEGIN
--finite state machine for control
control_FSM:
PROCESS (clk, reset, control_ns, control_ps) 
BEGIN
    IF(reset='1') THEN
	control_ps <= init;
    ELSIF (clk'event AND clk='1') THEN
	control_ps <= control_ns;
    END IF;	
    
	--default outputs
    key_reg_mux_sel  <= '1';            
   data_reg_mux_sel <= "01";
    --round_const <= "00000000";
   
    load_data_reg <= '1';
    last_mux_sel <= '0';
    WE <='0';
    RE<='0';
    --combinatorial part
  CASE control_ps IS
      WHEN init =>        
              key_reg_mux_sel <= '0';
              load_key_reg <= '0';
              load_data_reg <= '0';
              control_ns <= load_input0;

      WHEN load_input0 =>
              data_reg_mux_sel <= "11";
              key_reg_mux_sel <= '0';
              control_ns <= load_input1;
              load_key_reg <= '1';
              load_data_reg <= '0';
             
        WHEN load_input1 =>
              data_reg_mux_sel <= "11";
              key_reg_mux_sel <= '0';         
              load_key_reg <= '1';
              load_data_reg <= '0';
              control_ns <= load_input2;
          
        
    WHEN load_input2 =>
             data_reg_mux_sel <= "11";
             key_reg_mux_sel <= '0';
             load_key_reg <= '1';
             load_data_reg <= '0';
             control_ns <= load_input3;
        
    WHEN load_input3 =>
             data_reg_mux_sel <= "11";
             key_reg_mux_sel <= '0';
             load_key_reg <= '1';
             load_data_reg <= '0';
             control_ns <= load_input4;
             
   	WHEN load_input4 =>
             data_reg_mux_sel <= "11";
             key_reg_mux_sel <= '0';         
             load_key_reg <= '1';
             load_data_reg <= '0';
             control_ns <= round0_1;
                        
	--key0 loaded, XOR key0 and plaintext	
	WHEN round0_1 =>
	        data_reg_mux_sel <= "11";	
			round_const <= "00000001";
			control_ns <= round0_2;
            WE <='1';
            Write_Addr <= 0;	
            load_data_reg <= '0';
	
	--key1, start of normal rounds		
	WHEN round0_2 =>
	        data_reg_mux_sel <= "00"; 	
			round_const <= "00000010";
			control_ns <= round0;
            WE <='1';
            RE<='1';                    
            Write_Addr <= 4; 
            Read_Addr <= 0;  
            load_data_reg <= '0'; 
         	
	--key0	(--key0 loaded, XOR key0 and plaintext)    
	WHEN round0 =>	    
	        data_reg_mux_sel <= "00";
			round_const <= "00000100";
			control_ns <= round1;
            WE <='1';
            RE<='1';    
            Write_Addr <= 8;   
            Read_Addr <= 4;   
             load_data_reg <= '1';     
  
          			
	--key1	    
	WHEN round1 =>	 
	        data_reg_mux_sel <= "01";   
			round_const <= "00001000";
			control_ns <= round2;
            WE <='1';
            RE<='1';    
            Write_Addr <= 12; 
            Read_Addr <= 8;       
           	load_data_reg <= '1'; 	
	--key2	    
	WHEN round2 =>	    
			round_const <= "00010000";
			control_ns <= round3;
            WE <='1';
            RE<='1';    
            Write_Addr <= 16;   
             Read_Addr <= 12;	     
           	 load_data_reg <= '1'; 	
	--key3	    
	WHEN round3 =>	    
			round_const <= "00100000";
			control_ns <= round4;
            WE <='1';
            RE<='1';    
            Write_Addr <= 20; 
             Read_Addr <= 16;	       
            		
	--key4	    
	WHEN round4 =>	    
			round_const <= "01000000";
			control_ns <= round5;
            WE <='1';
            RE<='1';    
            Write_Addr <= 24;           
            Read_Addr <= 20;	
	--key5	    
	WHEN round5 =>	    
			round_const <= "10000000";
			control_ns <= round6;
            WE <='1';
            RE<='1';    
           Write_Addr <= 28;
            Read_Addr <= 24;        
            
	--key6	    
	WHEN round6 =>	   
		    round_const <= "00011011"; 
            control_ns <= round7;
            WE <='1';
            RE<='1';    
           Write_Addr <= 32;   
            Read_Addr <= 28;     
            
	--key7	    
     WHEN round7 =>  
            round_const <= "00110110";
            control_ns <= round8;
            WE <='1';
            RE<='1';  
            Write_Addr <= 36;   
            Read_Addr <= 32;      
            
 	--key8	    
      WHEN round8 =>        
             control_ns <= round9;
             WE <='1';
             RE<='1'; 
             Write_Addr <= 40;     
             Read_Addr <=36;
	--key9	    
       WHEN round9 =>   
             last_mux_sel <= '0';
             control_ns <= round10;
             WE <='0';
             RE<='1'; 
             Read_Addr <= 40; 
            
	--key10	    
        WHEN round10 =>   
             last_mux_sel <= '1';
             control_ns <= round11;
              load_data_reg <= '1';
              RE<='1';
             Read_Addr <= 40; 
            
-- 	--key11	    
    WHEN round11 =>     
                control_ns <= round11;
                load_data_reg <= '0';
          load_data_reg <= '0';
          
       WHEN OTHERS => 
           control_ns <= init;
                   
	END CASE;
END PROCESS control_FSM;    

END beh;
