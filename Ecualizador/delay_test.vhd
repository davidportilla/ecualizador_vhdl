use work.filtro;
library ieee;
use ieee.std_logic_1164.all;

ENTITY delay_test IS
END delay_test;

ARCHITECTURE test OF delay_test IS

  SIGNAL clk, rst: std_logic;
  SIGNAL entrada : std_logic_vector (15 downto 0);
	SIGNAL	salida1	: std_logic_vector (15 downto 0);
	SIGNAL	salida2	: std_logic_vector (15 downto 0);
	
  BEGIN
  
  DELAY1: ENTITY work.delay
       PORT MAP(entrada => entrada, clk => clk, rst => rst, salida => salida1);
         
  DELAY2: ENTITY work.delay
       PORT MAP(entrada => salida1, clk => clk, rst => rst, salida => salida2);
  
  -- Señal de reloj a 100 MHz
  clock: PROCESS
  BEGIN
    FOR i IN 0 TO 100000000 LOOP
      clk <= '0', '1' after 5 ns; 
      WAIT for 10 ns;
    END LOOP;
    WAIT;
  END PROCESS clock;
  
  -- Senal de reset
  reset: PROCESS
  BEGIN
    rst <= '0'; 
    WAIT for 7 ns;
    rst <= '1';
    WAIT for 35 ns;
    rst <= '0';
  WAIT;
  END PROCESS reset;
  
  estimulos: PROCESS
  BEGIN
    entrada <= (others => '0');
    WAIT for 35 ns;
    entrada <= "0111111111111111";
    WAIT for 10 ns;
    entrada <= "0000000000000000";
    WAIT;
  END PROCESS estimulos;

END test;