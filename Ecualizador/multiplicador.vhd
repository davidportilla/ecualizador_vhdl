library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;

entity multiplicador is
  port 
  (a: in std_logic_vector (15 downto 0);
   b: in std_logic_vector (15 downto 0);
   rst : in std_logic;
   producto	: out std_logic_vector (15 downto 0)
   );
end entity;

architecture rtl of multiplicador is

begin

process (rst, a, b) is
  variable a1, b1: sfixed(5 downto -10);
  variable c1: sfixed(11 downto -20);
  begin
    
    IF (rst = '1') THEN
      producto <= (others => '0');
    ELSE
      a1 := sfixed(a);
      b1 := sfixed(b);
      c1 := a1 * b1;
      producto(15) <= c1(5);
      producto(14) <= c1(4);
      producto(13) <= c1(3);
      producto(12) <= c1(2);
      producto(11) <= c1(1);
      producto(10) <= c1(0);
      producto(9) <= c1(-1);
      producto(8) <= c1(-2);
      producto(7) <= c1(-3);
      producto(6) <= c1(-4);
      producto(5) <= c1(-5);
      producto(4) <= c1(-6);
      producto(3) <= c1(-7);
      producto(2) <= c1(-8);
      producto(1) <= c1(-9);
      producto(0) <= c1(-10);
    END IF;  
end process;

end rtl;