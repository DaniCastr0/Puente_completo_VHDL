----------------------------------------------------------------------------------
-- Company: Universidad de Oviedo
-- Engineer: Daniel González Castro
-- 
-- Create Date: 05.05.2020 12:39:08
-- Design Name: 
-- Module Name: division - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Componente para dividir dos señales
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

entity divisionblock is
    Port ( clk : in STD_LOGIC;
           num : in STD_LOGIC_VECTOR (15 downto 0);
           den : in STD_LOGIC_VECTOR (15 downto 0);
           coc : out STD_LOGIC_VECTOR (15 downto 0);
           resto : out STD_LOGIC_VECTOR (15 downto 0));
end divisionblock;

architecture Behavioral of divisionblock is


signal numerador:STD_LOGIC_VECTOR(15 downto 0):=num;
signal prevnum:STD_LOGIC_VECTOR(15 downto 0):=num;
signal denominador:STD_LOGIC_VECTOR(15 downto 0):=den;
signal cociente:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal restosingal:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal finish:STD_LOGIC:='0';
begin

process( clk)
 
begin
 if(rising_edge(clk)) then
     if finish='0' then
        if(numerador>denominador) then    
             numerador <= numerador - denominador;
             cociente <= cociente +"0000000000000001";
         else
            resto<=numerador;
            coc<=cociente;
            resto<=numerador;
            numerador <= num;
            finish<='1';             
         end if; 
      
     else
        if prevnum/=num then
            finish<='0';
        end if;
     
     end if;
end if;  
end process;


end Behavioral;
