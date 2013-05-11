library ieee;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.contador;

entity vumetro is
  port 
  (e0, e1, e2, e3, e4, e5, e6 : in std_logic_vector (15 downto 0);
   clk, rst : in std_logic;
   s0, s1, s2, s3, s4, s5, s6 : out std_logic_vector (7 downto 0)
   );
end entity;

architecture rtl of vumetro is

--signal cuenta : std_logic_vector(2 downto 0);

-- 7 umbrales de energía
constant u1 : natural := 2**13;
constant u2 : natural := 2**12;
constant u3 : natural := 2**11;
constant u4 : natural := 2**10;
constant u5 : natural := 2**9;
constant u6 : natural := 2**8;
constant u7 : natural := 2**7;

begin
  
  actualizar: process (clk, rst) is
    
    -------------------------------------------------------------
    function SS(X: unsigned) return std_logic_vector is
      variable abs_value : unsigned(15 downto 0);
      begin       
        -- Calulamos el valor absuluto --
        if(X(15) = '1') then
          abs_value := not(X) + 1;
        else
          abs_value := X;
        end if;
        --------------------------------       
        -- Comparamos con los umbrales --
        if (u1 <= abs_value) then
          return "11111111";
        elsif ((u2 <= abs_value) and (abs_value < u1)) then
          return "01111111";
        elsif ((u3 <= abs_value) and (abs_value < u2)) then
          return "00111111";
        elsif ((u4 <= abs_value) and (abs_value < u3)) then
          return "00011111";
        elsif ((u5 <= abs_value) and (abs_value < u4)) then
          return "00001111";
        elsif ((u6 <= abs_value) and (abs_value < u5)) then
          return "00000111";
        elsif ((u7 <= abs_value) and (abs_value < u6)) then
          return "00000011";
        elsif (abs_value < u7) then
          return "00000001";
        else
          return "00000000";  
        end if;
        ---------------------------------
    end function SS;
    -------------------------------------------------------------
    
    begin
      
      IF (rst = '1') THEN
        s0 <= (others => '0');
        s1 <= (others => '0');
        s2 <= (others => '0');
        s3 <= (others => '0');
        s4 <= (others => '0');
        s5 <= (others => '0');
        s6 <= (others => '0');
      ELSE
        IF (rising_edge(clk)) THEN
          s0 <= SS(unsigned(e0));
          s1 <= SS(unsigned(e1));
          s2 <= SS(unsigned(e2));
          s3 <= SS(unsigned(e3));
          s4 <= SS(unsigned(e4));
          s5 <= SS(unsigned(e5));
          s6 <= SS(unsigned(e6)); 
        END IF;
      END IF; 
  end process;
  
end rtl;
  
end rtl;