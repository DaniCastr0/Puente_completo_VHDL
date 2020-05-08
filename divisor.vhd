----------------------------------------------------------------------------------
-- Company: Universidad de Oviedo
-- Engineer: Daniel González Castro
-- 
-- Create Date: 04.05.2020 13:14:35
-- Design Name: 
-- Module Name: divisor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Circuito diseñado para el control de un puente completo con desplazamiento de fase.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divisor is
    Port ( clk : in STD_LOGIC;
           out1 : out STD_LOGIC;
           out2 : out STD_LOGIC;
           frequp: in STD_LOGIC;
           freqdown: IN std_logic;
           phaseup: IN std_logic;
           phasedown: IN std_logic);
end divisor;

architecture Behavioral of divisor is
signal cont:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0'); --contador
signal comp100:STD_LOGIC_VECTOR(15 downto 0):="0000001001110001"; --contador para llegar a 100khz (10^-5s), partiendo de un reloj de 8ns. en total cambiamos la señal cada 625 pulsos
signal comp1:STD_LOGIC_VECTOR(15 downto 0):="1111010000100100"; --contador para llegar a 1hz (10^-3s), partiendo de un reloj de 8ns. en total cambiamos la señal cada 62500 pulsos
signal comp:STD_LOGIC_VECTOR(15 downto 0):="1111010000100100"; --comporador. lo inicializamos a 1 khz y lo variamos según apretemos botones.
signal clock1: STD_LOGIC:='0'; --señal asociada a out1
signal clock2: STD_LOGIC:='0'; --señal asociada a out2
signal lastfrequp: STD_LOGIC:='0'; --último estado del botón frequp
signal up: STD_LOGIC:='0'; --señal asociada a botón frequp
signal lastfreqdown: STD_LOGIC:='0'; --último estado del botón freqdown
signal down: STD_LOGIC:='0'; --señal asociada a botón freqdown
signal den:STD_LOGIC_VECTOR(15 downto 0):="0000000001100100";--den, coc y resto son señales asociadas a la división del comparador como. Para el desplazamiento de fase, necesitaremos siempre una señal 100 veces más rápida que comp.den=100
signal coc:STD_LOGIC_VECTOR(15 downto 0);
signal resto:STD_LOGIC_VECTOR(15 downto 0);
signal lastphaseup: STD_LOGIC:='0'; --último estado del botón phaseup
signal lastphasedown: STD_LOGIC:='0'; --último estado del botón phasedown
signal division:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0'); --dividimos la señal del comparador entre 100. esto es lo que se irá incrementando o disminuyendo a medida que pulsemos el botón de cambio de fase
signal desplazamiento:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0'); --lo que se desplzada la señal out2


component divisionblock is   --componente para dividir la señal comp
  port (   clk : in STD_LOGIC;
           num : in STD_LOGIC_VECTOR (15 downto 0);
           den : in STD_LOGIC_VECTOR (15 downto 0);
           coc : out STD_LOGIC_VECTOR (15 downto 0);
           resto : out STD_LOGIC_VECTOR (15 downto 0));
end component;


begin

--Componente para dividir la el valor de la frecuencia actual entre cien, con el objetivo de que este sea utilizado para el desplazamiento de fase
dividiendo: divisionblock port map (clk,comp,den,coc,resto);

--cont es el contador. Este se incrementa hasta que alcance la variable comp, la cual regularemos con los botones. En el momento en el que llegue, cambiará el estado de clok1, nuestra primera salida.
process(clk)
begin
if rising_edge(clk) then
    if cont=comp then
        cont<="0000000000000000";
        clock1<= not clock1;       
    else
        if comp<comp1 then
            cont<=cont +'1';
        end if;
    end if;  
end if;
end process; 

--Al igual que en el caso anterior, aquí tenemos un contador para llegar a la frecuencia deseada. este contador, en vez de resetearse en 0, lo hace en un valor desplazado.
process(clk)
begin
if rising_edge(clk) then
    if cont=comp+desplazamiento then
        cont<=desplazamiento;
        clock2<= not clock2;
        
    else
       if comp>comp100 then
            cont<=cont -'1';
        end if;
    end if;  
end if;
end process; 

-- Si apretamos el botón, disminuimos el comparador, aumentando la frecuencia
process(clk)
begin
  if(rising_edge(clk)) then
    if(up = '1' and lastfrequp = '0') then     
       comp<= comp - "100110101011";
    end if;
        lastfrequp <= up;
  end if;
end process;   

-- Si apretamos el botón, aumentamos el comparador, disminuyendo la frecuencia
process(clk)
begin
  if(rising_edge(clk)) then
    if(down = '1' and lastfreqdown = '0') then     
       comp<= comp + "100110101011";
    end if;
        lastfreqdown <= down;
  end if;
end process; 


  -- Si apretamos phaseup el botón, desplazamos el clock2 hacia la derecha. En caso de apretar el phasedown, lo desplazamos hacia la izuierda.
process(clk)
begin
  if(rising_edge(clk)) then
    if(phaseup = '1' and lastphaseup = '0') then
       if (desplazamiento<"1011010") then   -- no aceptamos desplazamientos mayores que 90%  
          desplazamiento<= desplazamiento + coc;
       end if;
    elsif (phasedown = '1' and lastphasedown = '0') then
       if (desplazamiento>"00000000") then  -- no aceptamos desplazamientos negativos
          desplazamiento<= desplazamiento - coc; 
       end if;
    end if;
   end if;
end process;

--igualamaos los relojes a las salidas del proceso
out1<=clock1;
out2<=clock2;

end Behavioral;
