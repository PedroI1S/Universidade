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

entity conformador_onda is
  generic (N_BITS : natural := 8);
  port (
    fase_msb : in  unsigned(N_BITS-1 downto 0);
    sel_onda : in  std_logic;  -- '0'=quadrada, '1'=dente de serra
    dado     : out std_logic_vector(N_BITS-1 downto 0)
  );
end entity;

architecture rtl of conformador_onda is
  signal serra    : std_logic_vector(N_BITS-1 downto 0);
  signal quadrada : std_logic_vector(N_BITS-1 downto 0);
begin
  serra    <= std_logic_vector(fase_msb);
  quadrada <= (others => fase_msb(N_BITS-1));
  dado     <= serra when sel_onda = '1' else quadrada;
end architecture;
