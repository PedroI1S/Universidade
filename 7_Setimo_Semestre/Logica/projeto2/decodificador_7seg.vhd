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

entity decodificador_7seg is
  port (
    valor : in  unsigned(3 downto 0);
    seg   : out std_logic_vector(6 downto 0)  -- ativo-baixo, seg(0)=a..seg(6)=g
  );
end entity;

architecture rtl of decodificador_7seg is
begin
  with valor select
    seg <= "1000000" when "0000",  -- 0
           "1111001" when "0001",  -- 1
           "0100100" when "0010",  -- 2
           "0110000" when "0011",  -- 3
           "0011001" when "0100",  -- 4
           "0010010" when "0101",  -- 5
           "0000010" when "0110",  -- 6
           "1111000" when "0111",  -- 7
           "0000000" when "1000",  -- 8
           "0010000" when "1001",  -- 9
           "1111111" when others;  -- apagado
end architecture;
