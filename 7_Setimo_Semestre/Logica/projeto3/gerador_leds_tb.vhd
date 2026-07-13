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

entity gerador_leds_tb is
end entity;

architecture sim of gerador_leds_tb is
  signal clk    : std_logic := '0';
  signal estado : estado_t := STANDBY;
  signal ledr   : std_logic_vector(9 downto 0);
begin
  dut: entity work.gerador_leds
    generic map (DIV_ENX => 2, DIV_MOL => 2, DIV_CEN => 2)
    port map (clk => clk, estado => estado, ledr => ledr);

  clk <= not clk after 5 ns;

  stimulus: process
  begin
    -- STANDBY
    estado <= STANDBY; wait for 30 ns;
    assert ledr = "0000000001" report "STANDBY: so LEDR0 aceso" severity error;

    -- ENXAGUE: cenario A no inicio
    estado <= ENXAGUE; wait for 25 ns;
    assert ledr = "1111100000" report "ENXAGUE: cenario A (LEDR9-5)" severity error;
    wait for 20 ns;
    assert ledr = "0000011111" report "ENXAGUE: cenario B (LEDR4-0)" severity error;

    -- MOLHO: comeca aceso (LEDR9)
    estado <= MOLHO; wait for 25 ns;
    assert ledr = "1000000000" report "MOLHO: LEDR9 aceso no inicio" severity error;
    wait for 20 ns;
    assert ledr = "0000000000" report "MOLHO: apagado apos 1 evento" severity error;

    -- CENTRIFUGA: comeca em LEDR0, anda para LEDR1
    estado <= CENTRIFUGA; wait for 25 ns;
    assert ledr = "0000000001" report "CENTRIFUGA: LEDR0 no inicio" severity error;
    wait for 20 ns;
    assert ledr = "0000000010" report "CENTRIFUGA: LEDR1 apos 1 passo" severity error;

    report "gerador_leds_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
