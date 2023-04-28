-- uart_tx_fsm.vhd: UART controller - finite state machine controlling TX side
-- Author(s): Boris Hatala (xhatal02)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART_RX_FSM is
    port(
      -- input
      CLK         : in std_logic;
      RST         : in std_logic;
      DIN         : in std_logic;                     
      CNT_bit     : in std_logic_vector(3 downto 0);
      CNT_clock   : in std_logic_vector(4 downto 0);
      STOP_BIT_IN : in std_logic;
       
      --output
      READ_EN     : out std_logic;
      DATA_VALID  : out std_logic;
      CNT_EN      : out std_logic;
      STOP_BIT_EN : out std_logic
    );
end entity UART_RX_FSM; 

architecture behavioral of UART_RX_FSM is

   type STATE_TYPE is (WAIT_START, START_COUNT, READ_STATE, END_STATE, VALIDATION); 
   signal state : STATE_TYPE := WAIT_START;

begin

   READ_EN <= '1' when state = READ_STATE else '0';
   CNT_EN  <= '1' when state = START_COUNT or state = READ_STATE or state = END_STATE else '0';
   STOP_BIT_EN <= '1' when state = END_STATE else '0';
   DATA_VALID <= '1' when state = VALIDATION else '0';

   process (CLK) begin
   if rising_edge (CLK) then
      if RST = '1' then
         state <= WAIT_START;
      else
         case state is
            
             ------------------------------s

            when WAIT_START =>
               if DIN = '0' then
                  state <= START_COUNT;
               end if;

             ------------------------------

            when START_COUNT =>
               if CNT_clock = "10111" then   --23
                  state <= READ_STATE;
               end if;

             ------------------------------

            when READ_STATE =>
               if CNT_bit = "1001" then      --9
                  state <= END_STATE;
               end if;

             ------------------------------

            when END_STATE =>
               if STOP_BIT_IN = '1' then
                  state <= VALIDATION;
               end if;

             ------------------------------
            
            when VALIDATION =>
               state <= WAIT_START;
            
             ------------------------------
            
            when others => null;
         end case;
      end if;
   end if;   
   end process;

end behavioral;
