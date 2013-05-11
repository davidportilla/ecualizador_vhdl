library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

ENTITY contador_test IS
END contador_test;

ARCHITECTURE test OF contador_test IS

  SIGNAL clk, rst: std_logic;
  SIGNAL enable : std_logic;
	SIGNAL	count	: std_logic_vector (7 downto 0);
	
  BEGIN

  CONTADOR: ENTITY work.contador
       GENERIC MAP(width => 8)
       PORT MAP(clk => clk, rst => rst, enable => enable, count => count);
  
  -- Señal de reloj a 100 MHz
  clock: PROCESS
  BEGIN
    FOR i IN 0 TO 100000000 LOOP
      clk <= '0', '1' after 5 ns; 
      WAIT for 10 ns;
    END LOOP;
    WAIT;
  END PROCESS clock;
  
  estimulos: PROCESS
  BEGIN
    enable <= '0';
    rst <= '0';
    WAIT for 35 ns;
    rst <= '1';
    WAIT for 10 ns;
    enable <= '1';
    rst <= '0';
    WAIT for 50 ns;
    enable <= '0';
    WAIT for 30 ns;
    rst <= '1';
    enable <= '1';
    WAIT;
  END PROCESS estimulos;

END test;