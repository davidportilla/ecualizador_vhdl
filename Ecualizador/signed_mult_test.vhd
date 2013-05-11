library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY signed_mult_test IS
END signed_mult_test;

ARCHITECTURE test OF signed_mult_test IS

SIGNAL a : std_logic_vector (15 downto 0);
SIGNAL b : std_logic_vector (15 downto 0);
SIGNAL producto : std_logic_vector (15 downto 0);

BEGIN

MULTIPLICADOR: ENTITY work.multiplicador
       PORT MAP(a => a, b => b, rst => '0', producto => producto);

  estimulos: PROCESS
  BEGIN
    a <= (others => '0');
    b <= (others => '0');
    WAIT for 10 ns;
    a <= "0111111111111111";
    b <= "1000000000000000";
    WAIT for 10 ns;
    a <= "0111111111111111";
    b <= "0100000000000000";
    WAIT for 10 ns;
    a <= "0011111111111111";
    b <= "0000000010000000";
    WAIT for 10 ns;
    a <= "1111111111111111";
    b <= "0000000000000001";
    WAIT for 10 ns;
    a <= "1000000000000000";
    b <= "1000000000000000";
    WAIT for 10 ns;
    a <= "1100000000000000";
    b <= "1100000000000000";
    WAIT for 10 ns;
    a <= "1000000000000001";
    b <= "1111111111111110";
    WAIT for 10 ns;
    a <= "1001000000000001";
    b <= "1111111000000100";
    WAIT for 10 ns;
    a <= "1001000000000001";
    b <= "0111111000000100";
    WAIT for 10 ns;
    a <= "1011000001110001";
    b <= "0000011000000100";
    WAIT for 10 ns;
    a <= "1100000000000000";
    b <= "0001000000000000";
    WAIT for 10 ns;
    a <= "1111100000000000";
    b <= "0000000000011111";
    WAIT;
  END PROCESS estimulos;

END test;