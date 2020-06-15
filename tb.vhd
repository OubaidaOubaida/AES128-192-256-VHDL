library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity aes_tb is
end;

architecture bench of aes_tb is

  component aes
  -- generic (key_len : positive := 127);
  -- generic (key_len : positive := 191);
  generic (key_len : positive := 255;
          --Encrypt : bit :='0' FOR DECRYPTION
            Encrypt : bit :='1');
  PORT(
      plaintext	:   IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      user_key	:   IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      cipher_text	:   OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      clk		:   IN	STD_LOGIC;
      reset	:   IN	STD_LOGIC
      );
  end component;

  signal plaintext: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal user_key: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal cipher_text: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal clk: STD_LOGIC :='1';
  signal reset: STD_LOGIC :='0';

 constant clk_i_period : time := 2 ns;

begin
uut: aes generic map ( key_len     => 127 ,
  --uut: aes generic map ( key_len     => 191 )
--  uut: aes generic map ( key_len     => 255,
                           encrypt     => '1')
              port map ( plaintext   => plaintext,
                         user_key    => user_key,
                         cipher_text => cipher_text,
                         clk         => clk,
                         reset       => reset );

  clk_i_process :process
   begin
		clk <= '1';
		wait for clk_i_period/2;
		clk <= '0';
		wait for clk_i_period/2;
   end process;
   
-----------------------------------------------------------
    --      Testing AES 128 Encryption
-----------------------------------------------------------  
process
begin
wait for clk_i_period; 
plaintext <= x"00112233"; 
user_key    <= x"00010203"; 

wait for clk_i_period; 
plaintext <= x"44556677"; 
user_key    <= x"04050607"; 

wait for clk_i_period; 
plaintext <= x"8899aabb"; 
user_key    <= x"08090a0b"; 

wait for clk_i_period; 
plaintext <= x"ccddeeff"; 
user_key    <= x"0c0d0e0f"; 

end process;


-----------------------------------------------------------
 --      Testing AES 192 Encryption
 -----------------------------------------------------------
 
--process
--begin
--wait for clk_i_period; 
----plaintext   <= x"00000000"; 
--user_key    <= x"00010203"; 

--wait for clk_i_period; 
----plaintext <= x"00000000"; 
--user_key    <= x"04050607"; 

--wait for clk_i_period; 
--plaintext <= x"00112233"; 
--user_key    <= x"08090a0b"; 

--wait for clk_i_period; 
--plaintext <= x"44556677"; 
--user_key    <= x"0c0d0e0f"; 

--wait for clk_i_period; 
--plaintext <= x"8899aabb"; 
--user_key    <= x"10111213"; 
--wait for clk_i_period; 
--plaintext <= x"ccddeeff"; 
--user_key    <= x"14151617"; 
-- end process;
-----------------------------------------------------------
 --      Testing AES 256 Encryption
 -----------------------------------------------------------
--process
--begin
--wait for clk_i_period; 
----plaintext   <= x"00000000"; 
--user_key    <= x"00010203"; 

--wait for clk_i_period; 
----plaintext <= x"00000000"; 
--user_key    <= x"04050607"; 

--wait for clk_i_period; 
----plaintext <= x"00112233"; 
--user_key    <= x"08090a0b"; 

--wait for clk_i_period; 
----plaintext <= x"44556677"; 
--user_key    <= x"0c0d0e0f"; 

--wait for clk_i_period; 
--plaintext <= x"00112233"; 
--user_key    <= x"10111213";
 
--wait for clk_i_period; 
--plaintext <= x"44556677"; 
--user_key    <= x"14151617"; 

--wait for clk_i_period; 
--plaintext <= x"8899aabb"; 
--user_key    <= x"18191a1b"; 

--wait for clk_i_period; 
--plaintext <= x"ccddeeff"; 
--user_key    <= x"1c1d1e1f";
--end process;

-----------------------------------------------------------
 --      Testing AES 128 Decryption
 -----------------------------------------------------------

--process
--begin
--wait for clk_i_period; 
--plaintext <= x"69c4e0d8"; 
--user_key    <= x"00010203"; 

--wait for clk_i_period; 
--plaintext <= x"6a7b0430"; 
--user_key    <= x"04050607"; 

--wait for clk_i_period; 
--plaintext <= x"d8cdb780"; 
--user_key    <= x"08090a0b"; 

--wait for clk_i_period; 
--plaintext <= x"70b4c55a"; 
--user_key    <= x"0c0d0e0f"; 

--end process;

-----------------------------------------------------------
 --      Testing AES 192 Decryption
 -----------------------------------------------------------
--process
-- begin
-- wait for clk_i_period; 
-- user_key    <= x"00010203"; 
 
-- wait for clk_i_period; 
-- user_key    <= x"04050607"; 
 
-- wait for clk_i_period; 
-- plaintext <= x"dda97ca4"; 
-- user_key    <= x"08090a0b"; 
 
-- wait for clk_i_period; 
-- plaintext <= x"864cdfe0"; 
-- user_key    <= x"0c0d0e0f"; 
 
-- wait for clk_i_period; 
-- plaintext <= x"6eaf70a0"; 
-- user_key    <= x"10111213"; 
-- wait for clk_i_period; 
-- plaintext <= x"ec0d7191"; 
-- user_key    <= x"14151617"; 
--  end process;

-----------------------------------------------------------
 --      Testing AES 256 decryption
 -----------------------------------------------------------
--process
--begin
--wait for clk_i_period; 
--user_key    <= x"00010203"; 

--wait for clk_i_period; 
--user_key    <= x"04050607"; 

--wait for clk_i_period; 
--user_key    <= x"08090a0b"; 

--wait for clk_i_period; 
--user_key    <= x"0c0d0e0f"; 

--wait for clk_i_period; 
--plaintext <= x"8ea2b7ca"; 
--user_key    <= x"10111213";
 
--wait for clk_i_period; 
--plaintext <= x"516745bf"; 
--user_key    <= x"14151617"; 

--wait for clk_i_period; 
--plaintext <= x"eafc4990"; 
--user_key    <= x"18191a1b"; 

--wait for clk_i_period; 
--plaintext <= x"4b496089"; 
--user_key    <= x"1c1d1e1f";
--end process;


end;