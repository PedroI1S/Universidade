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

entity gerador_sinais_tb is
end entity;

architecture sim of gerador_sinais_tb is
  signal clk50 : std_logic := '0';
  signal key0  : std_logic := '1';
  signal sw0   : std_logic := '0';
  signal sw9   : std_logic := '0';
  signal gpio  : std_logic_vector(7 downto 0);
  signal hex2, hex3, hex4, hex5 : std_logic_vector(6 downto 0);
begin
  dut: entity work.gerador_sinais
    generic map (CLK_HZ => 800, N_BITS => 8, ACC_WIDTH => 32,
                 FREQ1 => 100, FREQ2 => 200, WAV_NUM => 5)
    port map (clk50 => clk50, key0 => key0, sw0 => sw0, sw9 => sw9,
              gpio => gpio, hex2 => hex2, hex3 => hex3, hex4 => hex4, hex5 => hex5);

  clk50 <= not clk50 after 10 ns;  -- 50 MHz simbolico

  stimulus: process
  begin
    -- ===== DENTE DE SERRA: rampa 0,32,64,...,224, wrap =====
    sw9 <= '1'; sw0 <= '0';
    key0 <= '0'; wait until rising_edge(clk50); wait for 1 ns;  -- reset -> fase=0
    key0 <= '1';
    assert gpio = std_logic_vector(to_unsigned(0, 8)) report "serra[0]" severity error;
    for k in 1 to 8 loop
      wait until rising_edge(clk50); wait for 1 ns;
      assert gpio = std_logic_vector(to_unsigned((k*32) mod 256, 8))
        report "serra passo errado" severity error;
    end loop;

    -- ===== QUADRADA: 4x 0x00, depois 4x 0xFF =====
    sw9 <= '0';
    key0 <= '0'; wait until rising_edge(clk50); wait for 1 ns;  -- reset -> fase=0
    key0 <= '1';
    for k in 0 to 7 loop
      if k > 0 then
        wait until rising_edge(clk50); wait for 1 ns;
      end if;
      if k < 4 then
        assert gpio = "00000000" report "quadrada nivel baixo" severity error;
      else
        assert gpio = "11111111" report "quadrada nivel alto" severity error;
      end if;
    end loop;

    -- ===== HEX5: formato da onda =====
    sw9 <= '1'; wait for 1 ns;
    assert hex5 = "0010010" report "HEX5 deveria mostrar 5 (serra)" severity error;
    sw9 <= '0'; wait for 1 ns;
    assert hex5 = "1000000" report "HEX5 deveria mostrar 0 (quadrada)" severity error;

    -- ===== HEX4/3/2: valor da frequencia =====
    sw0 <= '0'; wait for 1 ns;  -- freq1 = 100
    assert hex4 = "1111001" report "HEX4 freq1 (centena=1)" severity error;
    assert hex3 = "1000000" report "HEX3 freq1 (dezena=0)" severity error;
    assert hex2 = "1000000" report "HEX2 freq1 (unidade=0)" severity error;
    sw0 <= '1'; wait for 1 ns;  -- freq2 = 200
    assert hex4 = "0100100" report "HEX4 freq2 (centena=2)" severity error;

    report "gerador_sinais_tb: sucesso" severity note;
    finish;
  end process;
end architecture;
