library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;
use work.banco_filtros;
use work.amplificadores;
use work.reverberacion;
use work.vumetro;

ENTITY subsistema_eq IS
PORT 
	(
	  clk, rst, eq, car, rev : in std_logic;
		entrada : in std_logic_vector (15 downto 0);
		sel_filtro : in std_logic_vector (2 downto 0);
		sel_nivel : in std_logic_vector (3 downto 0);
		valid : in std_logic;
		v0, v1, v2, v3, v4, v5, v6 : out std_logic_vector (7 downto 0); --vumetro
		salida		: out std_logic_vector (15 downto 0)
	);

END ENTITY;

ARCHITECTURE rtl OF subsistema_eq IS
   
  -----Señales intermedias-----
  signal x : std_logic_vector (15 downto 0); -- entrada filtros
  signal x0, x1, x2, x3, x4, x5, x6 : std_logic_vector (15 downto 0); -- salidas filtros
  signal f0, f1, f2, f3, f4, f5, f6 : std_logic_vector (15 downto 0); -- salidas filtros amplificadas
  signal y : std_logic_vector (15 downto 0); -- salida del sistema y entrada a la red de realimentacion
  signal z : std_logic_vector (15 downto 0); -- señal de realimentacion
  
BEGIN
  
  FILTROS: entity work.banco_filtros
          port map(entrada => x, clk => clk, rst => rst, salida0 => x0,
          salida1 => x1, salida2 => x2, salida3 => x3, salida4 => x4,
          salida5 => x5, salida6 => x6);
  
  AMPLIFICADORES: entity work.amplificadores
          generic map(af => "0000010000000000")
          port map(clk => clk, rst => rst, e0 => x0, e1 => x1, e2 => x2,
          e3 => x3, e4 => x4, e5 => x5, e6 => x6, sel_filtro => sel_filtro,
          sel_nivel => sel_nivel, valid => valid, eq => eq, car => car,
          rev => rev, f0 => f0, f1 => f1, f2 => f2, f3 => f3, f4 => f4,
          f5 => f5, f6 => f6, salida => y);
  
  REVERBERACION: entity work.reverberacion
          generic map(atenuacion => "0000000000100000", retardo => "00001000")
          port map(clk => clk, rst => rst, eq => eq, car => car, rev => rev,
          entrada => y, salida => z);
  
  SUMADOR: entity work.sum_sfixed
          port map(a => entrada, b=> z, rst => rst, suma => x);
            
  VUMETRO: entity work.vumetro
          port map(e0 => f0, e1 => f1, e2 => f2, e3 => f3, e4 => f4, e5 => f5,
          e6 => f6, clk => clk, rst => rst, s0 => v0, s1 => v1, s2 => v2,
          s3 => v3, s4 => v4, s5 => v5, s6 => v6);
  
  process (y) is
    begin
      salida <= y;
  end process;
                
END rtl;