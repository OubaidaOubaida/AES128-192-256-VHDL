LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ALL;

ENTITY inv_shift_row IS
PORT(
    stateIn     :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    stateOut    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END inv_shift_row;

ARCHITECTURE beh OF inv_shift_row IS

BEGIN
  
  stateOut(127 downto 120) <= stateIn(127 downto 120);                    -- no shift on first row
  stateOut(95 downto 88) <= stateIn(95 downto 88);                    -- no shift on first row
  stateOut(63 downto 56) <= stateIn(63 downto 56);                    -- no shift on first row
  stateOut(31 downto 24) <= stateIn(31 downto 24);                    -- no shift on first row
  
  stateOut(87 downto 80) <= stateIn(119 downto 112);                    -- << 1
  stateOut(55 downto 48) <= stateIn(87 downto 80);                    -- << 1
  stateOut(23 downto 16) <= stateIn(55 downto 48);                    -- << 1
  stateOut(119 downto 112) <= stateIn(23 downto 16);                    -- << 1
  
  stateOut(47 downto 40) <= stateIn(111 downto 104);                    -- << 2
  stateOut(15 downto 8) <= stateIn(79 downto 72);                    -- << 2
  stateOut(111 downto 104) <= stateIn(47 downto 40);                    -- << 2
  stateOut(79 downto 72) <= stateIn(15 downto 8);                    -- << 2
  
  stateOut(7 downto 0) <= stateIn(103 downto 96);                    -- >> 3
  stateOut(103 downto 96) <= stateIn(71 downto 64);                    -- >> 3
  stateOut(71 downto 64) <= stateIn(39 downto 32);                    -- >> 3
  stateOut(39 downto 32) <= stateIn(7 downto 0);                    -- >> 3
END beh;			    

