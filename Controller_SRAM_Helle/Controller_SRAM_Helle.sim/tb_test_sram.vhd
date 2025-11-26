
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:30:51 02/21/2007
-- Design Name:   test_io
-- Module Name:   D:/users/infotronique/jd/test/tb_test_io.vhd
-- Project Name:  test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_io
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

-- synopsys translate_off
library unisim;
use unisim.VComponents.all;

ENTITY tb_test_sram IS
END tb_test_sram ;

ARCHITECTURE behavior OF tb_test_sram IS 

	-- Component Declaration for the Unit Under Test (UUT)
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
    
    component IOBUF_F_16
  port(
    O  : out   std_logic;
    IO : inout std_logic;
    I  : in    std_logic;
    T  : in    std_logic
    );
end component; 

--    component test_io
--    PORT(
--		CLK : IN std_logic;
--		nRESET : IN std_logic;
--		TRIG : IN std_logic;
--		ENTREE : IN std_logic;    
--		E_S : INOUT std_logic;      
--		SORTIE : OUT std_logic
--		);
--	END COMPONENT;
 
	--constants
  	constant TCLKH    : time := 15 ns;
  	constant TCLKL    : time := 15 ns;

	--Inputs
	SIGNAL CLKO_SRAM :  std_logic := '0';
	SIGNAL nCKE :  std_logic := '0';
	SIGNAL nADVLD :  std_logic := '0';
	--SIGNAL nRW:  std_logic := '0'; plus utile, on met trig de l'io buff à la place
	SIGNAL nOE:  std_logic := '0';
	SIGNAL nCE:  std_logic := '0';
	SIGNAL nCE2:  std_logic := '0';
	SIGNAL CE2:  std_logic := '0';
	SIGNAL SA :  std_logic_vector(18 downto 0);
	SIGNAL ENTREE : std_logic_vector(35 downto 0);
	SIGNAL Trig : std_logic := '0';
	SIGNAL reset : std_logic := '0';

	--BiDirs
	SIGNAL DQ :  std_logic_vector(35 downto 0);

    --Output
	SIGNAL SORTIE : std_logic_vector(35 downto 0);

BEGIN
  process
  begin
    CLKO_SRAM <= '0';
    wait for TCLKL;
    CLKO_SRAM <= '1';
    wait for TCLKH;
  end process;

	-- Instantiate the Unit Under Test (UUT)
  SRAM1 : mt55l512y36f port map
    (DQ, SA, '0', CLKO_SRAM, nCKE, nADVLD, '0',
     '0', '0', '0', Trig, nOE, nCE, nCE2, CE2, '0');
     
IOb: for I in 0 to 35 generate
    Iobx: IOBUF_F_16  port map(
        O => SORTIE(I),
        IO => DQ(I),  
        I => ENTREE(I), 
		T => Trig
        );
end generate;

tb : PROCESS
	BEGIN
	-- init
    nCKE    <= '0';
    nADVLD  <= '0';
    nOE     <= '0';-- output enable
    nCE     <= '0';
	nCE2    <= '0';
    CE2     <= '1';
    SA      <= (others => '0');
    Trig    <='1'; -- se mettre en "lecture" le temps de l'init pour ne pas ecrire n'importe quoi 

    wait for 6*(TCLKL+TCLKH);
    SA 		<= "000"&x"0001";
    Trig    <= '0'; -- ecriture à l'adresse 1
    wait for 1*(TCLKL); -- pour travailler sur front montant
	ENTREE  <= (others => '1'); -- decalage de la donnée d'un cycle par rapport à l'adresse et la commande
 
   
	wait for 2*(TCLKL+TCLKH);
	SA 		<= "000"&x"0002"; -- eriture à l'adress 2
	wait for 1*(TCLKL+TCLKH);
	ENTREE  <= ENTREE + 1;-- decalage de la donnée d'un cycle par rapport à l'adresse et la commande
          
    wait for 2*(TCLKH+TCLKL);
    SA 		<= "000"&x"0001"; -- lecture à l'adresse 1
    Trig <= '1';
    wait for 2*(TCLKH+TCLKL);
    SA 		<= "000"&x"0002"; -- lecture à l'adresse 2
    
	wait; -- will wait forever
END PROCESS;
END;
