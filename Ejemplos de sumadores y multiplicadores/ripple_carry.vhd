library ieee;
use ieee.std_logic_1164.all;
use work.full_adder;

entity ripple_carry is
  port(
    a, b: in std_logic_vector (3 downto 0);
    c_in : in std_logic;
    suma : out std_logic_vector (3 downto 0);
    c_out : out std_logic
  );
end entity;

architecture rtl of ripple_carry is
  signal carry1, carry2, carry3 : std_logic;
  begin
    FA0 : entity work.full_adder
      port map(a => a(0), b => b(0), c_in => c_in, sum => suma(0), c_out => carry1);
    
    FA1 : entity work.full_adder
      port map(a => a(1), b => b(1), c_in => carry1, sum => suma(1), c_out => carry2);
    
    FA2 : entity work.full_adder
      port map(a => a(2), b => b(2), c_in => carry2, sum => suma(2), c_out => carry3);
    
    FA3 : entity work.full_adder
      port map(a => a(3), b => b(3), c_in => carry3, sum => suma(3), c_out => c_out);
    
end rtl;