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

entity conformador_onda_tb is
end entity;

architecture sim of conformador_onda_tb is
  signal fase_msb : unsigned(7 downto 0) := (others => '0');
  signal sel_onda : std_logic := '0';
  signal dado     : std_logic_vector(7 downto 0);
begin
  dut: entity work.conformador_onda
    generic map (N_BITS => 8)
    port map (fase_msb => fase_msb, sel_onda => sel_onda, dado => dado);

  stimulus: process
  begin
    -- dente de serra: dado = fase_msb
    sel_onda <= '1';
    fase_msb <= to_unsigned(170, 8); wait for 10 ns;  -- 10101010
    assert dado = "10101010" report "serra incorreta" severity error;
    fase_msb <= to_unsigned(255, 8); wait for 10 ns;
    assert dado = "11111111" report "serra topo incorreto" severity error;

    -- quadrada: dado = MSB replicado
    sel_onda <= '0';
    fase_msb <= to_unsigned(127, 8); wait for 10 ns;  -- MSB=0 -> 0x00
    assert dado = "00000000" report "quadrada baixa incorreta" severity error;
    fase_msb <= to_unsigned(128, 8); wait for 10 ns;  -- MSB=1 -> 0xFF
    assert dado = "11111111" report "quadrada alta incorreta" severity error;

    report "conformador_onda_tb: sucesso" severity note;
    wait;
  end process;
end architecture;
