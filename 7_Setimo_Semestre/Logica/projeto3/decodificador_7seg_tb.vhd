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

entity decodificador_7seg_tb is
end entity;

architecture sim of decodificador_7seg_tb is
  signal estado : estado_t := STANDBY;
  signal hex2, hex1, hex0 : std_logic_vector(6 downto 0);
begin
  dut: entity work.decodificador_7seg
    port map (estado => estado, hex2 => hex2, hex1 => hex1, hex0 => hex0);

  stimulus: process
  begin
    estado <= STANDBY; wait for 10 ns;     -- "Stb"
    assert hex2 = "0010010" report "STANDBY hex2 (S) incorreto" severity error;
    assert hex1 = "0000111" report "STANDBY hex1 (t) incorreto" severity error;
    assert hex0 = "0000011" report "STANDBY hex0 (b) incorreto" severity error;

    estado <= ENXAGUE; wait for 10 ns;     -- "EnH"
    assert hex2 = "0000110" report "ENXAGUE hex2 (E) incorreto" severity error;
    assert hex1 = "1001000" report "ENXAGUE hex1 (n) incorreto" severity error;
    assert hex0 = "0001001" report "ENXAGUE hex0 (H) incorreto" severity error;

    estado <= MOLHO; wait for 10 ns;       -- "nOL"
    assert hex2 = "1001000" report "MOLHO hex2 (n) incorreto" severity error;
    assert hex1 = "1000000" report "MOLHO hex1 (O) incorreto" severity error;
    assert hex0 = "1000111" report "MOLHO hex0 (L) incorreto" severity error;

    estado <= CENTRIFUGA; wait for 10 ns;  -- "CEn"
    assert hex2 = "1000110" report "CENTRIFUGA hex2 (C) incorreto" severity error;
    assert hex1 = "0000110" report "CENTRIFUGA hex1 (E) incorreto" severity error;
    assert hex0 = "1001000" report "CENTRIFUGA hex0 (n) incorreto" severity error;

    report "decodificador_7seg_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
