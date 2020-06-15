LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;

ENTITY aes IS
generic (key_len : positive := 127;
--generic (key_len : positive := 191);
--generic (key_len : positive := 255;
-- Encrypt : bit :='1' For encryption test  // bit:='0' For deccryption test
         Encrypt : bit :='1'
           );
PORT(
    plaintext	:   IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    user_key	:   IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    cipher_text	:   OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk		:   IN	STD_LOGIC;
    reset	:   IN	STD_LOGIC
    );
END aes;

ARCHITECTURE beh OF aes IS
--component instantiation

COMPONENT shift128 is
  Port (
         clk: in std_logic;
         user_key: in std_logic_vector(31 downto 0);
         plaintext: in std_logic_vector(31 downto 0);
         ciphertext: in std_logic_vector(127 downto 0);
         txt_out: inout std_logic_vector(127 downto 0);
         key_i: inout std_logic_vector(127 downto 0);
         final_out: inout std_logic_vector(127 downto 0)
        );
END COMPONENT;

COMPONENT shift128dec is
  Port (
         clk: in std_logic;
         user_key: in std_logic_vector(31 downto 0);
         plaintext: in std_logic_vector(31 downto 0);
         ciphertext: in std_logic_vector(127 downto 0);
         txt_out: inout std_logic_vector(127 downto 0);
         key_i: inout std_logic_vector(127 downto 0);
         final_out: inout std_logic_vector(127 downto 0)
        );
END COMPONENT;

COMPONENT shift192 is
  Port (
       clk: in std_logic;
       user_key: in std_logic_vector(31 downto 0);
       plaintext: in std_logic_vector(31 downto 0);
       ciphertext: in std_logic_vector(127 downto 0);
       txt_out: inout std_logic_vector(127 downto 0);
       key_i: inout std_logic_vector(191 downto 0);
       final_out: inout std_logic_vector(127 downto 0)
      );
END COMPONENT;

COMPONENT shift192dec is
  Port (
       clk: in std_logic;
       user_key: in std_logic_vector(31 downto 0);
       plaintext: in std_logic_vector(31 downto 0);
       ciphertext: in std_logic_vector(127 downto 0);
       txt_out: inout std_logic_vector(127 downto 0);
       key_i: inout std_logic_vector(191 downto 0);
       final_out: inout std_logic_vector(127 downto 0)
      );
END COMPONENT;

COMPONENT shift256 is
  Port (
       clk: in std_logic;
       user_key: in std_logic_vector(31 downto 0);
       plaintext: in std_logic_vector(31 downto 0);
       ciphertext: in std_logic_vector(127 downto 0);
       txt_out: inout std_logic_vector(127 downto 0);
       key_i: inout std_logic_vector(255 downto 0);
       final_out: inout std_logic_vector(127 downto 0)
      );
END COMPONENT;

COMPONENT shift256dec is
  Port (
       clk: in std_logic;
       user_key: in std_logic_vector(31 downto 0);
       plaintext: in std_logic_vector(31 downto 0);
       ciphertext: in std_logic_vector(127 downto 0);
       txt_out: inout std_logic_vector(127 downto 0);
       key_i: inout std_logic_vector(255 downto 0);
       final_out: inout std_logic_vector(127 downto 0)
      );
END COMPONENT;

COMPONENT round 
PORT(
    e_in	:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key		:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    last_mux_sel:   IN STD_LOGIC;
    d_out	:   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;

COMPONENT invRound 
PORT(
    e_in	:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key		:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    last_mux_sel:   IN STD_LOGIC;
    d_out	:   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;


COMPONENT key_schedule_128 
PORT(
    clk		        :   IN  STD_LOGIC;
    reset	        :   IN  STD_LOGIC;
    key_in	        :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key_out	        :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    key_reg_mux_sel :   IN  STD_LOGIC;
    round_constant  :	IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    load_key_reg    :	IN  STD_LOGIC
    );
END COMPONENT;

COMPONENT key_schedule_192 is
    Port (  clk		        :   IN  STD_LOGIC;
            reset           :   IN  STD_LOGIC;
            key_in          :   IN  STD_LOGIC_VECTOR(191 DOWNTO 0);
            key_out         :   OUT STD_LOGIC_VECTOR(191 DOWNTO 0);
            key_reg_mux_sel :   IN  STD_LOGIC;
            round_constant  :    IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            load_key_reg    :    IN  STD_LOGIC
  );
END COMPONENT;

COMPONENT key_schedule_256 IS
PORT(
    clk		    :   IN  STD_LOGIC;
    reset	    :   IN  STD_LOGIC;
    key_in	    :   IN  STD_LOGIC_VECTOR(255 DOWNTO 0);
    key_out	    :   OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    key_reg_mux_sel :   IN  STD_LOGIC;
    round_constant  :	IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    load_key_reg    :	IN  STD_LOGIC
    );
    
END COMPONENT;

COMPONENT control_128

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
END COMPONENT;

COMPONENT control_DEC_128

PORT(
    reset	    :   IN  STD_LOGIC;
    clk		    :   IN  STD_LOGIC;
    data_reg_mux_sel:   OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    load_data_reg   :   OUT STD_LOGIC;
    key_reg_mux_sel :   OUT STD_LOGIC;
    RE             : OUT STD_LOGIC;
    WE              :OUT STD_LOGIC;
    Read_Addr   :    OUT natural ;
    Write_Addr :     OUT natural ; 
    round_const	    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    last_mux_sel    :	OUT STD_LOGIC;
    load_key_reg    :	OUT STD_LOGIC
   );
END COMPONENT;

COMPONENT control_192

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
END COMPONENT;

COMPONENT control_DEC_192

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
END COMPONENT;


COMPONENT control_256

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
END COMPONENT;



COMPONENT control_DEC_256

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
END COMPONENT;

COMPONENT SRAM128 

port(
       Clock   :		in std_logic;
       RE      :		in std_logic;	
       WE          :	in std_logic;		
       Read_Addr   :    in natural ;
       Write_Addr :     in natural ; 
       Data_in    :     in std_logic_vector(127 downto 0);
       Data_out   :     out std_logic_vector(127 downto 0)
    );
END COMPONENT;

COMPONENT SRAM192 

port(
       Clock   :		in std_logic;
       RE      :		in std_logic;	
       WE          :	in std_logic;		
       Read_Addr   :    in natural ;
       Write_Addr :     in natural ; 
       Data_in    :     in std_logic_vector(191 downto 0);
       Data_out   :     out std_logic_vector(127 downto 0)
    );
END COMPONENT;

COMPONENT SRAM256 

port(
       Clock   :		in std_logic;
       RE      :		in std_logic;	
       WE          :	in std_logic;		
       Read_Addr   :    in natural ;
       Write_Addr :     in natural ; 
       Data_in    :     in std_logic_vector(255 downto 0);
       Data_out   :     out std_logic_vector(127 downto 0)
    );
END COMPONENT;
--internal signal instantiation
SIGNAL data_reg_in, data_reg_out, round0_out, round1_10_out, txt_out, ciphertext,final_out, keyramout, key_in : STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL key_reg_mux_sel , RE, WE: std_logic;
SIGNAL round_constant : std_logic_vector(7 downto 0);
SIGNAL data_reg_mux_sel : std_logic_vector(1 downto 0);
SIGNAL load_data_reg, load_key_reg, last_mux_sel : std_logic;
signal readADD, wADD : natural;

SIGNAL key_i, key :std_logic_vector(key_len downto 0); 

--------------------------------------------
BEGIN

shift1ecn: 
 if key_len = 127 and Encrypt = '1' generate
 shift_128: shift128 

  PORT MAP (
         clk=> clk,
         user_key => user_key,
         plaintext =>plaintext,
         ciphertext => ciphertext,
         txt_out => txt_out,
         key_i => key_i,
         final_out => final_out
        );
  end generate;
  
  shift1dec: 
   if key_len = 127 and Encrypt = '0' generate
   shift_128: shift128dec 
  
    PORT MAP (
           clk=> clk,
           user_key => user_key,
           plaintext =>plaintext,
           ciphertext => ciphertext,
           txt_out => txt_out,
           key_i => key_i,
           final_out => final_out
          );
    end generate;
  
  shift2: 
   if key_len = 191 and Encrypt = '1' generate
   shift_192: shift192 
    PORT MAP (
           clk=> clk,
           user_key => user_key,
           plaintext =>plaintext,
           ciphertext => ciphertext,
           txt_out => txt_out,
           key_i => key_i,
          final_out => final_out
          );
    end generate;
    
      shift2dec: 
     if key_len = 191 and Encrypt = '0' generate
     shift_192: shift192dec
      PORT MAP (
             clk=> clk,
             user_key => user_key,
             plaintext =>plaintext,
             ciphertext => ciphertext,
             txt_out => txt_out,
             key_i => key_i,
            final_out => final_out
            );
      end generate;
    
    shift3: 
     if key_len = 255 and Encrypt = '1' generate
     shift_256: shift256 
      PORT MAP (
             clk=> clk,
             user_key => user_key,
             plaintext =>plaintext,
             ciphertext => ciphertext,
             txt_out => txt_out,
             key_i => key_i,
            final_out => final_out
            );
      end generate;
         
    shift3dec: 
       if key_len = 255 and Encrypt = '0' generate
       shift_256: shift256dec 
        PORT MAP (
               clk=> clk,
               user_key => user_key,
               plaintext =>plaintext,
               ciphertext => ciphertext,
               txt_out => txt_out,
               key_i => key_i,
              final_out => final_out
              );
        end generate;
   cipher_text <= final_out (127 downto 96);
  
  
--mux to the register input
WITH data_reg_mux_sel SELECT
data_reg_in <=   round0_out WHEN "00",
		      round1_10_out WHEN "01",
		          txt_out WHEN OTHERS;
		          
WITH key_len SELECT
key_in <=                  key_i WHEN 127,
           key_i(191 downto 64)  WHEN 191,
          key_i (255 downto 128) WHEN 255,
                    (others=>'0') WHEN OTHERS;
				         			  
--1st Round
with encrypt select 
round0_out <= txt_out XOR key_in when '1',
              txt_out XOR keyramout when '0';

--2nd to 10th Rounds, where same hareware gets reused
rounds:
if encrypt ='1' generate
layers: round
PORT MAP(
	e_in	    =>  data_reg_out, 
	key	    =>  keyramout,
	last_mux_sel=>  last_mux_sel,
	d_out	    =>  round1_10_out  
	);
end generate;

invrounds:
if encrypt ='0' generate
invlayers: invround
PORT MAP(
	e_in	    =>  data_reg_out, 
	key	    =>  keyramout,
	last_mux_sel=>  last_mux_sel,
	d_out	    =>  round1_10_out  
	);
end generate;	
	
--register to store values after each rounds	
data_register:
PROCESS(clk, reset, load_data_reg, data_reg_in)
BEGIN
    IF(reset='1') THEN
	data_reg_out <= (others =>'0'); 
    ELSIF(clk'event AND clk='1') THEN
	    IF(load_data_reg='1') THEN
		data_reg_out <= data_reg_in;
	    END IF;
    END IF;	
END PROCESS data_register;
    
key_len_128:
if key_len = 127  generate
		
--key generator for each rounds
key_generator: key_schedule_128
PORT MAP(
	clk		=>  clk,
	reset		=>  reset,
	key_in		=>  key_i,	
	key_out		=>  key,
	key_reg_mux_sel	=>  key_reg_mux_sel,
	round_constant	=>  round_constant,
	load_key_reg	=>  load_key_reg
	);	
end generate key_len_128;

    
key_len_192:
if key_len =191  generate
		
--key generator for each rounds
key_generator: key_schedule_192
PORT MAP(
	clk		=>  clk,
	reset		=>  reset,
	key_in		=>  key_i,	
	key_out		=>  key,
	key_reg_mux_sel	=>  key_reg_mux_sel,
	round_constant	=>  round_constant,
	load_key_reg	=>  load_key_reg
	);
	
	end generate key_len_192;
	
        
key_len_256:
if key_len = 255 generate
        
--key generator for each rounds
key_generator: key_schedule_256
PORT MAP(
    clk        =>  clk,
    reset        =>  reset,
    key_in        =>  key_i,    
    key_out        =>  key,
    key_reg_mux_sel    =>  key_reg_mux_sel,
    round_constant    =>  round_constant,
    load_key_reg    =>  load_key_reg
    );
    
    end generate key_len_256;
	
kerRAM128: 
if key_len = 127 generate 
 keyRAM: SRAM128 

 PORT MAP(
      Clock => clk ,	
      RE => RE,
      WE => WE,
      Read_Addr=>readADD ,
      Write_Addr => wADD,
      Data_in =>key ,
      Data_out => keyramout
 );	
 
 end generate;
 
 kerRAM192: 
if key_len = 191 generate 
 keyRAM: SRAM192 

 PORT MAP(
      Clock => clk ,	
      RE => RE,
      WE => WE,
      Read_Addr=>readADD ,
      Write_Addr => wADD,
      Data_in =>key ,
      Data_out => keyramout
 );	
 
 end generate;
 
 kerRAM256: 
if key_len = 255 generate 
 keyRAM: SRAM256 

 PORT MAP(
      Clock => clk ,	
      RE => RE,
      WE => WE,
      Read_Addr=>readADD ,
      Write_Addr => wADD,
      Data_in =>key ,
      Data_out => keyramout
 );	
 
 end generate;
--system control

control128:
if key_len = 127 and Encrypt = '1' generate	
contrl: control_128

PORT MAP(
	reset		=> reset,   
	clk		=> clk,
	data_reg_mux_sel=> data_reg_mux_sel,
	load_data_reg   => load_data_reg,
	key_reg_mux_sel	=> key_reg_mux_sel,
	RE => RE,
    WE => WE,
	Write_Addr  => wADD,
	Read_Addr => readADD,
	round_const	=> round_constant,
	last_mux_sel	=> last_mux_sel,
	load_key_reg	=> load_key_reg
	);
end generate;	
	
control192:
if key_len = 191 and Encrypt = '1' generate	
contrl: control_192

PORT MAP(
	reset		=> reset,   
	clk		=> clk,
	data_reg_mux_sel=> data_reg_mux_sel,
	load_data_reg   => load_data_reg,
	key_reg_mux_sel	=> key_reg_mux_sel,
	RE => RE,
    WE => WE,
	Write_Addr  => wADD,
	Read_Addr => readADD,
	round_const	=> round_constant,
	last_mux_sel	=> last_mux_sel,
	load_key_reg	=> load_key_reg
	);
end generate;

control256:
if key_len = 255 and Encrypt = '1' generate	
contrl: control_256

PORT MAP(
	reset		=> reset,   
	clk		=> clk,
	data_reg_mux_sel=> data_reg_mux_sel,
	load_data_reg   => load_data_reg,
	key_reg_mux_sel	=> key_reg_mux_sel,
	RE => RE,
    WE => WE,
	Write_Addr  => wADD,
	Read_Addr => readADD,
	round_const	=> round_constant,
	last_mux_sel	=> last_mux_sel,
	load_key_reg	=> load_key_reg
	);
end generate;

control128DEC:
if key_len = 127 and Encrypt = '0' generate	
contrl: control_DEC_128
PORT MAP(
	reset		=> reset,   
	clk		=> clk,
	data_reg_mux_sel=> data_reg_mux_sel,
	load_data_reg   => load_data_reg,
	key_reg_mux_sel	=> key_reg_mux_sel,
	RE => RE,
    WE => WE,
	Write_Addr  => wADD,
	Read_Addr => readADD,
	round_const	=> round_constant,
	last_mux_sel	=> last_mux_sel,
	load_key_reg	=> load_key_reg
	);
end generate;

control191DEC:
if key_len = 191 and Encrypt = '0' generate	
contrl: control_DEC_192
PORT MAP(
	reset		=> reset,   
	clk		=> clk,
	data_reg_mux_sel=> data_reg_mux_sel,
	load_data_reg   => load_data_reg,
	key_reg_mux_sel	=> key_reg_mux_sel,
	RE => RE,
    WE => WE,
	Write_Addr  => wADD,
	Read_Addr => readADD,
	round_const	=> round_constant,
	last_mux_sel	=> last_mux_sel,
	load_key_reg	=> load_key_reg
	);
end generate;

control256dec:
if key_len = 255 and Encrypt = '0' generate	
contrl: control_DEC_256

PORT MAP(
	reset		=> reset,   
	clk		=> clk,
	data_reg_mux_sel=> data_reg_mux_sel,
	load_data_reg   => load_data_reg,
	key_reg_mux_sel	=> key_reg_mux_sel,
	RE => RE,
    WE => WE,
	Write_Addr  => wADD,
	Read_Addr => readADD,
	round_const	=> round_constant,
	last_mux_sel	=> last_mux_sel,
	load_key_reg	=> load_key_reg
	);
end generate;
--encryption output
ciphertext <= data_reg_out;

END beh;
