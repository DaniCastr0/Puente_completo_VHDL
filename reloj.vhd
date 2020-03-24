----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.02.2020 11:35:39
-- Design Name: 
-- Module Name: reloj - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

entity reloj is
    Port ( clk: in STD_LOGIC;
           led : out STD_LOGIC_VECTOR(3 downto 0));
end reloj;

architecture Behavioral of reloj is

signal cont: STD_LOGIC_VECTOR(28 downto 0);
begin
process(clk)
begin
    if (rising_edge(clk)) then 
    cont <= cont+1;
    end if;
end process;
led<=cont(28 downto 25);
end Behavioral;
