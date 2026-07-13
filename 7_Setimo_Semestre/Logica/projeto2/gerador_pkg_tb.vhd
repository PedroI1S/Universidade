-- =====================================================================
-- Projeto: PR2 - Gerador de Sinais (DE10-Lite)
-- Disciplina: Logica Reconfiguravel - LR27CP-7CP
-- Alunos/RAs: TODO (nome - RA; um por linha)
-- Onda implementada: dente de serra / rampa crescente (wav 5)
-- Link do video: TODO
-- Valor de R (R-2R): TODO (recomendado 10k, 2R=20k)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gerador_pkg.all;

entity gerador_pkg_tb is
end entity;

architecture sim of gerador_pkg_tb is
begin
  stimulus: process
  begin
    -- incremento DDS = round(freq * 2^32 / clk)
    assert calc_incremento(400, 50000000, 32) = to_unsigned(34360, 32)
      report "calc_incremento 400Hz incorreto" severity error;
    assert calc_incremento(800, 50000000, 32) = to_unsigned(68719, 32)
      report "calc_incremento 800Hz incorreto" severity error;

    -- digitos de 400 -> centena 4, dezena 0, unidade 0
    assert digito_freq(400, 2) = to_unsigned(4, 4) report "digito 400 centena" severity error;
    assert digito_freq(400, 1) = to_unsigned(0, 4) report "digito 400 dezena" severity error;
    assert digito_freq(400, 0) = to_unsigned(0, 4) report "digito 400 unidade" severity error;
    -- digitos de 800 -> centena 8
    assert digito_freq(800, 2) = to_unsigned(8, 4) report "digito 800 centena" severity error;

    report "gerador_pkg_tb: sucesso" severity note;
    wait;
  end process;
end architecture;
