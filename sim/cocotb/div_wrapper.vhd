library ieee;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity div_wrapper is
  generic (
    m              : integer := 4; --! Divisor
    width_dividend : integer := 8  --! With dividend register
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
end entity div_wrapper;

architecture div_wrapper of div_wrapper is

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

begin

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

end architecture div_wrapper;
