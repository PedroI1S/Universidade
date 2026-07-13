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
use ieee.numeric_std.all;

package lavadora_pkg is
  -- Estados da maquina de lavar (ordem do edital)
  type estado_t is (STANDBY, ENXAGUE, MOLHO, CENTRIFUGA);

  -- Defaults (sintese). Frequencias do "evento interno" de cada animacao.
  constant CLK_HZ          : natural := 50_000_000;
  constant F_ENX           : natural := 2;   -- toggle 2 Hz -> onda quadrada 1 Hz
  constant F_MOL           : natural := 1;   -- toggle 1 Hz -> pisca 0,5 Hz
  constant F_CEN           : natural := 10;  -- passo 10 Hz
  constant DEBOUNCE_CICLOS : natural := 50_000;  -- ~1 ms @ 50 MHz

  -- Divisor: numero de ciclos de clock por evento.
  function calc_div(clk_freq : natural; freq_ev : natural) return natural;

  component divisor_clock is
    generic (DIV : natural);
    port (clk : in std_logic; rst : in std_logic; enable : out std_logic);
  end component;

  component sincronizador_botao is
    generic (DEBOUNCE_CICLOS : natural);
    port (clk : in std_logic; botao_n : in std_logic; pulso : out std_logic);
  end component;

  component maquina_estados is
    port (clk : in std_logic; avanca : in std_logic; reset_sb : in std_logic;
          estado : out estado_t);
  end component;

  component gerador_leds is
    generic (DIV_ENX : natural; DIV_MOL : natural; DIV_CEN : natural);
    port (clk : in std_logic; estado : in estado_t;
          ledr : out std_logic_vector(9 downto 0));
  end component;

  component decodificador_7seg is
    port (estado : in estado_t;
          hex2 : out std_logic_vector(6 downto 0);
          hex1 : out std_logic_vector(6 downto 0);
          hex0 : out std_logic_vector(6 downto 0));
  end component;
end package;

package body lavadora_pkg is
  function calc_div(clk_freq : natural; freq_ev : natural) return natural is
  begin
    return clk_freq / freq_ev;
  end function;
end package body;
