library Ieee; 
use Ieee.std_logic_1164.all; 
entity contador_semaforo_tb is 
end entity contador_semaforo_tb; architecture arch of contador_semaforo_tb is 
    -- Señales de estímulo 
    signal clk : std_logic := '0'; 
    signal reset : std_logic := '0'; 
    signal Z : std_logic := '0'; 
    signal S_NS : std_logic := '0'; 
    signal S_EO : std_logic := '0'; 
    signal E_NS : std_logic := '0'; 
    signal E_EO : std_logic := '0'; 
    -- Señales observadas 
    signal C, RES_NS, RES_EO : std_logic; 
    signal L_NS, L_EO : std_logic_vector(2 downto 0); 
    signal Q : integer range 0 to 60; constant T_CLK : time := 10 ns; 
begin 
-- Instanciación de la entidad del controlador de semáforo 
    uut: entity work.contador_semaforo 
        port map ( 
            clk => clk, 
            reset => reset, 
            Z => Z, 
            S_NS => S_NS, 
            S_EO => S_EO, 
            E_NS => E_NS, 
            E_EO => E_EO, 
            L_NS => L_NS, 
            L_EO => L_EO, 
            C => C, 
            Q => Q, 
            RES_NS => RES_NS,
            RES_EO => RES_EO 
        ); 
            
    -- Generación del reloj principal
    clk_process : process 
    begin 
        clk <= '0'; wait for T_CLK / 2; 
        clk <= '1'; wait for T_CLK / 2; 
    end process; 
    -- Proceso de prueba (secuencia de estímulos) 
    stim_proc: process 
    begin 
    -- 1\. Reset inicial del sistema 
    
        reset <= '1'; wait for 20 ns; reset <= '0'; wait for 20 ns; 
        -- 2\. Transición normal RV -&gt; RA (pulso Z) 
        Z <= '1'; wait for T_CLK; Z <= '0'; wait for 40 ns; 
        -- 3\. Transición RA -> VR (pulso Z) 
        Z <= '1'; wait for T_CLK; Z <= '0'; wait for 40 ns; 
        -- 4\. Pedido peatonal en Norte-Sur (activa S_NS) 
        S_NS <= '1'; 
        Z <= '1'; wait for T_CLK; Z <= '0'; wait for 40 ns; 
        S_NS <= '0'; 
        -- 5\. Señal de emergencia en Este-Oeste 
        E_EO <= '1'; wait for 30 ns; 
        E_EO <= '0'; wait for 40 ns; wait; 
    end process; 
end architecture arch;