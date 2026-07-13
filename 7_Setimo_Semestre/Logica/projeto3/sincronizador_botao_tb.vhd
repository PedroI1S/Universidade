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

entity sincronizador_botao_tb is
end entity;

architecture sim of sincronizador_botao_tb is
  signal clk     : std_logic := '0';
  signal botao_n : std_logic := '1';  -- idle
  signal pulso   : std_logic;
  signal n_pulsos : integer := 0;
begin
  dut: entity work.sincronizador_botao
    generic map (DEBOUNCE_CICLOS => 3)
    port map (clk => clk, botao_n => botao_n, pulso => pulso);

  clk <= not clk after 5 ns;

  contador: process(clk)
  begin
    if rising_edge(clk) and pulso = '1' then
      n_pulsos <= n_pulsos + 1;
    end if;
  end process;

  stimulus: process
  begin
    -- bounce na descida (pressionar): alterna antes de estabilizar em 0
    wait for 20 ns;
    botao_n <= '0'; wait for 10 ns;
    botao_n <= '1'; wait for 10 ns;   -- glitch
    botao_n <= '0'; wait for 200 ns;  -- estabiliza pressionado
    -- soltar
    botao_n <= '1'; wait for 200 ns;
    -- segundo toque limpo
    botao_n <= '0'; wait for 200 ns;
    botao_n <= '1'; wait for 100 ns;

    assert n_pulsos = 2
      report "esperados 2 pulsos (2 toques), obtido outro valor" severity error;
    report "sincronizador_botao_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
