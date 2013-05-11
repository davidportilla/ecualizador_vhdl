use work.filtro;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.txt_util.all;
use ieee.fixed_pkg.all;

ENTITY filtro_test IS
END filtro_test;

ARCHITECTURE test OF filtro_test IS
  
  SIGNAL clk, rst: std_logic;
  SIGNAL entrada : std_logic_vector (15 downto 0);
	SIGNAL	b0, b1, b2, a1, a2, G : std_logic_vector (15 downto 0);
	SIGNAL	salida		: std_logic_vector (15 downto 0);
	
	-- Señales intermedias
	--signal x1   : std_logic_vector (15 downto 0);
  --signal xr1  : std_logic_vector (15 downto 0);
  --signal x2   : std_logic_vector (15 downto 0);
  --signal xr2  : std_logic_vector (15 downto 0);
  --signal x3   : std_logic_vector (15 downto 0);
  --signal y    : std_logic_vector (15 downto 0);
  --signal z    : std_logic_vector (15 downto 0);
  --signal xr11 : std_logic_vector (15 downto 0);
  --signal xr12 : std_logic_vector (15 downto 0);
  --signal xr21 : std_logic_vector (15 downto 0);
  --signal xr22 : std_logic_vector (15 downto 0);
  
  FILE test_in_data: TEXT open READ_MODE is
    "C:\Documents and Settings\David\Escritorio\input.txt";
  
  FILE test_out_data: TEXT open WRITE_MODE is 
    "C:\Documents and Settings\David\Escritorio\output.txt";
  
  BEGIN
  
  FILTRO: ENTITY work.filtro
       GENERIC MAP
       (b0 => "0000010000000000", b1 => "0000000000000000",
        b2 => "1111110000000000", a1 => "0000011111101101",
        a2 => "1111110000010010",  G => "0000010000000000")
       PORT MAP(clk => clk, rst => rst, entrada => entrada,
       salida => salida--, salidax1 => x1, salidax2 => x2, salidax3 => x3,
       --saliday => y, salidaz => z, salidaxr11 => xr11, salidaxr12 => xr12,
       --salidaxr21 => xr21, salidaxr22 => xr22, salidaxr1 => xr1, salidaxr2 => xr2
       );
  
  -- Señal de reloj a 1MHz
  clock: PROCESS
  BEGIN
    FOR i IN 0 TO 100000000 LOOP
      clk <= '1', '0' after 0.5 us; 
      WAIT for 1 us;
    END LOOP;
    WAIT;
  END PROCESS clock;
  
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
  
END test;