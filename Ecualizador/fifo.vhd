----------------------------------------------------------------------------------
-- $File: FIFO.vhd$
-- Contents:
-- FIFO with selectable width and depth.
-- the FIFO depth is 2^add_lenth-1
-- 
-- control signals:
-- clk   : system clock, all is sync to rising clk edge
-- reset : sync reset, active high, 
--         read and write address are set to 0
--         clears underflow and overflow flags
-- 
-- write data to FIFO:
-- data_in        : data word to write to FIFO
-- push           : set to 1 for 1 clk to write 1 data word to FIFO
--                  push must not be applied when "full" is true
-- full flag:       goes high when FIFO got full with last push
-- overflow flag  : goes high when a push occurs while "full" flag is set
--                  can only be reset by applying "reset"
--
-- read from FIFO:
-- data_out       : data word to read from FIFO
--                  only valid if "empty" is false
-- pop            : set to 1 for 1 clk to take 1 data word out of FIFO
--                  pop must not be applied when "empty" is true
-- empty flags    : goes high when FIFO got empty with last pop
-- underflow flag : goes high when a pop occurs while "empty" flag is set
--                  can only be reset by applying "reset"
--
-- $Archive: $
-- $Branch: $
-- $Revision: $
--
-- $Log$
----------------------------------------------------------------------------------
-- $Author: $
-- $Date: $
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
    generic (
        depth : positive;
        FWL   : positive );
    port (
        clk             : in  std_logic;
        reset           : in  std_logic;
        push            : in  std_logic;
        pop             : in  std_logic;
        data_in         : in  std_logic_vector(FWL-1 downto 0);
        data_out        : out std_logic_vector(FWL-1 downto 0);
        empty           : out std_logic;
        full            : out std_logic;
        underflow       : out std_logic;
        overflow        : out std_logic
    );
end fifo;
-------------------------------------------------------------------------------

architecture fifo_arch of fifo is

    constant mem_size : integer := 2**depth;
    type     mem_type is array (mem_size-1 downto 0) of
             std_logic_vector(FWL-1 downto 0);
    signal  mem         : mem_type;
    signal  addr_rd     : unsigned(depth-1 downto 0);
    signal  addr_wr     : unsigned(depth-1 downto 0);
    signal  full_sig    : std_logic;
    signal  empty_sig   : std_logic;

begin 
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- sync reset
                addr_rd     <= (others =>'0');
                addr_wr     <= (others =>'0');
                underflow   <= '0';
                overflow    <= '0';
                for i in 0 to mem_size-1 loop
                  mem(integer(i)) <= (others => '0');
                end loop;
            else
                -- process inputs
                if pop = '1' then
                    if empty_sig = '0' then
                        -- go to next read addr only if not empty
                        addr_rd <= addr_rd + 1;
                    else
                        -- set underflow flag
                        underflow <= '1';
                    end if;
                end if;
                if push = '1' then
                    if full_sig = '0' then
                        -- write data to memory
                        -- go to next write addr
                        mem(to_integer(addr_wr)) <= data_in(FWL-1 downto 0);
                        addr_wr <= addr_wr + 1;
                    else
                        -- set overflow flag
                        overflow <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- data output
    data_out <= mem(to_integer(addr_rd));

    -- empty flag
    empty_sig <= '1' when addr_rd = addr_wr else '0';
    empty <= empty_sig;

    -- full flag
    full_sig <= '1' when (addr_rd = addr_wr + 1) else '0';
    full <= full_sig;

end architecture fifo_arch;


