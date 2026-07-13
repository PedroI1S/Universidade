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

entity acumulador_fase is
  generic (ACC_WIDTH : natural := 32);
  port (
    clk        : in  std_logic;
    rst        : in  std_logic;  -- reset sincrono, ativo-alto
    incremento : in  unsigned(ACC_WIDTH-1 downto 0);
    fase       : out unsigned(ACC_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of acumulador_fase is
  signal acc : unsigned(ACC_WIDTH-1 downto 0) := (others => '0');
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        acc <= (others => '0');
      else
        acc <= acc + incremento;
      end if;
    end if;
  end process;
  fase <= acc;
end architecture;
