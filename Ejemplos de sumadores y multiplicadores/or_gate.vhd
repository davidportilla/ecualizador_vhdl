library ieee;
use ieee.std_logic_1164.all;

entity or_gate is
  port(
    a : in std_logic;
    b : in std_logic;
    c : out std_logic
    );
end entity or_gate;

architecture rtl of or_gate is
  begin
    process (a, b) is
      begin
      c <= a or b after 1 ns;
    end process;
end rtl;