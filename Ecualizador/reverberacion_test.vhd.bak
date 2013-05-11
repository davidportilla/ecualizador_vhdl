library ieee;
use ieee.std_logic_1164.all;
use work.reverberacion;

entity reverberacion_test is
end reverberacion_test;

architecture test of reverberacion_test is

  signal clk, rst, eq, car, rev : std_logic;
  signal entrada, salida, atenuacion : std_logic_vector(15 downto 0);
  signal retardo : std_logic_vector(7 downto 0);
  
  begin
  
  REVERBERACION : entity work.reverberacion
    GENERIC MAP (atenuacion => "0000000100000000", retardo => "00001000")
    PORT MAP (clk => clk, rst => rst, eq => eq, car => car, rev => rev,
    entrada => entrada, salida => salida);

    -- Reloj a 100MHz
    reloj : process
      begin
        for i in 0 to 100000000 loop
          clk <= '0', '1' after 5 ns; 
          wait for 10 ns;
         end loop;
        wait;
    end process reloj;
    
    -- Señal de reset
    reset : process
      begin
        rst <= '0'; 
        wait for 5 ns;
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait;
    end process reset;
    
    -- Estímulos
    estimulos : process
      begin
        entrada <= (others => '0');
        retardo <= "00001000"; -- 8 muestras de retardo
        atenuacion <= "0000000010000000";
        rev <= '1';
        car <= '0';
        eq <= '0';
        
        wait for 45 ns;
        entrada <= "0000100000000000"; -- muestra 1
        wait for 10 ns;
        entrada <= "0000100011100000"; -- muestra 2, 3, 4, 5
        wait for 40 ns;
        entrada <= "0000100000000001"; -- muestra 6
        wait for 10 ns;
        entrada <= "1100100000000000"; -- muestra 7
        wait for 10 ns;
        entrada <= "0000111111110000"; -- muestra 8
        wait for 10 ns;
        entrada <= "0000100000000111"; -- muestra 9
        wait for 10 ns;
        entrada <= "1111111111111111"; -- muestra 10, 11, 12...
        wait;
        
    end process estimulos;
  
end test;