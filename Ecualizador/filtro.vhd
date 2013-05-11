-----------------------------------------------------------------------
--           _ _ _      _ _ _              _ _ _      _ _ _          --
--          |     | x1 |     |     x2     |     | x3 |     |         --
--  entrada-|  b0 |----|  +  |------------|  +  |----|  G  |-salida  --
--          |_ _ _|    |_ _ _|      |     |_ _ _|    |_ _ _|         --
--           MULT1        | SUM1    |        | SUM4   MULT6          --
--                        |      _ _|delay1  |                       --
--           _ _ _ _ _ _ _|     |       |    |_ _ _ _ _ _ _          --
--          |                   |  z^-1 |                  |         --
--          |         _ _ _     |_ _ _ _|    _ _ _         |         --
--       xr1|   xr11 |     |        |y      |     | xr21   |xr2      --
--          |     |--| -a1 |--------|-------|  b1 |--|     |         --
--        __|__   |  |_ _ _|     _ _|delay2 |_ _ _|  |   __|__       --
--       |     |--|   MULT2     |       |    MULT3   |--|     |      --
--       |  +  |                |  z^-1 |               |  +  |      --
--       |_ _ _|--|   _ _ _     |_ _ _ _|    _ _ _   |--|_ _ _|      --
--        SUM2    |  |     |        |z      |     |  |   SUM3        --
--                |--| -a2 |--------|-------|  b2 |--|               --
--              xr12 |_ _ _|                |_ _ _| xr22             --
--                    MULT4                  MULT5                   --
--                                                                   --
--      FILTRO IIR, ORDEN 2, SEGUNDA FORMA DIRECTA (a0 = 1024)       --
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

ENTITY filtro IS
GENERIC (
        b0, b1, b2, a1, a2, G : std_logic_vector (15 downto 0)
        ); --a1 y a2 van negadas
PORT 
	(
	  clk : in std_logic;
	  rst : in std_logic;
		entrada : in std_logic_vector (15 downto 0);
		salida : out std_logic_vector (15 downto 0)
		--salidax1, salidax2, salidax3, saliday, salidaz, salidaxr11,
		--salidaxr12, salidaxr21, salidaxr22, salidaxr1, salidaxr2 : out std_logic_vector (15 downto 0)
	);

END ENTITY;

ARCHITECTURE rtl OF filtro IS
   
  -----Señales intermedias-----
  signal x1   : std_logic_vector (15 downto 0);
  signal xr1  : std_logic_vector (15 downto 0);
  signal x2   : std_logic_vector (15 downto 0);
  signal xr2  : std_logic_vector (15 downto 0);
  signal x3   : std_logic_vector (15 downto 0);
  signal y    : std_logic_vector (15 downto 0);
  signal z    : std_logic_vector (15 downto 0);
  signal xr11 : std_logic_vector (15 downto 0);
  signal xr12 : std_logic_vector (15 downto 0);
  signal xr21 : std_logic_vector (15 downto 0);
  signal xr22 : std_logic_vector (15 downto 0);
  
BEGIN
     	
	-----Se multiplica la entrada por b0----
        MULT1 : entity work.multiplicador 
                port map(a => entrada, b => b0, rst => rst, producto => x1);
        
	-----Se suma la primera realimentacion-----
	      SUM1 : entity work.sum_sfixed
	             port map(a => x1, b => xr1, rst => rst, suma => x2);
	        
	-----Se calculan las señales de realimentacion-----   
	
	     DELAY1 : entity work.delay 
	              port map(entrada => x2, clk => clk, rst => rst, salida => y);

       DELAY2 : entity work.delay 
	              port map(entrada => y, clk => clk, rst => rst, salida => z);
      
	      MULT2 : entity work.multiplicador 
	              port map(a => y, b => a1, rst => rst, producto => xr11);
	      MULT3 : entity work.multiplicador 
	              port map(a => y, b => b1, rst => rst, producto => xr21);
	            
	      MULT4 : entity work.multiplicador 
	              port map(a => z, b => a2, rst => rst, producto => xr12);
	      MULT5 : entity work.multiplicador 
	              port map(a => z, b => b2, rst => rst, producto => xr22);
	        
	      SUM2 : entity work.sum_sfixed 
	             port map(a => xr11, b => xr12, rst => rst, suma => xr1);
	      SUM3 : entity work.sum_sfixed 
	             port map(a => xr21, b => xr22, rst => rst, suma => xr2);
	        
	-----Se suma la segunda realimentacion-----     
	      SUM4 : entity work.sum_sfixed 
	             port map(a => x2, b => xr2,rst => rst, suma => x3);
	        
	-----Se multiplica la señal que sale del segundo sumador por la ganancia G-----       
	      MULT6 : entity work.multiplicador 
	              port map(a => x3, b => G, rst => rst, producto => salida);
	      
	      --process (x1, x2, x3, y, z, xr11, xr12, xr21, xr22, xr1, xr2) is
	      --  begin
	      --  salidax1 <= x1;
	      --  salidax2 <= x2;
	      --  salidax3 <= x3;
	      --  saliday <= y;
	      --  salidaz <= z;
	      --  salidaxr11 <= xr11;
	      --  salidaxr12 <= xr12;
	      --  salidaxr21 <= xr21;
	      --  salidaxr22 <= xr22;
	      --  salidaxr1 <= xr1;
	      --  salidaxr2 <= xr2;
	      --end process;
	      
END rtl;