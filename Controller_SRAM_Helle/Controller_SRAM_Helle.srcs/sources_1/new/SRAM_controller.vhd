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
           Ctrl : in STD_LOGIC; -- read and write permet en un seul port. permet d'éviter un read et write en même temps.
           Start :in STD_LOGIC; -- mettre à 1 pour sortir du Idle
           User_Address : in STD_LOGIC_VECTOR (18 downto 0);
           User_Data_in : in STD_LOGIC_VECTOR (31 downto 0);
           User_Data_out : out STD_LOGIC_VECTOR (35 downto 0);
           Address : out STD_LOGIC_VECTOR(18 downto 0);
           Data : inout STD_LOGIC_VECTOR(35 downto 0);
           reset : in STD_LOGIC);
end SRAM_controller;


architecture Behavioral of SRAM_controller is

    SIGNAL CLKO_SRAM :  std_logic := '0';
	SIGNAL nCKE :  std_logic := '0';
	SIGNAL nADVLD :  std_logic := '0';
	SIGNAL nRW:  std_logic := '0';
	SIGNAL nOE:  std_logic := '0';
	SIGNAL nCE:  std_logic := '0';
	SIGNAL nCE2:  std_logic := '0';
	SIGNAL CE2:  std_logic := '0';
	SIGNAL SA :  std_logic_vector(18 downto 0);
	SIGNAL ENTREE : std_logic_vector(35 downto 0);
	SIGNAL Trig : std_logic := '0';
	
    signal DATA_whithin : STD_LOGIC_VECTOR (35 downto 0);
    type StateType is(INIT, IDLE, READ, WRITE);
    signal state : StateType;

component mt55l512y36f is
    generic (
      -- Constant parameters
      addr_bits : integer := 19;
      data_bits : integer := 36;

      -- Timing parameters for -10 (100 Mhz)
      tKHKH : time := 10.0 ns;
      tKHKL : time := 2.5 ns;
      tKLKH : time := 2.5 ns;
      tKHQV : time := 5.0 ns;
      tAVKH : time := 2.0 ns;
      tEVKH : time := 2.0 ns;
      tCVKH : time := 2.0 ns;
      tDVKH : time := 2.0 ns;
      tKHAX : time := 0.5 ns;
      tKHEX : time := 0.5 ns;
      tKHCX : time := 0.5 ns;
      tKHDX : time := 0.5 ns
      );

    -- Port Declarations
    port (
      Dq    : inout std_logic_vector (data_bits - 1 downto 0);  -- Data I/O
      Addr  : in    std_logic_vector (addr_bits - 1 downto 0);  -- Address
      Lbo_n : in    std_logic;                                  -- Burst Mode
      Clk   : in    std_logic;                                  -- Clk
      Cke_n : in    std_logic;                                  -- Cke#
      Ld_n  : in    std_logic;                                  -- Adv/Ld#
      Bwa_n : in    std_logic;                                  -- Bwa#
      Bwb_n : in    std_logic;                                  -- BWb#
      Bwc_n : in    std_logic;                                  -- Bwc#
      Bwd_n : in    std_logic;                                  -- BWd#
      Rw_n  : in    std_logic;                                  -- RW#
      Oe_n  : in    std_logic;                                  -- OE#
      Ce_n  : in    std_logic;                                  -- CE#
      Ce2_n : in    std_logic;                                  -- CE2#
      Ce2   : in    std_logic;                                  -- CE2
      Zz    : in    std_logic                                   -- Snooze Mode
      );
  end component;
  
-- Instanciation du controleur
begin
    process(Clk)
    begin
        DATA_whithin <= "0000" & User_Data_in; --Ajout des 4 bits de parités dans à la donnée
        User_Data_out <= DATA_whithin(31 downto 0); --Renvoie des 32 bits sur la sortie 
    end process; 

    process(Clk)
    begin 
        case state is
            When INIT => 
                state  <= IDLE;
                
            when IDLE =>
                if Ctrl ='1' AND Start ='1' then 
                    state <= READ;
                elsif Ctrl ='0' AND Start ='1' then 
                    state <= WRITE;
                else 
                    state <= IDLE;
                end if;
                
            when READ =>
                if Ctrl ='1' AND Start ='1' then 
                    state <= READ;
                elsif Ctrl ='0' AND Start ='1' then 
                    state <= WRITE;
                else 
                    state <= IDLE;
                end if;
                
            when WRITE =>
                if Ctrl ='1' AND Start ='1' then 
                    state <= READ;
                elsif Ctrl ='0' AND Start ='1' then 
                    state <= WRITE;
                else 
                    state <= IDLE;
                end if;
                
        end case;
    end process;  
    
    process(state)
    begin 
        case state is
            When INIT => 
                --sorties!!!
            when IDLE =>
     
            when READ =>
                
            when WRITE =>
                
        end case;
    end process;  
end Behavioral;
