----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.09.2025 14:14:03
-- Design Name: 
-- Module Name: SRAM_controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SRAM_controller is
    Port ( Clk : in STD_LOGIC;
           Read : in STD_LOGIC;
           Write : in STD_LOGIC;
           User_Address : in STD_LOGIC_VECTOR (18 downto 0);
           User_Data_in : in STD_LOGIC_VECTOR (35 downto 0);
           User_Data_out : out STD_LOGIC_VECTOR (35 downto 0);
           --CTRL : out STD_LOGIC_VECTOR ();
           Address : out STD_LOGIC_VECTOR(18 downto 0);
           Data : inout STD_LOGIC_VECTOR(35 downto 0));
end SRAM_controller;

architecture Behavioral of SRAM_controller is

    signal Lbo_n  : std_logic;                     -- Burst Mode PAS INSTANCIE TOUT DE SUITE
    signal Cke_n  : std_logic;                     -- Cke#
    signal Ld_n   : std_logic;                     -- Adv/Ld#
    signal Bwa_n  : std_logic;                     -- Bwa#
    signal Bwb_n  : std_logic;                     -- BWb#
    signal Bwc_n  : std_logic;                     -- Bwc#
    signal Bwd_n  : std_logic;                     -- BWd#
    signal Rw_n   : std_logic;                     -- RW#
    signal Oe_n   : std_logic;                     -- OE#
    signal Ce_n   : std_logic;                     -- CE#
    signal Ce2_n  : std_logic;                     -- CE2#
    signal Ce2    : std_logic;                     -- CE2
    signal Zz     : std_logic;                     -- Snooze Mode
    
    signal Trig : std_logic;                       -- trigger de l'iob

begin

-- Instanciation du controleur à faire

    process(Clk)
    begin 
        
        
    end process;    

end Behavioral;
