----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2022 01:42:46 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC);
end top;

architecture Behavioral of top is

    constant c_CNT_WIDTH         : natural := 4;
    constant c_CNT_WIDTH2         : natural := 16;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

  -- Internal clock enable
  signal s_en  : std_logic;
  -- Internal counter
  signal s_cnt : std_logic_vector(4 - 1 downto 0);

begin

  --------------------------------------------------------------------
  -- Instance (copy) of clock_enable entity
  clk_en0 : entity work.clock_enable
      generic map(
          g_MAX => 25000000
      )
      port map(
          clk   => CLK100MHZ,--- WRITE YOUR CODE HERE
          reset => BTNC,--- WRITE YOUR CODE HERE
          ce_o  => s_en
      );

  --------------------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity
  bin_cnt0 : entity work.cnt_up_down
     generic map(
         g_CNT_WIDTH  => c_CNT_WIDTH
          --- WRITE YOUR CODE HERE
      )
      port map(
        clk      => CLK100MHZ,
        reset    => BTNC,  -- Synchronous reset
        en_i     => s_en,  -- Enable input
        cnt_up_i => SW,  -- Direction of the counter
        cnt_o    => s_cnt
      );
      
      clk_en1 : entity work.clock_enable
      generic map(
          g_MAX => 25000000
      )
      port map(
          clk   => CLK100MHZ,--- WRITE YOUR CODE HERE
          reset => BTNC,--- WRITE YOUR CODE HERE
          ce_o  => s_en
      );

  --------------------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity
  bin_cnt1 : entity work.cnt_up_down
     generic map(
         g_CNT_WIDTH  => c_CNT_WIDTH
          --- WRITE YOUR CODE HERE
      )
      port map(
        clk      => CLK100MHZ,
        reset    => BTNC,  -- Synchronous reset
        en_i     => s_en,  -- Enable input
        cnt_up_i => SW,  -- Direction of the counter
        cnt_o    => LED
      );

  --------------------------------------------------------------------
  -- Instance (copy) of hex_7seg entity
  hex2seg : entity work.hex_7seg
      port map(
          hex_i    => s_cnt,
          seg_o(6) => CA,
          seg_o(5) => CB,
          seg_o(4) => CC,
          seg_o(3) => CD,
          seg_o(2) => CE,
          seg_o(1) => CF,
          seg_o(0) => CG
      );

  -- Connect one common anode to 3.3V
  AN <= b"1111_1110";

  -- Display counter values on LEDs
  LED(3 downto 0) <= s_cnt;

end Behavioral;
