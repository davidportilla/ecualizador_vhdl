library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

ENTITY amplificadores IS
  GENERIC(af : std_logic_vector(15 downto 0));
  PORT 
	(
	  clk : in std_logic;
	  rst : in std_logic;
		e0, e1, e2, e3, e4, e5, e6 : in std_logic_vector (15 downto 0); --entradas
		sel_filtro : in std_logic_vector (2 downto 0);
		sel_nivel : in std_logic_vector (3 downto 0);
		valid : in std_logic;
		eq, car, rev : in std_logic;
		-- Salidas para el v�metro (su suma es la salida final)
		f0, f1, f2, f3, f4, f5, f6 : out std_logic_vector (15 downto 0);
		salida : out std_logic_vector (15 downto 0)
	);

END ENTITY;

ARCHITECTURE rtl OF amplificadores IS
  
  signal g0, g1, g2, g3, g4, g5, g6 : std_logic_vector (15 downto 0);
  signal s0, s1, s2, s3, s4, s5, s6 : std_logic_vector (15 downto 0);
  signal sum0, sum1, sum2, sum3, sum4, sum5, sum6 : std_logic_vector (15 downto 0);
  signal sumaux1, sumaux2, sumaux3, sumaux4, sumaux5: std_logic_vector (15 downto 0);
  signal suma : std_logic_vector (15 downto 0);
  
BEGIN
  
  AMPLI0 : entity work.multiplicador 
           port map(a => e0, b => g0, rst => rst, producto => s0);
  AMPLI1 : entity work.multiplicador 
           port map(a => e1, b => g1, rst => rst, producto => s1);       
  AMPLI2 : entity work.multiplicador 
           port map(a => e2, b => g2, rst => rst, producto => s2);
  AMPLI3 : entity work.multiplicador 
           port map(a => e3, b => g3, rst => rst, producto => s3);
  AMPLI4 : entity work.multiplicador 
           port map(a => e4, b => g4, rst => rst, producto => s4);         
  AMPLI5 : entity work.multiplicador 
           port map(a => e5, b => g5, rst => rst, producto => s5);
  AMPLI6 : entity work.multiplicador 
           port map(a => e6, b => g6, rst => rst, producto => s6);
  
  SUMADOR1 : entity work.sum_sfixed 
             port map(a => sum0, b => sum1, rst => rst, suma => sumaux1);
	SUMADOR2 : entity work.sum_sfixed
	           port map(a => sum2, b => sum3, rst => rst, suma => sumaux2);
	SUMADOR3 : entity work.sum_sfixed 
	           port map(a => sum4, b => sum5, rst => rst, suma => sumaux3);
	SUMADOR4 : entity work.sum_sfixed 
	           port map(a => sumaux1, b => sumaux2, rst => rst, suma => sumaux4);
	SUMADOR5 : entity work.sum_sfixed 
	           port map(a => sumaux3, b => sum6, rst => rst, suma => sumaux5);
	SUMADOR6 : entity work.sum_sfixed 
	           port map(a => sumaux4, b => sumaux5, rst => rst, suma => suma);
	
	AMPLIF : entity work.multiplicador 
           port map(a => suma, b => af, rst => rst, producto => salida);
	
  sum: PROCESS (e0, e1, e2, e3, e4, e5, e6, s0, s1, s2, s3, s4, s5, s6)
    BEGIN
      if ((car = '1') or (rev = '1')) then
        -- sumar de e0 a e6
        sum0 <= e0;
        sum1 <= e1;
        sum2 <= e2;
        sum3 <= e3;
        sum4 <= e4;
        sum5 <= e5;
        sum6 <= e6;
      elsif (eq = '1') then
        -- sumar de s0 a s6
        sum0 <= s0;
        sum1 <= s1;
        sum2 <= s2;
        sum3 <= s3;
        sum4 <= s4;
        sum5 <= s5;
        sum6 <= s6; 
      else
        null;
      end if;
  END PROCESS sum;

  decoder: PROCESS (sel_filtro, sel_nivel, valid, rst)
       variable ganancia : std_logic_vector(15 downto 0);
	     begin

	     if (rising_edge(rst) or rst = '1') then
	       g0 <= "0000000000000000";
	       g1 <= "0000000000000000";
	       g2 <= "0000000000000000";
	       g3 <= "0000000000000000";
	       g4 <= "0000000000000000";
	       g5 <= "0000000000000000";
	       g6 <= "0000000000000000";
	     else     
         if valid='1' then
           case sel_nivel is
           when "0000" => ganancia := "0000010000000000"; -- 0: g = 1024
           when "0001" => ganancia := "0000001100010110"; -- 1: g = 790
           when "0010" => ganancia := "0000001001100010"; -- 2: g = 610
           when "0011" => ganancia := "0000000111010111"; -- 3: g = 471
           when "0100" => ganancia := "0000000101101100"; -- 4: g = 364
           when "0101" => ganancia := "0000000100011001"; -- 5: g = 281
           when "0110" => ganancia := "0000000011011001"; -- 6: g = 217
           when "0111" => ganancia := "0000000010100111"; -- 7: g = 167
           when "1000" => ganancia := "0000000010000001"; -- 8: g = 129
           when "1001" => ganancia := "0000000001100011"; -- 9: g = 99
           when "1010" => ganancia := "0000000001001101"; --10: g = 77
           when "1011" => ganancia := "0000000000111011"; --11: g = 59
           when "1100" => ganancia := "0000000000101110"; --12: g = 46
           when "1101" => ganancia := "0000000000100011"; --13: g = 35
           when "1110" => ganancia := "0000000000011011"; --14: g = 27
           when "1111" => ganancia := "0000000000010101"; --15: g = 21  
           when others => null;
         end case;
         
         case sel_filtro is
           when "000" => g0 <= ganancia;
           when "001" => g1 <= ganancia;
           when "010" => g2 <= ganancia;
           when "011" => g3 <= ganancia;
           when "100" => g4 <= ganancia;
           when "101" => g5 <= ganancia;
           when "110" => g6 <= ganancia;  
           when others => null;
         end case;
         
         end if;  
           
      end if;
  END PROCESS decoder;
  
  salidas_filtros: process (sum0, sum1, sum2, sum3, sum4, sum5, sum6) is
  begin
    f0 <= sum0;
    f1 <= sum1;
    f2 <= sum2;
    f3 <= sum3;
    f4 <= sum4;
    f5 <= sum5;
    f6 <= sum6;
  end process salidas_filtros; 
  
END rtl;