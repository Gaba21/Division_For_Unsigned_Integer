library ieee;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

--! This module realizes the algorithm of restoring division
--! https://www.geeksforgeeks.org/restoring-division-algorithm-unsigned-integer/

entity restoring_division_tb is
  generic (
    m              : integer := 4; --! Divisor
    width_dividend : integer := 8  --! With dividend register
  );
end entity restoring_division_tb;

architecture tb_arch of restoring_division_tb is

  component restoring_division is
    generic (
      m              : integer;
      width_dividend : integer
    );
    port (
      clk          : in    std_logic;
      clkena       : in    std_logic;
      reset        : in    std_logic;
      dividend     : in    std_logic_vector(width_dividend - 1 downto 0);
      dividend_ena : in    std_logic;
      result_valid : out   std_logic;
      int_value    : out   std_logic_vector(width_dividend - 1 downto 0);
      remaind      : out   std_logic_vector(width_dividend - 2 downto 0)
    );
  end component;

  signal clk          : std_logic := '0';
  signal clkena       : std_logic := '1';
  signal reset        : std_logic;
  signal dividend     : std_logic_vector(width_dividend - 1 downto 0) := (others => '0') ;
  signal dividend_ena : std_logic:= '0';
  signal result_valid : std_logic := '0';
  signal int_value    : std_logic_vector(width_dividend - 1 downto 0) := (others => '0') ;
  signal remaind      : std_logic_vector(width_dividend - 2 downto 0) := (others => '0') ;

begin

  clk   <= not clk after 5 ns;
  reset <= '1', '0' after 50 ns;

  div_tb : component restoring_division
    generic map (
      m              => m,
      width_dividend => width_dividend
    )
    port map (
      clk          => clk,
      clkena       => clkena,
      reset        => reset,
      dividend     => dividend,
      dividend_ena => dividend_ena,
      result_valid => result_valid,
      int_value    => int_value,
      remaind      => remaind
    );

  test_proc : process is
  begin
    wait for 100 ns;
    wait until rising_edge(clk);
    dividend_ena <= '1';                  -- set ena in 1
    report "Dividend value = 0x15";
    dividend     <= x"15";               -- send dividend data
    wait until rising_edge(clk);
    dividend_ena <= '0';                  -- set ena in 0
    wait until rising_edge(clk);
    wait until rising_edge(result_valid); -- wait result data
    report "Int value = " & integer'image(to_integer(unsigned(int_value)));
    report "Remaind value = " & integer'image(to_integer(unsigned(remaind)));
    wait;

  end process test_proc;

end architecture tb_arch;
