--contador_2bit.vhd
    library IEEE;
    use IEEE.std_logic_1164.all;
        entity contador_2bit is
            port (
                reset : in std_logic;
                hab: in std_logic;
                clk : in std_logic;
                cuenta : out std_logic_vector(1 downto 0));
        end contador_2bit;
        architecture arch of contador_2bit is
            signal estado, estado_sig: std_logic_vector(1 downto 0);
        begin
            memoria: process(clk) is
            begin
                if rising_edge(clk) then
                    estado <= estado_sig;
                end if;
            end process; --memoria
            logica_estado_siguiente:
            with reset & hab & estado select
                estado_sig <=   "01" when "0000" |"0100",
                                "10" when "0010" |"0101",
                                "11" when "0111" |"0110",
                                "00" when others; --"0000"   
            logica_salida:
            cuenta <= estado;
        end architecture;
    