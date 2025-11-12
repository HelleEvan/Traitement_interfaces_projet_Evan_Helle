----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 09:02:44
-- Design Name: 
-- Module Name: tb_sram_controller - Behavioral
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
USE ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity tb_sram_controller is
--  Port ( );
end tb_sram_controller;

architecture Behavioral of tb_sram_controller is

component SRAM_controller is
    Port ( Clk : in STD_LOGIC;
           Ctrl : in STD_LOGIC; -- read and write permet en un seul port. permet d'éviter un read et write en même temps.
           Start :in STD_LOGIC; -- mettre à 1 pour sortir du Idle
           User_Address : in STD_LOGIC_VECTOR (18 downto 0);
           User_Data_in : in STD_LOGIC_VECTOR (31 downto 0);
           User_Data_out : out STD_LOGIC_VECTOR (31 downto 0);
           reset : in STD_LOGIC;
           --ctrl SRAM 
            Dq    : out    std_logic_vector (35 downto 0);             -- Data I/O
            Addr  : out    std_logic_vector (18 downto 0);             -- Address
            Lbo_n : out    std_logic;                                  -- Burst Mode
            Cke_n : out    std_logic;                                  -- Cke#
            Ld_n  : out    std_logic;                                  -- Adv/Ld#
            Bwa_n : out    std_logic;                                  -- Bwa#
            Bwb_n : out    std_logic;                                  -- BWb#
            Bwc_n : out    std_logic;                                  -- Bwc#
            Bwd_n : out    std_logic;                                  -- BWd#
            Rw_n  : out    std_logic;                                  -- RW#
            Oe_n  : out    std_logic;                                  -- OE#
            Ce_n  : out    std_logic;                                  -- CE#
            Ce2_n : out    std_logic;                                  -- CE2#
            Ce2   : out    std_logic;                                  -- CE2
            Zz    : out    std_logic);                                  -- Snooze Mode;
end component;

  component mt55l512y36f is --SRAM
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

	--constants
  	constant TCLKH    : time := 15 ns;
  	constant TCLKL    : time := 15 ns;
  	--input
    SIGNAL CLKO_SRAM :  std_logic := '0';
    SIGNAL user_Ctrl :  std_logic := '0';
    SIGNAL R_W_enable :  std_logic := '0';
    SIGNAL Addr_in_s :  STD_LOGIC_VECTOR (18 downto 0);
    SIGNAL Addr_out_s :  STD_LOGIC_VECTOR (18 downto 0);
    SIGNAL Data_in_s :  STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL Data_out_s :  STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL reset_s :  std_logic := '0';
    
	SIGNAL nRW_s:  std_logic;
	SIGNAL nOE_s:  std_logic;
	SIGNAL nCE_s:  std_logic;
	SIGNAL nCE2_s:  std_logic;
	SIGNAL CE2_s:  std_logic;
	SIGNAL Lbo_s:  std_logic;
	SIGNAL Cke_s:  std_logic;
	SIGNAL Ld_s:  std_logic;
	SIGNAL Bwa_s:  std_logic;
	SIGNAL Bwb_s:  std_logic;
	SIGNAL Bwc_s:  std_logic;
	SIGNAL Bwd_s:  std_logic;
	SIGNAL Zz_s:  std_logic;
	SIGNAL Trig_s : std_logic;
	SIGNAL DQ_s :  std_logic_vector(35 downto 0);

begin

process
  begin
    CLKO_SRAM <= '0';
    wait for TCLKL;
    CLKO_SRAM <= '1';
    wait for TCLKH;
  end process;

	-- Instantiate the Unit Under Test (UUT)
	SRAM_Ctrl : SRAM_controller port map(
	   Clk => CLKO_SRAM,
       Ctrl => user_Ctrl, 
       Start => R_W_enable,
       User_Address => Addr_in_s,
       User_Data_in => Data_in_s,
       User_Data_out => Data_out_s,
       reset => reset_s,
       --ctrl SRAM 
        Dq    => DQ_s,            -- Data I/O
        Addr  => Addr_out_s,            -- Address
        Lbo_n => Lbo_s,                                 -- Burst Mode
        Cke_n => Cke_s,                                 -- Cke#
        Ld_n  => Ld_s,                                -- Adv/Ld#
        Bwa_n => Bwa_s,                                -- Bwa#
        Bwb_n => Bwb_s,                                 -- BWb#
        Bwc_n => Bwc_s,                                 -- Bwc#
        Bwd_n => Bwd_s,                                 -- BWd#
        Rw_n  => nRW_s,                                 -- RW#
        Oe_n  => nOE_s,                                 -- OE#
        Ce_n  => nCE_s,                                  -- CE#
        Ce2_n => nCE2_s,                                  -- CE2#
        Ce2   => CE2_s,                                  -- CE2
        Zz    => Zz_s);                                 -- Snooze Mode;
	
    SRAM1 : mt55l512y36f port map
        (DQ_s, Addr_out_s, '0', CLKO_SRAM, Cke_s, Ld_s, '0',
        '0', '0', '0', nRW_s, nOE_s, nCE_s, nCE2_s, CE2_s, '0');

    tb : PROCESS
	BEGIN
	   reset_s <= '1';
        
	   wait for 5.8*(TCLKH);
	   Data_in_s <= (others => '1');
	   Addr_in_s <= (others => '0');
	   user_Ctrl <= '1';
	   Trig_s <= '1';
	   R_W_enable <='1';
	   --nRW_s    <= '1';
	   
	   wait for 1*(TCLKH);
	   reset_s <= '0';
	   wait for 5*(TCLKH);
	   user_Ctrl <= '1';
	   Trig_s <= '0';
	   R_W_enable <='0';
	   --nRW_s    <= '0';
	   
	   wait for 1*(TCLKH);
	   user_Ctrl <= '0';
	   Trig_s <= '0';
	   R_W_enable <='0';
	   --nRW_s    <= '0';
	   
	   wait for 1*(TCLKH);
	   user_Ctrl <= '0';
	   Trig_s <= '1';
	   R_W_enable <='1';
	   --nRW_s    <= '1';
	   wait;
	END PROCESS;

end Behavioral;
