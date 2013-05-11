library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity full_adder is
  port(
    a, b, c_in : in std_logic;
    sum, c_out : out std_logic
    );
end entity full_adder;

---------------------------------------------------
-- [c_in == c]
-- sum = a(-b)(-c) +  (-a)b(-c) + (-a)(-b)c + abc
-- c_out = ab + bc + ac
---------------------------------------------------

architecture rtl of full_adder is
  -- señales intermedias
  signal i1, i2, i3 : std_logic;
  begin
    
    XOR1 : entity work.xor_gate port map(a => a, b => b, c => i1);
    XOR2 : entity work.xor_gate port map(a => i1, b => c_in, c => sum);
    AND1 : entity work.and_gate port map(a => i1, b => c_in, c => i2);
    AND2 : entity work.and_gate port map(a => a, b => b, c => i3);
    OR1 : entity work.or_gate port map(a => i2, b => i3, c => c_out);
  
end rtl;