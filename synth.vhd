library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity UART_RX is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    DIN: in std_logic;
    DOUT: out std_logic_vector (7 downto 0);
    DOUT_VLD: out std_logic
  );
end entity UART_RX;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_fsm is
  port (
    clk : in std_logic;
    rst : in std_logic;
    din : in std_logic;
    cnt_bit : in std_logic_vector (3 downto 0);
    cnt_clock : in std_logic_vector (4 downto 0);
    stop_bit_in : in std_logic;
    read_en : out std_logic;
    data_valid : out std_logic;
    cnt_en : out std_logic;
    stop_bit_en : out std_logic);
end entity uart_rx_fsm;

architecture rtl of uart_rx_fsm is
  signal state : std_logic_vector (2 downto 0);
  signal n109_o : std_logic;
  signal n110_o : std_logic;
  signal n114_o : std_logic;
  signal n116_o : std_logic;
  signal n117_o : std_logic;
  signal n119_o : std_logic;
  signal n120_o : std_logic;
  signal n121_o : std_logic;
  signal n125_o : std_logic;
  signal n126_o : std_logic;
  signal n130_o : std_logic;
  signal n131_o : std_logic;
  signal n136_o : std_logic;
  signal n138_o : std_logic_vector (2 downto 0);
  signal n140_o : std_logic;
  signal n142_o : std_logic;
  signal n144_o : std_logic_vector (2 downto 0);
  signal n146_o : std_logic;
  signal n148_o : std_logic;
  signal n150_o : std_logic_vector (2 downto 0);
  signal n152_o : std_logic;
  signal n154_o : std_logic_vector (2 downto 0);
  signal n156_o : std_logic;
  signal n158_o : std_logic;
  signal n159_o : std_logic_vector (4 downto 0);
  signal n161_o : std_logic_vector (2 downto 0);
  signal n163_o : std_logic_vector (2 downto 0);
  signal n166_q : std_logic_vector (2 downto 0) := "000";
begin
  read_en <= n110_o;
  data_valid <= n131_o;
  cnt_en <= n121_o;
  stop_bit_en <= n126_o;
  -- uart_rx_fsm.vhd:29:11
  state <= n166_q; -- (isignal)
  -- uart_rx_fsm.vhd:33:30
  n109_o <= '1' when state = "010" else '0';
  -- uart_rx_fsm.vhd:33:19
  n110_o <= '0' when n109_o = '0' else '1';
  -- uart_rx_fsm.vhd:34:30
  n114_o <= '1' when state = "001" else '0';
  -- uart_rx_fsm.vhd:34:53
  n116_o <= '1' when state = "010" else '0';
  -- uart_rx_fsm.vhd:34:44
  n117_o <= n114_o or n116_o;
  -- uart_rx_fsm.vhd:34:75
  n119_o <= '1' when state = "011" else '0';
  -- uart_rx_fsm.vhd:34:66
  n120_o <= n117_o or n119_o;
  -- uart_rx_fsm.vhd:34:19
  n121_o <= '0' when n120_o = '0' else '1';
  -- uart_rx_fsm.vhd:35:34
  n125_o <= '1' when state = "011" else '0';
  -- uart_rx_fsm.vhd:35:23
  n126_o <= '0' when n125_o = '0' else '1';
  -- uart_rx_fsm.vhd:36:33
  n130_o <= '1' when state = "100" else '0';
  -- uart_rx_fsm.vhd:36:22
  n131_o <= '0' when n130_o = '0' else '1';
  -- uart_rx_fsm.vhd:48:23
  n136_o <= not din;
  -- uart_rx_fsm.vhd:48:16
  n138_o <= state when n136_o = '0' else "001";
  -- uart_rx_fsm.vhd:47:13
  n140_o <= '1' when state = "000" else '0';
  -- uart_rx_fsm.vhd:55:29
  n142_o <= '1' when cnt_clock = "10111" else '0';
  -- uart_rx_fsm.vhd:55:16
  n144_o <= state when n142_o = '0' else "010";
  -- uart_rx_fsm.vhd:54:13
  n146_o <= '1' when state = "001" else '0';
  -- uart_rx_fsm.vhd:62:27
  n148_o <= '1' when cnt_bit = "1001" else '0';
  -- uart_rx_fsm.vhd:62:16
  n150_o <= state when n148_o = '0' else "011";
  -- uart_rx_fsm.vhd:61:13
  n152_o <= '1' when state = "010" else '0';
  -- uart_rx_fsm.vhd:69:16
  n154_o <= state when stop_bit_in = '0' else "100";
  -- uart_rx_fsm.vhd:68:13
  n156_o <= '1' when state = "011" else '0';
  -- uart_rx_fsm.vhd:75:13
  n158_o <= '1' when state = "100" else '0';
  n159_o <= n158_o & n156_o & n152_o & n146_o & n140_o;
  -- uart_rx_fsm.vhd:43:10
  with n159_o select n161_o <=
    "000" when "10000",
    n154_o when "01000",
    n150_o when "00100",
    n144_o when "00010",
    n138_o when "00001",
    state when others;
  -- uart_rx_fsm.vhd:40:7
  n163_o <= n161_o when rst = '0' else "000";
  -- uart_rx_fsm.vhd:39:4
  process (clk)
  begin
    if rising_edge (clk) then
      n166_q <= n163_o;
    end if;
  end process;
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of uart_rx is
  signal wrap_CLK: std_logic;
  signal wrap_RST: std_logic;
  signal wrap_DIN: std_logic;
  subtype typwrap_DOUT is std_logic_vector (7 downto 0);
  signal wrap_DOUT: typwrap_DOUT;
  signal wrap_DOUT_VLD: std_logic;
  signal cnt_bit : std_logic_vector (3 downto 0);
  signal cnt_clock : std_logic_vector (4 downto 0);
  signal read_en : std_logic;
  signal cnt_en : std_logic;
  signal stop_bit_in : std_logic;
  signal stop_bit_en : std_logic;
  signal data_valid : std_logic;
  signal fsm_c_read_en : std_logic;
  signal fsm_c_data_valid : std_logic;
  signal fsm_c_cnt_en : std_logic;
  signal fsm_c_stop_bit_en : std_logic;
  signal n9_o : std_logic;
  signal n10_o : std_logic;
  signal n11_o : std_logic;
  constant n12_o : std_logic_vector (7 downto 0) := "00000000";
  signal n13_o : std_logic_vector (7 downto 0);
  signal n15_o : std_logic_vector (3 downto 0);
  signal n17_o : std_logic_vector (4 downto 0);
  signal n19_o : std_logic_vector (4 downto 0);
  signal n22_o : std_logic;
  signal n25_o : std_logic;
  signal n27_o : std_logic;
  signal n29_o : std_logic;
  signal n30_o : std_logic;
  signal n32_o : std_logic;
  signal n34_o : std_logic;
  signal n36_o : std_logic;
  signal n38_o : std_logic;
  signal n40_o : std_logic;
  signal n42_o : std_logic;
  signal n44_o : std_logic;
  signal n46_o : std_logic;
  signal n47_o : std_logic_vector (7 downto 0);
  signal n48_o : std_logic;
  signal n49_o : std_logic;
  signal n50_o : std_logic;
  signal n51_o : std_logic;
  signal n52_o : std_logic;
  signal n53_o : std_logic;
  signal n54_o : std_logic;
  signal n55_o : std_logic;
  signal n56_o : std_logic;
  signal n57_o : std_logic;
  signal n58_o : std_logic;
  signal n59_o : std_logic;
  signal n60_o : std_logic;
  signal n61_o : std_logic;
  signal n62_o : std_logic;
  signal n63_o : std_logic;
  signal n64_o : std_logic;
  signal n65_o : std_logic;
  signal n66_o : std_logic;
  signal n67_o : std_logic;
  signal n68_o : std_logic;
  signal n69_o : std_logic;
  signal n70_o : std_logic;
  signal n71_o : std_logic;
  signal n72_o : std_logic;
  signal n73_o : std_logic;
  signal n74_o : std_logic;
  signal n75_o : std_logic;
  signal n76_o : std_logic;
  signal n77_o : std_logic;
  signal n78_o : std_logic;
  signal n79_o : std_logic;
  signal n81_o : std_logic_vector (3 downto 0);
  signal n82_o : std_logic_vector (7 downto 0);
  signal n83_o : std_logic_vector (7 downto 0);
  signal n84_o : std_logic_vector (3 downto 0);
  signal n86_o : std_logic_vector (4 downto 0);
  signal n87_o : std_logic;
  signal n88_o : std_logic;
  signal n89_o : std_logic;
  signal n96_q : std_logic_vector (3 downto 0);
  signal n97_q : std_logic_vector (4 downto 0);
  signal n98_o : std_logic;
  signal n99_q : std_logic;
  signal n100_q : std_logic_vector (7 downto 0);
  signal n101_q : std_logic;
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  dout <= wrap_dout;
  dout_vld <= wrap_dout_vld;
  wrap_DOUT <= n100_q;
  wrap_DOUT_VLD <= n101_q;
  -- uart_rx.vhd:24:12
  cnt_bit <= n96_q; -- (signal)
  -- uart_rx.vhd:25:12
  cnt_clock <= n97_q; -- (signal)
  -- uart_rx.vhd:27:12
  read_en <= fsm_c_read_en; -- (signal)
  -- uart_rx.vhd:28:12
  cnt_en <= fsm_c_cnt_en; -- (signal)
  -- uart_rx.vhd:30:12
  stop_bit_in <= n99_q; -- (signal)
  -- uart_rx.vhd:31:12
  stop_bit_en <= fsm_c_stop_bit_en; -- (signal)
  -- uart_rx.vhd:33:12
  data_valid <= fsm_c_data_valid; -- (signal)
  -- uart_rx.vhd:38:5
  fsm : entity work.uart_rx_fsm port map (
    clk => wrap_CLK,
    rst => wrap_RST,
    din => wrap_DIN,
    cnt_bit => cnt_bit,
    cnt_clock => cnt_clock,
    stop_bit_in => stop_bit_in,
    read_en => fsm_c_read_en,
    data_valid => fsm_c_data_valid,
    cnt_en => fsm_c_cnt_en,
    stop_bit_en => fsm_c_stop_bit_en);
  -- uart_rx.vhd:61:16
  n9_o <= not read_en;
  -- uart_rx.vhd:61:30
  n10_o <= not wrap_DIN;
  -- uart_rx.vhd:61:22
  n11_o <= n9_o and n10_o;
  -- uart_rx.vhd:61:5
  n13_o <= n100_q when n11_o = '0' else "00000000";
  -- uart_rx.vhd:61:5
  n15_o <= cnt_bit when n11_o = '0' else "0000";
  -- uart_rx.vhd:70:32
  n17_o <= std_logic_vector (unsigned (cnt_clock) + unsigned'("00001"));
  -- uart_rx.vhd:69:5
  n19_o <= "00000" when cnt_en = '0' else n17_o;
  -- uart_rx.vhd:77:5
  n22_o <= '0' when data_valid = '0' else '1';
  -- uart_rx.vhd:85:5
  n25_o <= stop_bit_en and wrap_DIN;
  -- uart_rx.vhd:94:22
  n27_o <= '1' when cnt_clock = "01111" else '0';
  -- uart_rx.vhd:94:45
  n29_o <= '1' when cnt_clock = "11000" else '0';
  -- uart_rx.vhd:94:32
  n30_o <= n27_o or n29_o;
  -- uart_rx.vhd:97:17
  n32_o <= '1' when cnt_bit = "0000" else '0';
  -- uart_rx.vhd:98:17
  n34_o <= '1' when cnt_bit = "0001" else '0';
  -- uart_rx.vhd:99:17
  n36_o <= '1' when cnt_bit = "0010" else '0';
  -- uart_rx.vhd:100:17
  n38_o <= '1' when cnt_bit = "0011" else '0';
  -- uart_rx.vhd:101:17
  n40_o <= '1' when cnt_bit = "0100" else '0';
  -- uart_rx.vhd:102:17
  n42_o <= '1' when cnt_bit = "0101" else '0';
  -- uart_rx.vhd:103:17
  n44_o <= '1' when cnt_bit = "0110" else '0';
  -- uart_rx.vhd:104:17
  n46_o <= '1' when cnt_bit = "0111" else '0';
  n47_o <= n46_o & n44_o & n42_o & n40_o & n38_o & n36_o & n34_o & n32_o;
  n48_o <= n12_o (0);
  n49_o <= n100_q (0);
  -- uart_rx.vhd:61:5
  n50_o <= n49_o when n11_o = '0' else n48_o;
  -- uart_rx.vhd:96:13
  with n47_o select n51_o <=
    n50_o when "10000000",
    n50_o when "01000000",
    n50_o when "00100000",
    n50_o when "00010000",
    n50_o when "00001000",
    n50_o when "00000100",
    n50_o when "00000010",
    wrap_DIN when "00000001",
    n50_o when others;
  n52_o <= n12_o (1);
  n53_o <= n100_q (1);
  -- uart_rx.vhd:61:5
  n54_o <= n53_o when n11_o = '0' else n52_o;
  -- uart_rx.vhd:96:13
  with n47_o select n55_o <=
    n54_o when "10000000",
    n54_o when "01000000",
    n54_o when "00100000",
    n54_o when "00010000",
    n54_o when "00001000",
    n54_o when "00000100",
    wrap_DIN when "00000010",
    n54_o when "00000001",
    n54_o when others;
  n56_o <= n12_o (2);
  n57_o <= n100_q (2);
  -- uart_rx.vhd:61:5
  n58_o <= n57_o when n11_o = '0' else n56_o;
  -- uart_rx.vhd:96:13
  with n47_o select n59_o <=
    n58_o when "10000000",
    n58_o when "01000000",
    n58_o when "00100000",
    n58_o when "00010000",
    n58_o when "00001000",
    wrap_DIN when "00000100",
    n58_o when "00000010",
    n58_o when "00000001",
    n58_o when others;
  n60_o <= n12_o (3);
  n61_o <= n100_q (3);
  -- uart_rx.vhd:61:5
  n62_o <= n61_o when n11_o = '0' else n60_o;
  -- uart_rx.vhd:96:13
  with n47_o select n63_o <=
    n62_o when "10000000",
    n62_o when "01000000",
    n62_o when "00100000",
    n62_o when "00010000",
    wrap_DIN when "00001000",
    n62_o when "00000100",
    n62_o when "00000010",
    n62_o when "00000001",
    n62_o when others;
  n64_o <= n12_o (4);
  n65_o <= n100_q (4);
  -- uart_rx.vhd:61:5
  n66_o <= n65_o when n11_o = '0' else n64_o;
  -- uart_rx.vhd:96:13
  with n47_o select n67_o <=
    n66_o when "10000000",
    n66_o when "01000000",
    n66_o when "00100000",
    wrap_DIN when "00010000",
    n66_o when "00001000",
    n66_o when "00000100",
    n66_o when "00000010",
    n66_o when "00000001",
    n66_o when others;
  n68_o <= n12_o (5);
  n69_o <= n100_q (5);
  -- uart_rx.vhd:61:5
  n70_o <= n69_o when n11_o = '0' else n68_o;
  -- uart_rx.vhd:96:13
  with n47_o select n71_o <=
    n70_o when "10000000",
    n70_o when "01000000",
    wrap_DIN when "00100000",
    n70_o when "00010000",
    n70_o when "00001000",
    n70_o when "00000100",
    n70_o when "00000010",
    n70_o when "00000001",
    n70_o when others;
  n72_o <= n12_o (6);
  n73_o <= n100_q (6);
  -- uart_rx.vhd:61:5
  n74_o <= n73_o when n11_o = '0' else n72_o;
  -- uart_rx.vhd:96:13
  with n47_o select n75_o <=
    n74_o when "10000000",
    wrap_DIN when "01000000",
    n74_o when "00100000",
    n74_o when "00010000",
    n74_o when "00001000",
    n74_o when "00000100",
    n74_o when "00000010",
    n74_o when "00000001",
    n74_o when others;
  n76_o <= n12_o (7);
  n77_o <= n100_q (7);
  -- uart_rx.vhd:61:5
  n78_o <= n77_o when n11_o = '0' else n76_o;
  -- uart_rx.vhd:96:13
  with n47_o select n79_o <=
    wrap_DIN when "10000000",
    n78_o when "01000000",
    n78_o when "00100000",
    n78_o when "00010000",
    n78_o when "00001000",
    n78_o when "00000100",
    n78_o when "00000010",
    n78_o when "00000001",
    n78_o when others;
  -- uart_rx.vhd:107:32
  n81_o <= std_logic_vector (unsigned (cnt_bit) + unsigned'("0001"));
  n82_o <= n79_o & n75_o & n71_o & n67_o & n63_o & n59_o & n55_o & n51_o;
  -- uart_rx.vhd:93:5
  n83_o <= n13_o when n87_o = '0' else n82_o;
  -- uart_rx.vhd:93:5
  n84_o <= n15_o when n88_o = '0' else n81_o;
  -- uart_rx.vhd:93:5
  n86_o <= n19_o when n89_o = '0' else "00000";
  -- uart_rx.vhd:93:5
  n87_o <= read_en and n30_o;
  -- uart_rx.vhd:93:5
  n88_o <= read_en and n30_o;
  -- uart_rx.vhd:93:5
  n89_o <= read_en and n30_o;
  -- uart_rx.vhd:56:5
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n96_q <= n84_o;
    end if;
  end process;
  -- uart_rx.vhd:56:5
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n97_q <= n86_o;
    end if;
  end process;
  -- uart_rx.vhd:56:5
  n98_o <= stop_bit_in when n25_o = '0' else '1';
  -- uart_rx.vhd:56:5
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n99_q <= n98_o;
    end if;
  end process;
  -- uart_rx.vhd:56:5
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n100_q <= n83_o;
    end if;
  end process;
  -- uart_rx.vhd:56:5
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n101_q <= n22_o;
    end if;
  end process;
end rtl;
