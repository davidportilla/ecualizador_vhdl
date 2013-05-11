library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
ENTITY delay IS
  PORT (entrada : IN std_logic_vector(15 DOWNTO 0); 
        clk : IN std_logic;
        rst : IN std_logic;  
        salida : OUT std_logic_vector(15 DOWNTO 0));
END delay;

ARCHITECTURE rtl OF delay IS
  BEGIN
  process(rst, clk) is
    begin
    IF (rising_edge(rst) OR rst = '1') THEN
      salida <= (others => '0');
    ELSIF falling_edge(rst) THEN
      null;
    ELSE
      if(rising_edge(clk)) then
        salida <= entrada;
      end if;
    END IF;
  end process;
END rtl;