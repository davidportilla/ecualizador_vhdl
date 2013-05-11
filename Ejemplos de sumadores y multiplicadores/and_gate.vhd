library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
  port(
    a : in std_logic;
    b : in std_logic;
    c : out std_logic
    );
end entity and_gate;

architecture rtl of and_gate is
  begin
    process (a, b) is
      begin
      c <= a and b after 1 ns;
    end process;
end rtl;