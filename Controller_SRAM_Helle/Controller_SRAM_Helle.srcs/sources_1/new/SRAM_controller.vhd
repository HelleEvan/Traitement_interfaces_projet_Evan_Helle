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
           User_Data_out : out STD_LOGIC_VECTOR (35 downto 0));
end SRAM_controller;

architecture Behavioral of SRAM_controller is

--Declaration des signaux qui seront les entrées de la SRAM

    signal SRAM_Dq     : std_logic_vector(35 downto 0); -- Data I/O
    signal SRAM_Addr   : std_logic_vector(18 downto 0); -- Address
    signal SRAM_Lbo_n  : std_logic;                     -- Burst Mode PAS INSTANCIE TOUT DE SUITE
    signal SRAM_Clk    : std_logic;                     -- Clk
    signal SRAM_Cke_n  : std_logic;                     -- Cke#
    signal SRAM_Ld_n   : std_logic;                     -- Adv/Ld#
    signal SRAM_Bwa_n  : std_logic;                     -- Bwa#
    signal SRAM_Bwb_n  : std_logic;                     -- BWb#
    signal SRAM_Bwc_n  : std_logic;                     -- Bwc#
    signal SRAM_Bwd_n  : std_logic;                     -- BWd#
    signal SRAM_Rw_n   : std_logic;                     -- RW#
    signal SRAM_Oe_n   : std_logic;                     -- OE#
    signal SRAM_Ce_n   : std_logic;                     -- CE#
    signal SRAM_Ce2_n  : std_logic;                     -- CE2#
    signal SRAM_Ce2    : std_logic;                     -- CE2
    signal SRAM_Zz     : std_logic;                     -- Snooze Mode

-- composant mt55l512y36f

    component mt55l512y36f
        port(
            Dq        : INOUT STD_LOGIC_VECTOR (35 downto 0);              -- Data I/O
            Addr      : IN    STD_LOGIC_VECTOR (18 downto 0);              -- Address
            Lbo_n     : IN    STD_LOGIC;                                   -- Burst Mode
            Clk       : IN    STD_LOGIC;                                   -- Clk
            Cke_n     : IN    STD_LOGIC;                                   -- Cke#
            Ld_n      : IN    STD_LOGIC;                                   -- Adv/Ld#
            Bwa_n     : IN    STD_LOGIC;                                   -- Bwa#
            Bwb_n     : IN    STD_LOGIC;                                   -- BWb#
            Bwc_n     : IN    STD_LOGIC;                                   -- Bwc#
            Bwd_n     : IN    STD_LOGIC;                                   -- BWd#
            Rw_n      : IN    STD_LOGIC;                                   -- RW#
            Oe_n      : IN    STD_LOGIC;                                   -- OE#
            Ce_n      : IN    STD_LOGIC;                                   -- CE#
            Ce2_n     : IN    STD_LOGIC;                                   -- CE2#
            Ce2       : IN    STD_LOGIC;                                   -- CE2
            Zz        : IN    STD_LOGIC                                    -- Snooze Mode
        );
    end component;

begin

  -- Instanciation de la SRAM avec comme entrées, les sorties du controleur
  
  SRAM : mt55l512y36f 
    port map(
        Dq        => SRAM_Dq,                                       -- Data I/O
        Addr      => SRAM_Addr,                                     -- Address
        Lbo_n     => SRAM_Lbo_n,                                    -- Burst Mode
        Clk       => SRAM_Clk,                                      -- Clk
        Cke_n     => SRAM_Cke_n,                                    -- Cke#
        Ld_n      => SRAM_Ld_n,                                     -- Adv/Ld#
        Bwa_n     => SRAM_Bwa_n,                                    -- Bwa#
        Bwb_n     => SRAM_Bwb_n,                                    -- BWb#
        Bwc_n     => SRAM_Bwc_n,                                    -- Bwc#
        Bwd_n     => SRAM_Bwd_n,                                    -- BWd#
        Rw_n      => SRAM_Rw_n,                                     -- RW#
        Oe_n      => SRAM_Oe_n,                                     -- OE#
        Ce_n      => SRAM_Ce_n,                                     -- CE#
        Ce2_n     => SRAM_Ce2_n,                                    -- CE2#
        Ce2       => SRAM_Ce2,                                      -- CE2
        Zz        => SRAM_Zz                                        -- Snooze Mode
    );

-- Instanciation du controleur SRAM à faire maintenant

end Behavioral;
