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
use std.env.all;

entity acumulador_fase_tb is
end entity;

architecture sim of acumulador_fase_tb is
  constant W : natural := 4;
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal inc : unsigned(W-1 downto 0) := to_unsigned(3, W);
  signal fase : unsigned(W-1 downto 0);
begin
  dut: entity work.acumulador_fase
    generic map (ACC_WIDTH => W)
    port map (clk => clk, rst => rst, incremento => inc, fase => fase);

  clk <= not clk after 5 ns;

  stimulus: process
  begin
    -- reset sincrono zera a fase
    rst <= '1'; wait until rising_edge(clk); wait for 1 ns;
    assert fase = to_unsigned(0, W) report "reset nao zerou" severity error;

    rst <= '0';
    wait until rising_edge(clk); wait for 1 ns;
    assert fase = to_unsigned(3, W) report "passo 1" severity error;
    wait until rising_edge(clk); wait for 1 ns;
    assert fase = to_unsigned(6, W) report "passo 2" severity error;
    wait until rising_edge(clk); wait for 1 ns;
    assert fase = to_unsigned(9, W) report "passo 3" severity error;
    wait until rising_edge(clk); wait for 1 ns;
    assert fase = to_unsigned(12, W) report "passo 4" severity error;
    wait until rising_edge(clk); wait for 1 ns;
    assert fase = to_unsigned(15, W) report "passo 5" severity error;
    wait until rising_edge(clk); wait for 1 ns;
    assert fase = to_unsigned(2, W) report "wrap (18 mod 16 = 2)" severity error;

    report "acumulador_fase_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
