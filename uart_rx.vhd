-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Boris Hatala (xhatal02)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity UART_RX;

-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is

    signal cnt_bit    : std_logic_vector(3 downto 0);
    signal cnt_clock  : std_logic_vector(4 downto 0);

    signal read_en    : std_logic;
    signal cnt_en     : std_logic;

    signal stop_bit_in : std_logic;
    signal stop_bit_en : std_logic;

    signal data_valid : std_logic;

begin

    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM (behavioral)
    port map (
        --input
        CLK => CLK,
        RST => RST,
        DIN => DIN,
        CNT_bit => cnt_bit,
        CNT_clock => cnt_clock,
        STOP_BIT_IN => stop_bit_in,

        --output
        READ_EN => read_en,
        CNT_EN => cnt_en,
        DATA_VALID => data_valid,
        STOP_BIT_EN => stop_bit_en
    );

    process(CLK) begin
    if rising_edge(CLK) then

    ------------------------------
    
    --reset cnt_bit at new reading
    if read_en = '0' and DIN = '0' then
        cnt_bit <= "0000";
        DOUT <= (others => '0');
    end if;

    ------------------------------

    --iterate clock counter
    if cnt_en = '1' then
        cnt_clock <= cnt_clock + 1;
    else
        cnt_clock <= "00000";
    end if;
        
    ------------------------------
    
    if data_valid = '1' then
        DOUT_VLD <= '1';
    else
        DOUT_VLD <= '0';
    end if;

    ------------------------------

    if stop_bit_en = '1' then
        if DIN = '1' then
           stop_bit_in <= '1';
        end if;
    end if;
    
    ------------------------------

    if read_en = '1' then
        if cnt_clock = "01111" or cnt_clock = "11000" then --at midbit or at the end 
            cnt_clock <= "00000";
            case cnt_bit is
                when "0000" => DOUT(0) <= DIN;
                when "0001" => DOUT(1) <= DIN;
                when "0010" => DOUT(2) <= DIN;
                when "0011" => DOUT(3) <= DIN;
                when "0100" => DOUT(4) <= DIN;
                when "0101" => DOUT(5) <= DIN;
                when "0110" => DOUT(6) <= DIN;
                when "0111" => DOUT(7) <= DIN;
                when others => null;
            end case;
            cnt_bit <= cnt_bit + 1;
        end if;
    end if;

    ------------------------------

    end if;
    end process;
end behavioral;
