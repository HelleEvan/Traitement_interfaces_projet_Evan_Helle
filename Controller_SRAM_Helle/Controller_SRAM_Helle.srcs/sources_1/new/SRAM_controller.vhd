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
-- synopsys translate_off
library unisim;
use unisim.VComponents.all;
-- synopsys translate_on

entity SRAM_controller is
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
            Zz    : out    std_logic);                                 -- Snooze Mode
end SRAM_controller;


architecture Behavioral of SRAM_controller is
	
    component IOBUF_F_16
      port(
        O  : out   std_logic;
        IO : inout std_logic;
        I  : in    std_logic;
        T  : in    std_logic
        );
    end component; 
    
    signal Data_out_s : STD_LOGIC_VECTOR (35 downto 0);
    signal Data_in_s : STD_LOGIC_VECTOR (35 downto 0);
    signal Dq_s : STD_LOGIC_VECTOR (35 downto 0);
    signal T_s : STD_LOGIC;
    type StateType is(INIT, IDLE, READ, WRITE);
    signal state : StateType;
    signal decalage_data_in_1 : STD_LOGIC_VECTOR (31 downto 0);
    signal decalage_data_in_2 : STD_LOGIC_VECTOR (31 downto 0);
  
-- Instanciation du controleur
begin
    IOb: for I in 0 to 35 generate
    Iobx: IOBUF_F_16  port map(
        O => Data_out_s(I),
        IO => Dq_s(I),  
        I => Data_in_s(I), 
		T => T_s
        );
    end generate;

    process(Clk)
    begin
        if Clk'EVENT and Clk = '1' then 
            --decalage de la donnée de deux fronts montant
            decalage_data_in_1 <= User_Data_in ;
            decalage_data_in_2 <= decalage_data_in_1;
            
            Addr <= User_Address; -- recopier l'adresse d'entrée du controller en entrée de la SRAM
        end if;
    end process; 
    
        process(Clk)
    begin
        if Clk'EVENT and Clk = '0' then -- sur front descendant
            Data_in_s <= "0000" & decalage_data_in_2; --Ajout des 4 bits de parités dans à la donnée
            User_Data_out <= Data_out_s(31 downto 0); --Renvoie des 32 bits sur la sortie 
        end if;
    end process; 

    process(Clk,reset)
    begin 
        if reset ='1' then 
            state  <= INIT;
        
        elsif Clk'EVENT and Clk = '1' then 
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
        end if; 
    end process;
    
    process(state)
    begin 
        case state is
            When INIT => 
                --sorties crtl sram constantes :
                Lbo_n  <='0';                                 -- Burst Mode non instancier pour l'instant
                Ld_n   <='0';                                 -- Adv/Ld# =0 sinon burst actif
                Cke_n  <='0';                                 -- Clock enable
                Bwa_n  <='0';                                 -- Bwa#
                Bwb_n  <='0';                                 -- BWb#
                Bwc_n  <='0';                                 -- Bwc#
                Bwd_n  <='0';                                 -- BWd#                                 
                Zz     <='0';                                 -- Snooze Mode;
                Oe_n   <= '0';                                -- OE#
                Ce_n  <= '0';                                 -- CE#
                Ce2_n <= '0';                                 -- CE2#
                Ce2   <= '1';                                 -- Addr 
                Rw_n <='0';
                T_s <='0';
                Rw_n <= '1'; --protection materiel
            when IDLE =>
                Rw_n <= '1'; --protection materiel
            when READ =>
                Rw_n <= '1'; -- on assignera cette valeur au trigg de la SRAM par la suite
                T_s  <='1';

            when WRITE =>
                Rw_n <= '0';
                T_s  <='0';
                
        end case;
    end process;  
    Dq <= Dq_s;
end Behavioral;
