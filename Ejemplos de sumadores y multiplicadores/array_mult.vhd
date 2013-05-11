library ieee;
use ieee.std_logic_1164.all;
use work.and_gate;
use work.full_adder;
use work.half_adder;

entity array_mult is
  port(
    x, y : in std_logic_vector(3 downto 0);
    z : out std_logic_vector(7 downto 0)
    );
end entity array_mult;

architecture rtl of array_mult is
  -- señales intermedias (que no son pocas) --
  --productos parciales (x)(y)
        signal pp10, pp20, pp30 : std_logic;
  signal pp01, pp11, pp21, pp31 : std_logic;
  signal pp02, pp12, pp22, pp32 : std_logic;
  signal pp03, pp13, pp23, pp33 : std_logic;
  --acarreos
  signal c1, c2, c3, c4, c5, c6, c7, c8, c9 : std_logic;
  --sumas intermedias
  signal s1, s2, s3, s4, s5, s6, s7, s8 : std_logic;
  begin  

  -- AND(X)(Y) para calcular los productos parciales

  AND00 : entity work.and_gate port map(a => x(0), b => y(0), c => z(0));
  AND10 : entity work.and_gate port map(a => x(1), b => y(0), c => pp10);
  AND20 : entity work.and_gate port map(a => x(2), b => y(0), c => pp20);
  AND30 : entity work.and_gate port map(a => x(3), b => y(0), c => pp30);
    
  AND01 : entity work.and_gate port map(a => x(0), b => y(1), c => pp01);
  AND11 : entity work.and_gate port map(a => x(1), b => y(1), c => pp11);
  AND21 : entity work.and_gate port map(a => x(2), b => y(1), c => pp21);
  AND31 : entity work.and_gate port map(a => x(3), b => y(1), c => pp31);
  
  HA1 : entity work.half_adder port map(a => pp10, b => pp01, sum => z(1), c_out => c1);
  FA1 : entity work.full_adder
      port map(a => pp11, b => pp20, c_in => c1, sum => s1, c_out => c2);
  FA2 : entity work.full_adder
      port map(a => pp21, b => pp30, c_in => c2, sum => s2, c_out => c3);
  HA2 : entity work.half_adder port map(a => pp31, b => c3, sum => s3, c_out => s4);
  
  AND02 : entity work.and_gate port map(a => x(0), b => y(2), c => pp02);
  AND12 : entity work.and_gate port map(a => x(1), b => y(2), c => pp12);
  AND22 : entity work.and_gate port map(a => x(2), b => y(2), c => pp22);
  AND32 : entity work.and_gate port map(a => x(3), b => y(2), c => pp32);
  
  HA3 : entity work.half_adder port map(a => s1, b => pp02, sum => z(2), c_out => c4);
  FA3 : entity work.full_adder
      port map(a => s2, b => pp12, c_in => c4, sum => s5, c_out => c5);
  FA4 : entity work.full_adder
      port map(a => s3, b => pp22, c_in => c5, sum => s6, c_out => c6);
  FA5 : entity work.full_adder
      port map(a => s4, b => pp32, c_in => c6, sum => s7, c_out => s8);
  
  AND03 : entity work.and_gate port map(a => x(0), b => y(3), c => pp03);
  AND13 : entity work.and_gate port map(a => x(1), b => y(3), c => pp13);
  AND23 : entity work.and_gate port map(a => x(2), b => y(3), c => pp23);
  AND33 : entity work.and_gate port map(a => x(3), b => y(3), c => pp33);
  
  HA4 : entity work.half_adder port map(a => s5, b => pp03, sum => z(3), c_out => c7);
  FA6 : entity work.full_adder
      port map(a => s6, b => pp13, c_in => c7, sum => z(4), c_out => c8);
  FA7 : entity work.full_adder
      port map(a => s7, b => pp23, c_in => c8, sum => z(5), c_out => c9);
  FA8 : entity work.full_adder
      port map(a => s8, b => pp33, c_in => c9, sum => z(6), c_out => z(7));
  
end architecture rtl;