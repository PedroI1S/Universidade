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

entity decodificador_7seg_tb is
end entity;

architecture sim of decodificador_7seg_tb is
  signal valor : unsigned(3 downto 0) := (others => '0');
  signal seg   : std_logic_vector(6 downto 0);
begin
  dut: entity work.decodificador_7seg port map (valor => valor, seg => seg);

  stimulus: process
  begin
    valor <= to_unsigned(0, 4); wait for 10 ns;
    assert seg = "1000000" report "digito 0 incorreto" severity error;

    valor <= to_unsigned(5, 4); wait for 10 ns;
    assert seg = "0010010" report "digito 5 incorreto" severity error;

    valor <= to_unsigned(8, 4); wait for 10 ns;
    assert seg = "0000000" report "digito 8 incorreto" severity error;

    valor <= to_unsigned(1, 4); wait for 10 ns;
    assert seg = "1111001" report "digito 1 incorreto" severity error;

    report "decodificador_7seg_tb: sucesso" severity note;
    wait;
  end process;
end architecture;
