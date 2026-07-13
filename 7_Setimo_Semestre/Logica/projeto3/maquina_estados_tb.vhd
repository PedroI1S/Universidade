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
use std.env.all;

entity maquina_estados_tb is
end entity;

architecture sim of maquina_estados_tb is
  signal clk      : std_logic := '0';
  signal avanca   : std_logic := '0';
  signal reset_sb : std_logic := '0';
  signal estado   : estado_t;

  procedure pulso_1ciclo(signal s : out std_logic) is
  begin
    s <= '1'; wait for 10 ns; s <= '0'; wait for 10 ns;
  end procedure;
begin
  dut: entity work.maquina_estados
    port map (clk => clk, avanca => avanca, reset_sb => reset_sb, estado => estado);

  clk <= not clk after 5 ns;

  stimulus: process
  begin
    wait for 12 ns;
    assert estado = STANDBY report "estado inicial deveria ser STANDBY" severity error;

    pulso_1ciclo(avanca);
    assert estado = ENXAGUE report "STANDBY+avanca deveria ir a ENXAGUE" severity error;
    pulso_1ciclo(avanca);
    assert estado = MOLHO report "ENXAGUE+avanca deveria ir a MOLHO" severity error;
    pulso_1ciclo(avanca);
    assert estado = CENTRIFUGA report "MOLHO+avanca deveria ir a CENTRIFUGA" severity error;
    pulso_1ciclo(avanca);
    assert estado = STANDBY report "CENTRIFUGA+avanca deveria voltar a STANDBY" severity error;

    pulso_1ciclo(avanca);   -- ENXAGUE
    pulso_1ciclo(avanca);   -- MOLHO
    pulso_1ciclo(reset_sb);
    assert estado = STANDBY report "reset_sb deveria voltar a STANDBY" severity error;

    -- reset tem prioridade sobre avanca
    avanca <= '1'; reset_sb <= '1'; wait for 10 ns;
    avanca <= '0'; reset_sb <= '0'; wait for 10 ns;
    assert estado = STANDBY report "reset_sb deveria ter prioridade sobre avanca" severity error;

    report "maquina_estados_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
