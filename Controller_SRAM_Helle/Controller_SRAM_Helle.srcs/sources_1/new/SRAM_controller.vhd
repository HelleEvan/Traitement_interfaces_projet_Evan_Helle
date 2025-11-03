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
           User_Data_in : in STD_LOGIC_VECTOR (31 downto 0);
           User_Data_out : out STD_LOGIC_VECTOR (35 downto 0);
           --CTRL : out STD_LOGIC_VECTOR ();
           Address : out STD_LOGIC_VECTOR(18 downto 0);
           Data : inout STD_LOGIC_VECTOR(35 downto 0));
end SRAM_controller;


architecture Behavioral of SRAM_controller is
    
    signal DATA_whithin : STD_LOGIC_VECTOR (35 downto 0);
    signal reset : STD_LOGIC;
    type StateType is(INIT, IDLE, READ, WRITE);
    signal present_state, next_state : StateType;
    
    component bascule_D 
        Port ( d : in STD_LOGIC;
               clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               q : out STD_LOGIC);
    end component; 
    
begin
    BD: for I in 0 to 31 generate
    BDX: bascule_D   port map(
        q => User_Data_out(I),
        clk => Clk, 
        rst => reset,
        d => User_Data_in(I) 
        );
end generate;
-- Instanciation du controleur à faire

    process(Clk)
    begin
        DATA_whithin <= "0000" & User_Data_in; --Ajout des 4 bits de parités dans à la donnée
        User_Data_out <= DATA_whithin(31 downto 0); --Renvoie des 32 bits sur la sortie 
    end process; 

    process(Clk, present_state)
    begin 
        case present_state is
            When INIT => 
                next_state  <= IDLE;
                
            when IDLE =>
                if read ='1' then 
            when READ =>
                
            when WRITE =>
                
    end process;    

end Behavioral;
