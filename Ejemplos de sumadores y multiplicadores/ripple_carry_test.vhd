library ieee;
use ieee.std_logic_1164.all;
use work.ripple_carry;

entity ripple_carry_test is

end entity;

architecture test of ripple_carry_test is
  -- Entradas
  signal a, b : std_logic_vector(3 downto 0);
  signal c_in : std_logic;
  -- Salidas
  signal suma : std_logic_vector(3 downto 0);
  signal c_out : std_logic;
  
  begin
    
    RC: entity work.ripple_carry 
            port map(a => a, b => b, c_in => c_in, suma => suma, c_out => c_out);
    
    estimulos: process
      begin
        wait for 30 ns;
        a <= "0000";
        b <= "0000";
        c_in <= '0';
        
        wait for 30 ns;
        a <= "0111";
        b <= "1001";
        c_in <= '1';
        
        wait for 30 ns;
        a <= "0011";
        b <= "0001";
        c_in <= '0';
        
        wait for 30 ns;
        a <= "1011";
        b <= "0001";
        c_in <= '0';
        
        wait;
    end process estimulos;
    
end architecture;