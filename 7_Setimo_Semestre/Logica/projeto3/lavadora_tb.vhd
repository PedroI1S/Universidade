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

entity lavadora_tb is
end entity;

architecture sim of lavadora_tb is
  signal clk50 : std_logic := '0';
  signal key   : std_logic_vector(1 downto 0) := "11";  -- idle (ativo-baixo)
  signal ledr  : std_logic_vector(9 downto 0);
  signal hex2, hex1, hex0 : std_logic_vector(6 downto 0);

  procedure aperta(signal k : out std_logic_vector(1 downto 0); idx : integer) is
  begin
    k <= (others => '1'); k(idx) <= '0'; wait for 300 ns;
    k <= (others => '1');                wait for 300 ns;
  end procedure;
begin
  dut: entity work.lavadora
    generic map (CLK_HZ => 40, F_ENX => 2, F_MOL => 1, F_CEN => 10,
                 DEBOUNCE_CICLOS => 3)
    port map (clk50 => clk50, key => key, ledr => ledr,
              hex2 => hex2, hex1 => hex1, hex0 => hex0);

  clk50 <= not clk50 after 5 ns;

  stimulus: process
  begin
    wait for 50 ns;
    assert ledr = "0000000001" report "STANDBY: LEDR0" severity error;
    assert hex0 = "0000011"   report "STANDBY: hex0=b" severity error;

    aperta(key, 1);  -- -> ENXAGUE
    assert hex2 = "0000110" report "ENXAGUE: hex2=E" severity error;

    aperta(key, 1);  -- -> MOLHO
    assert hex1 = "1000000" report "MOLHO: hex1=O" severity error;

    aperta(key, 1);  -- -> CENTRIFUGA
    assert hex2 = "1000110" report "CENTRIFUGA: hex2=C" severity error;

    aperta(key, 0);  -- reset -> STANDBY
    assert ledr = "0000000001" report "reset: volta a STANDBY (LEDR0)" severity error;
    assert hex0 = "0000011"   report "reset: hex0=b" severity error;

    report "lavadora_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
