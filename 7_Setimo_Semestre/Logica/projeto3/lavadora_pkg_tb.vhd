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
use work.lavadora_pkg.all;

entity lavadora_pkg_tb is
end entity;

architecture sim of lavadora_pkg_tb is
begin
  stimulus: process
  begin
    assert calc_div(50_000_000, 2)  = 25_000_000 report "calc_div 2Hz incorreto"  severity error;
    assert calc_div(50_000_000, 1)  = 50_000_000 report "calc_div 1Hz incorreto"  severity error;
    assert calc_div(50_000_000, 10) = 5_000_000  report "calc_div 10Hz incorreto" severity error;
    report "lavadora_pkg_tb: sucesso" severity note;
    wait;
  end process;
end architecture;
