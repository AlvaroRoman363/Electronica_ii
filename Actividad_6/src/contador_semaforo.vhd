library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_semaforo is
    port (
        clk: in std_logic;
        reset: in std_logic;
        Z: in std_logic;
        S_NS: in std_logic;
        S_EO: in std_logic;
        E_NS: in std_logic;
        E_EO: in std_logic;
        L_NS: out std_logic_vector (2 downto 0);
        L_EO: out std_logic_vector (2 downto 0);
        C: out std_logic;
        Q: out integer range 0 to 60;
        RES_NS: out std_logic;
        RES_EO: out std_logic
    );
end entity contador_semaforo;
architecture arch of contador_semaforo is
    -- definicion de los 6 estados de la MEF
    type estado_type is (RV, RVext, RA, VR, VRext, AR);
    signal estado_act, estado_sig: estado_type;
    -- codificacion de luces (Rojo="100", Amarillo="010", Verde="001")
    constant ROJO: std_logic_vector (2 downto 0):="100";
    constant AMARILLO: std_logic_vector (2 downto 0):="010";
    constant VERDE: std_logic_vector (2 downto 0):="001";
begin
    --1. Registro de estado (Memoria sincrónica con reset) 
    process(clk, reset) is 
    begin 
        if reset = '1' then 
            estado_act <= RV; 
        elsif rising_edge(clk) then
            estado_act <= estado_sig;
        end if; 
    end process; 
    -- 2\. Lógica combinacional de transiciones y salidas 
    process(estado_act, Z, S_NS, S_EO, E_NS, E_EO) is 
    begin 
        -- Valores por defecto 
        C <= '0'; 
        Q <= 0; 
        RES_NS <= '0'; 
        RES_EO <= '0'; 
        L_NS <= ROJO; 
        L_EO <= ROJO; 
        estado_sig <= estado_act; 
        
        case estado_act is 
            when RV =>
                L_NS <= ROJO; 
                L_EO <= VERDE; 
                if (Z = '1' or E_NS = '1') then 
                    if (S_EO = '1' and E_NS = '0' and E_EO = '0') then     
                        estado_sig <= RVext; 
                    else 
                        C <= '1'; 
                        Q <= 10; 
                        L_NS <= ROJO; L_EO <= AMARILLO; estado_sig <= RA;
                    end if; 
                end if; 

            when RVext => 
                L_NS <= ROJO; 
                L_EO <= VERDE; 
                if (Z = '1' or E_NS = '1') then 
                    C <= '1'; 
                    Q <= 10; 
                    L_NS <= ROJO; 
                    L_EO <= AMARILLO; 
                    RES_EO <= '1'; estado_sig <= RA;
                end if; 

            when RA => 
                L_NS <= ROJO; 
                L_EO <= AMARILLO; 
                if (Z = '1' and E_EO = '0') then 
                    C <= '1'; 
                    Q <= 50; 
                    L_NS <= VERDE; 
                    L_EO <= ROJO; 
                    estado_sig <= VR; 
            end if; 
            
            when VR => 
                L_NS <= VERDE; 
                L_EO <= ROJO; 
                if (Z = '1' or E_EO = '1') then 
                    if (S_NS = '1' and E_NS = '0' and E_EO = '0') then
                        estado_sig <= VRext;
                    else 
                        C <= '1'; 
                        Q <= 10; 
                        L_NS <= AMARILLO; L_EO <= ROJO; estado_sig <= AR; 
                    end if; 
                end if; 
            
            when VRext =>
                L_NS <= VERDE; 
                L_EO <= ROJO; 
                if (Z = '1' or E_EO = '1') then 
                    C <= '1'; 
                    Q <= 10; 
                    L_NS <= AMARILLO; L_EO <= ROJO; 
                    RES_NS <= '1'; estado_sig <= AR; 
                end if; 
            
            when AR => 
                L_NS <= AMARILLO; 
                L_EO <= ROJO; 
                if (Z = '1' and E_NS = '0') then 
                    C <= '1'; 
                    Q <= 50; 
                    L_NS <= ROJO; 
                    L_EO <= VERDE; estado_sig <= RV; 
                end if; 
            when others => 
                estado_sig <= RV; 
        end case; 
    end process; 
end architecture arch;


    