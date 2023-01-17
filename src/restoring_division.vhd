library ieee;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

--! This module realizes the algorithm of restoring division
--! https://www.geeksforgeeks.org/restoring-division-algorithm-unsigned-integer/

entity restoring_division is
  generic (
    m              : integer; --! Divisor
    width_dividend : integer   --! With dividend register
  );
  port (
    clk          : in    std_logic;                                     --! Clock
    clkena       : in    std_logic;                                     --! Enable to work
    reset        : in    std_logic;                                     --! Reset
    dividend     : in    std_logic_vector(width_dividend - 1 downto 0); --! Dividend register
    dividend_ena : in    std_logic;                                     --! Enable dividend
    result_valid : out   std_logic;                                     --! Valid result value
    int_value    : out   std_logic_vector(width_dividend - 1 downto 0); --! Integer value after division
    remaind      : out   std_logic_vector(width_dividend - 2 downto 0)  --! Reminder value after division
  );
end entity restoring_division;

architecture rtl of restoring_division is

  signal q            : std_logic_vector(width_dividend - 1 downto 0); --! integer value after division
  signal a            : std_logic_vector(width_dividend - 1 downto 0); --! remainder
  signal a_buf        : std_logic_vector(width_dividend - 1 downto 0); --! buffer for remainder value without -m
  signal counter      : integer range 0 to width_dividend;             --! cycles value
  signal change_steps : std_logic;                                     --! Change steps after 1 rising edge

  type state is (idle, div);

  signal fsm : state;

begin

  main_div : process (clk) is
  begin

    if rising_edge(clk) then
      if (reset = '1') then
        result_valid <= '0';
        remaind      <= (others => '0');
        a_buf        <= (others => '0');
        int_value    <= (others => '0');
        a            <= (others => '0');
        q            <= (others => '0');
        counter      <= width_dividend;
      elsif (clkena = '1') then

        case fsm is

          when idle =>

            counter      <= width_dividend;
            result_valid <= '0';
            a            <= (others => '0');

            if (dividend_ena = '1') then
              q <= dividend;
            end if;

          when div =>

            if (counter /= 0) then

              case change_steps is

                when '0' =>

                  a                              <= (a(width_dividend - 2 downto 0) & q(width_dividend - 1)) - std_logic_vector(to_unsigned(m, a'length));
                  a_buf                          <= (a(width_dividend - 2 downto 0) & q(width_dividend - 1));
                  q(width_dividend - 1 downto 0) <= q(width_dividend - 2 downto 0) & "0";

                when '1' =>

                  if (a(width_dividend - 1) = '0') then
                    q(0)    <= not(a(width_dividend - 1));
                    counter <= counter - 1;
                  else
                    a       <= a_buf;
                    q(0)    <= not(a(width_dividend - 1));
                    counter <= counter - 1;
                  end if;

                when others =>

                  null;

              end case;

            else
              remaind      <= a(width_dividend - 2 downto 0);
              int_value    <= q;
              result_valid <= '1';
            end if;

        end case;

      end if;
    end if;

  end process main_div;

  change_steps_proc : process (clk) is
  begin

    if rising_edge(clk) then
      if (reset = '1') then
        change_steps <= '0';
      elsif (clkena = '1') then

        case fsm is

          when div =>

            if (counter /= 0) then
              change_steps <= not change_steps;
            end if;

          when others =>

            change_steps <= '0';

        end case;

      end if;
    end if;

  end process change_steps_proc;

  fsm_proc : process (clk) is
  begin

    if rising_edge(clk) then
      if (reset = '1') then
        fsm <= idle;
      elsif (clkena = '1') then

        case fsm is

          when idle =>

            if (dividend_ena = '1') then
              fsm <= div;
            end if;

          when div =>

            if (counter = 0) then
              fsm <= idle;
            end if;

        end case;

      end if;
    end if;

  end process fsm_proc;

end architecture rtl;
