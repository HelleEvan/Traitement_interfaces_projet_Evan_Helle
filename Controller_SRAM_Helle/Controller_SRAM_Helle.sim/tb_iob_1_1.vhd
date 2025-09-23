
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

ENTITY tb_test_io_vhd IS
END tb_test_io_vhd;

ARCHITECTURE behavior OF tb_test_io_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT test_io
	PORT(
		CLK : IN std_logic;
		nRESET : IN std_logic;
		TRIG : IN std_logic;
		ENTREE : IN std_logic;    
		E_S : INOUT std_logic;      
		SORTIE : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT mt55l512y36f
	PORT(
        Dq        : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);              -- Data I/O
        Addr      : IN    STD_LOGIC_VECTOR (35 DOWNTO 0);              -- Address
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
    END COMPONENT;
    
	--Inputs
	SIGNAL CLK :  std_logic := '0';
	SIGNAL nRESET :  std_logic := '0';
	SIGNAL TRIG :  std_logic := '0';
	SIGNAL ENTREE :  std_logic := '0';
	
	SIGNAL s_Bwa_n :  std_logic := '0';
	SIGNAL s_Bwb_n :  std_logic := '0';
	SIGNAL s_Bwc_n :  std_logic := '0';
	SIGNAL s_Bwd_n :  std_logic := '0';
	SIGNAL s_Zz    :  std_logic := '0';
	SIGNAL s_Lbo_n :  std_logic := '0';
	SIGNAL s_Cke_n :  std_logic := '0';
	SIGNAL s_Rw_n :  std_logic := '0';
	SIGNAL s_Ce_n :  std_logic := '0';
	SIGNAL s_Ce2_n :  std_logic := '0';
	SIGNAL s_Ce2 :  std_logic := '0';
	SIGNAL s_Oe_n :  std_logic := '0';
	SIGNAL s_Ld_n :  std_logic := '0';
	signal s_Addr : STD_LOGIC_VECTOR (35 DOWNTO 0) := (others => '0');

	--BiDirs
	SIGNAL E_S :  std_logic;
	signal s_Dq : STD_LOGIC_VECTOR (35 DOWNTO 0) := (others => '0');

	--Outputs
	SIGNAL SORTIE :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: test_io PORT MAP(
		SORTIE => SORTIE,
		CLK => CLK,
		nRESET => nRESET,
		TRIG => TRIG,
		E_S => E_S,
		ENTREE => ENTREE
	);

	tb : PROCESS
	BEGIN
	ENTREE <= '0';
	TRIG	<= '0';
	E_S <= 'Z';
	wait for 100 ns;
		-- Wait 100 ns for global reset to finish
		
	ENTREE <= '1';
	TRIG	<= '0';
	wait for 100 ns;
	
	ENTREE <= '0';
	TRIG	<= '0';
	wait for 100 ns;
	
	E_S <= 'Z';
	TRIG	<= '1';
	wait for 2 ns;
	E_S <= '1';
	wait for 100 ns;
	
	E_S <= 'Z';
	wait for 2 ns;
	TRIG	<= '0';
	wait for 100 ns;
		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
