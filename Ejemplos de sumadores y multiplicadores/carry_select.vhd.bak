library ieee;
use ieee.std_logic_1164.all;
use work.ripple_carry;

entity carry_select is
  port(
    a, b: in std_logic_vector (3 downto 0);
    c_in : in std_logic;
    suma : out std_logic_vector (3 downto 0);
    c_out : out std_logic
  );
end entity;

architecture rtl of carry_select is
  signal sum1, sum2 : std_logic_vector (3 downto 0);
  signal carry1, carry2, sel1, sel2, sel3, sel4 : std_logic;
  begin
    
    RC1: entity work.ripple_carry
        port map(a => a, b => b, c_in => '1', suma => sum1, c_out => carry1);
    
    RC2: entity work.ripple_carry
        port map(a => a, b => b, c_in => '0', suma => sum2, c_out => carry2);
    
    MUX0: entity work.mux_1bit
        port map(in0 => sum1(0), in1 => sum2(0), sel => c_in, output => sel1);
    
    MUX1: entity work.mux_1bit
        port map(in0 => sum1(1), in1 => sum2(1), sel => sel1, output => sel2);
    
    MUX2: entity work.mux_1bit
        port map(in0 => sum1(2), in1 => sum2(2), sel => sel2, output => sel3);
    
    MUX3: entity work.mux_1bit
        port map(in0 => sum1(3), in1 => sum2(3), sel => sel3, output => sel3);
    
    MUXCARRY: entity work.mux_1bit
        port map(in0 => carry1, in1 => carry2, sel => sel4, output => c_out);

end architecture rtl;