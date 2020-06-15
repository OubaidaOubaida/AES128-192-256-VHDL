LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;


entity shift256dec is
  Port (
         clk: in std_logic;
         user_key: in std_logic_vector(31 downto 0);
         plaintext: in std_logic_vector(31 downto 0);
         ciphertext: in std_logic_vector(127 downto 0);
         txt_out: inout std_logic_vector(127 downto 0);
         key_i: inout std_logic_vector(255 downto 0);
         final_out: inout std_logic_vector(127 downto 0)
        );
end shift256dec;

architecture Behavioral of shift256dec is

signal count  : std_logic_vector (5 downto 0):= "000000";

begin

  K_proc : process(clk)
  begin
    if rising_edge(clk) then
       if  ( unsigned(count)  < 8) then
      key_i    <=  key_i(223 downto 0) & user_key  ;
      txt_out <=  txt_out(95 downto 0) & plaintext ;
        count  <= std_logic_vector(unsigned(count)+1);
        
      elsif ( unsigned(count)  >= 8 ) and ( unsigned(count)  < 34  )  then
        count  <= std_logic_vector(unsigned(count)+1);
        key_i <= key_i;
        txt_out <= txt_out;

      elsif ( unsigned(count)  = 34) then
        count  <= std_logic_vector(unsigned(count)+1);
          final_out <= ciphertext ;
               
        elsif (unsigned(count)  > 34)  then
        count  <= std_logic_vector(unsigned(count)+1);
          final_out <= final_out(95 downto 0) & final_out(127 downto 96) ; 
   
    end if;
    end if;
  end process;

end Behavioral;
