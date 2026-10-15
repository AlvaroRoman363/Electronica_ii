--contador_2bit_tb.vhd
Library ieee;
use ieee.std_logic_1164.all;
use work.all;
use std.env.finish;
entity contador_2bit_tb is
end contador_2bit_tb;
architecture tb of contador_2bit_tb is
    signal reset,hab,clk : std_logic;
    signal cuenta : std_logic_vector(1 downto 0);
begin
    DUT: entity contador_2bit port map ( reset => reset, hab => hab, clk => clk, cuenta => cuenta);
    gen_clk: process is
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process gen_clk;
end tb;