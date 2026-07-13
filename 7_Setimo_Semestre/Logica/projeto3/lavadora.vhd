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

entity lavadora is
  generic (
    CLK_HZ          : natural := 50_000_000;
    F_ENX           : natural := 2;
    F_MOL           : natural := 1;
    F_CEN           : natural := 10;
    DEBOUNCE_CICLOS : natural := 50_000
  );
  port (
    clk50 : in  std_logic;                       -- MAX10_CLK1_50
    key   : in  std_logic_vector(1 downto 0);    -- key0 (reset), key1 (avanca); ativo-baixo
    ledr  : out std_logic_vector(9 downto 0);
    hex2  : out std_logic_vector(6 downto 0);
    hex1  : out std_logic_vector(6 downto 0);
    hex0  : out std_logic_vector(6 downto 0)
  );
end entity;

architecture rtl of lavadora is
  signal avanca, reset_sb : std_logic;
  signal estado           : estado_t;
begin
  sb_key1: sincronizador_botao
    generic map (DEBOUNCE_CICLOS => DEBOUNCE_CICLOS)
    port map (clk => clk50, botao_n => key(1), pulso => avanca);

  sb_key0: sincronizador_botao
    generic map (DEBOUNCE_CICLOS => DEBOUNCE_CICLOS)
    port map (clk => clk50, botao_n => key(0), pulso => reset_sb);

  fsm: maquina_estados
    port map (clk => clk50, avanca => avanca, reset_sb => reset_sb, estado => estado);

  leds: gerador_leds
    generic map (DIV_ENX => calc_div(CLK_HZ, F_ENX),
                 DIV_MOL => calc_div(CLK_HZ, F_MOL),
                 DIV_CEN => calc_div(CLK_HZ, F_CEN))
    port map (clk => clk50, estado => estado, ledr => ledr);

  dec: decodificador_7seg
    port map (estado => estado, hex2 => hex2, hex1 => hex1, hex0 => hex0);
end architecture;
