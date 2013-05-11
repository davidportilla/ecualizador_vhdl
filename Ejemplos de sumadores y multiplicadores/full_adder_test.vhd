library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity full_adder_test is

end entity full_adder_test;

architecture test of full_adder_test is
  
  signal a, b, c_in, sum, c_out: std_logic;
  
  begin
    
    ADDER: entity work.full_adder 
      port map(a => a, b => b, c_in => c_in, sum => sum, c_out => c_out);
    
    estimulos: process
      begin
        wait for 10 ns;
        a <= '0';
        b <= '0';
        c_in <= '0';
        
        wait for 10 ns;
        a <= '0';
        b <= '0';
        c_in <= '1';
        
        wait for 10 ns;
        a <= '0';
        b <= '1';
        c_in <= '0';
        
        wait for 10 ns;
        a <= '0';
        b <= '1';
        c_in <= '1';
        
        wait for 10 ns;
        a <= '1';
        b <= '0';
        c_in <= '0';
        
        wait for 10 ns;
        a <= '1';
        b <= '0';
        c_in <= '1';
        
        wait for 10 ns;
        a <= '1';
        b <= '1';
        c_in <= '0';
        
        wait for 10 ns;
        a <= '1';
        b <= '1';
        c_in <= '1';
        
        wait;
        
    end process estimulos; 
    
end architecture test;