library ieee;
use ieee.std_logic_1164.all;

entity xor_gate is
  port(
    a : in std_logic;
    b : in std_logic;
    c : out std_logic
    );
end entity xor_gate;

architecture rtl of xor_gate is
  begin
    process (a, b) is
      begin
      c <= a xor b after 1 ns;
    end process;
end rtl;