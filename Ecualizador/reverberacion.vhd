library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

ENTITY reverberacion IS
    GENERIC (
      atenuacion : std_logic_vector (15 downto 0);
      retardo : std_logic_vector (7 downto 0)
    );
    PORT (
      clk, rst : in std_logic;
	    eq, car, rev : in std_logic;
		  entrada : in std_logic_vector (15 downto 0);
		  salida		: out std_logic_vector (15 downto 0)
    );
END reverberacion;

ARCHITECTURE rtl OF reverberacion IS
  
  signal push : std_logic;
  signal pop : std_logic;
  signal salida_fifo : std_logic_vector(15 downto 0);
  signal empty : std_logic;
  signal full : std_logic;
  signal underflow : std_logic;
  signal overflow : std_logic;
  
  signal enable : std_logic;
  signal count : std_logic_vector(7 downto 0);
  
  signal retardo_alcanzado : std_logic;
  
  signal q_registro : std_logic_vector(15 downto 0);
  
BEGIN
  
  CONTADOR : entity work.contador
                generic map(width => 8)
                port map(clk => clk, rst => rst, enable => enable, count => count);
                  
  FIFO : entity work.fifo generic map(depth => 10, FWL => 16)
                port map(clk => clk, reset => rst, push => push, pop => pop,
                data_in => entrada, data_out => salida_fifo, empty => empty,
                full => full, underflow => underflow, overflow => overflow);
  
  controlador: PROCESS (clk) IS
    BEGIN
    if rising_edge(clk) then
    if(unsigned(count) >= unsigned(retardo)) then
      retardo_alcanzado <= '1';
      enable <= '0'; -- Deja de incrementar el contador
    else
      retardo_alcanzado <= '0';
      enable <= '1';
    end if;
    end if;
  END PROCESS controlador;
  
  control_fifo: PROCESS (clk) IS
    BEGIN
      if(rising_edge(clk)) then
        -- Guarda valor en la fifo si no está llena
        if(full = '0' and rst = '0') then
          push <= '1';
        else
          push <= '0';
        end if;
        -- Saca valor de la fifo si no está vacía y retardo alcanzado
        if(empty = '0' and retardo_alcanzado = '1') then
          pop <= '1';
        else
          pop <= '0';
        end if;
      end if;
  END PROCESS control_fifo;
                               
  registro: PROCESS (rst, clk) IS
    BEGIN
    IF(rst = '1' or rising_edge(clk)) THEN
    if(car = '1' or eq = '1') then
      q_registro <= (others => '0');
    elsif(rev = '1') then
    --------------------
    IF (rst = '1') THEN
      q_registro <= (others => '0');
    ELSIF falling_edge(rst) THEN
      null;
    ELSE
      if(rising_edge(clk)) then
        if(retardo_alcanzado = '1') then
          q_registro <= salida_fifo;
        else
          q_registro <= (others => '0');
        end if;
      end if;
    END IF;
    --------------------
    else
      null;
    end if;
  END IF;
  END PROCESS registro;
  
  ATENUADOR : entity work.multiplicador 
                port map(a => q_registro, b => atenuacion, rst => rst, producto => salida);
                              
END rtl;