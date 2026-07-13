-- =====================================================================
-- Projeto: PR3 - Maquina de Lavar (DE10-Lite)
-- Disciplina: Logica Reconfiguravel - LR27CP-7CP - Prof. MSc. Andre Macario Barros
-- Equipe (nome - RA):
--   Rodrigo Rodriguez Tato Gama da Silva - RA: 2562804
--   Pedro Mariano dos Santos             - RA: 2562790
--   Marlon Mezomo Gotardo                - RA: 2562766
-- Circuito implementado: FSM stand by / enxague / molho / centrifuga
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity divisor_clock_tb is
end entity;

architecture sim of divisor_clock_tb is
  signal clk    : std_logic := '0';
  signal rst    : std_logic := '1';
  signal enable : std_logic;
  signal contagem : integer := 0;   -- ciclos desde o ultimo enable
  signal medido   : integer := -1;  -- periodo medido
begin
  dut: entity work.divisor_clock
    generic map (DIV => 4)
    port map (clk => clk, rst => rst, enable => enable);

  clk <= not clk after 5 ns;

  medidor: process(clk)
  begin
    if rising_edge(clk) and rst = '0' then
      if enable = '1' then
        medido   <= contagem + 1;
        contagem <= 0;
      else
        contagem <= contagem + 1;
      end if;
    end if;
  end process;

  stimulus: process
  begin
    wait for 12 ns;
    rst <= '0';
    wait for 200 ns;
    assert medido = 4 report "periodo do divisor incorreto (esperado 4)" severity error;
    report "divisor_clock_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
