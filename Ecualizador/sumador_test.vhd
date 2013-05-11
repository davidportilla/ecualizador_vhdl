use work.sumador;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY sumador_test IS
END sumador_test;

ARCHITECTURE test OF sumador_test IS

SIGNAL a : std_logic_vector (15 downto 0);
SIGNAL b : std_logic_vector (15 downto 0);
SIGNAL suma : std_logic_vector (15 downto 0);

BEGIN

SUMADOR: ENTITY work.sum_sfixed
       PORT MAP(a => a, b => b, rst => '0', suma => suma);

  estimulos: PROCESS
  BEGIN
    a <= (others => '0');
    b <= (others => '0');
    WAIT for 10 ns;
    a <= "0111111111111111";
    b <= "1000000000000000";
    -- 1 - 1 = - casi 0
    WAIT for 10 ns;
    a <= "0100000000000000";
    b <= "0100000000100000";
    -- 0,5 + 0,5 = 1;
    WAIT for 10 ns;
    a <= "0000011100000000";
    b <= "0100000000000000";
    -- 0,5 + 0,5 = 1;
    WAIT for 10 ns;
    a <= "1111111111111111";
    b <= "0000000000000001";
    -- - casi 0 + casi 0 = 0
    WAIT for 10 ns;
    a <= "1000000000000000";
    b <= "1000000000000000";
    -- -1 - (-1) = -2 => -1
    WAIT for 10 ns;
    a <= "1100000000000000";
    b <= "1100000000000000";
    WAIT for 10 ns;
    a <= "1000000000000001";
    b <= "1111111111111110";
    WAIT for 10 ns;
    a <= "1001000000000001";
    b <= "1111111000000100";
    WAIT;
  END PROCESS estimulos;

END test;