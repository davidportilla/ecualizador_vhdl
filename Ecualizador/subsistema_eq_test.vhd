library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.txt_util.all;
use work.subsistema_eq;
use work.vumetro;

entity subsistema_eq_test is
end subsistema_eq_test;

architecture test of subsistema_eq_test is

  signal clk, rst, eq, car, rev, valid : std_logic;
  signal entrada, salida : std_logic_vector(15 downto 0);
  signal sel_filtro : std_logic_vector(2 downto 0);
  signal sel_nivel : std_logic_vector(3 downto 0);
  signal v0, v1, v2, v3, v4, v5, v6 : std_logic_vector(7 downto 0);
  
  FILE test_in_data: TEXT open READ_MODE is
    "C:\Documents and Settings\David\Escritorio\input.txt";
  
  FILE test_out_data: TEXT open WRITE_MODE is 
    "C:\Documents and Settings\David\Escritorio\output.txt";
  
  begin
    
    SUBSISTEMA : entity work.subsistema_eq
            port map(clk => clk, rst => rst, entrada => entrada, eq => eq,
            car => car, rev => rev, sel_filtro => sel_filtro,
            sel_nivel => sel_nivel, valid => valid, v0 => v0, v1 => v1,
            v2 => v2, v3 => v3, v4 => v4, v5 => v5, v6 => v6, salida => salida);
      
    -- Senal de reset
    reset: PROCESS
    BEGIN
      rst <= '0'; 
      WAIT for 1 ns;
      rst <= '1';
      WAIT for 2 us;
      rst <= '0';
    WAIT;
    END PROCESS reset;
  
    -- Se�al de reloj a 1MHz
    clock: PROCESS
    BEGIN
      FOR i IN 0 TO 100000000 LOOP
        clk <= '1', '0' after 0.5 us; 
        WAIT for 1 us;
      END LOOP;
      WAIT;
    END PROCESS clock;
  
    estimulos: PROCESS (clk)
      variable line : LINE;
      variable string: string(1 to 16);
    BEGIN
      if rising_edge(clk) then
        readline(test_in_data, line);
        read(line, string);
        entrada <= to_std_logic_vector(string); 
      end if;
    END PROCESS estimulos;
    
    control: PROCESS
    BEGIN
      rev <= '0';
      car <= '1';
      eq <= '0';
      
      valid <= '1';
      sel_filtro <= "000";
      sel_nivel <= "0111";
      
      wait for 5 us;
      valid <= '0';
      
      wait;
    END PROCESS control;
    
    writer: PROCESS
      variable line : LINE;
      --variable salida_sfixed : sfixed(0 downto -15);
      --variable salida_real : real;
    BEGIN
      WAIT for 3 us;
      FOR i IN 0 TO 10000000 LOOP
        --salida_sfixed := sfixed(salida);
        --salida_real := to_real(salida_sfixed);
        write(line, salida); --write(line, salida_real);
        writeline(test_out_data, line);
        WAIT for 1 us;
      END LOOP;
    END PROCESS writer;

end test;