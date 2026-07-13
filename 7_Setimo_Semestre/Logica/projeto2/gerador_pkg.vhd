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
use ieee.math_real.all;

package gerador_pkg is
  -- Constantes default (variante Marlon Mezomo Gotardo)
  constant CLK_HZ    : natural := 50_000_000;
  constant N_BITS    : natural := 8;
  constant ACC_WIDTH : natural := 32;
  constant FREQ1     : natural := 400;
  constant FREQ2     : natural := 800;
  constant WAV_NUM   : natural := 5;   -- numero da onda wav_x (dente de serra)

  -- Incremento DDS calculado em tempo de elaboracao
  function calc_incremento(freq : natural; f_clk : natural; largura : natural)
    return unsigned;

  -- Digito BCD (0-9) de 'valor' na 'posicao' (0=unidade,1=dezena,2=centena)
  function digito_freq(valor : natural; posicao : natural) return unsigned;

  component acumulador_fase is
    generic (ACC_WIDTH : natural := 32);
    port (
      clk        : in  std_logic;
      rst        : in  std_logic;
      incremento : in  unsigned(ACC_WIDTH-1 downto 0);
      fase       : out unsigned(ACC_WIDTH-1 downto 0)
    );
  end component;

  component conformador_onda is
    generic (N_BITS : natural := 8);
    port (
      fase_msb : in  unsigned(N_BITS-1 downto 0);
      sel_onda : in  std_logic;
      dado     : out std_logic_vector(N_BITS-1 downto 0)
    );
  end component;

  component decodificador_7seg is
    port (
      valor : in  unsigned(3 downto 0);
      seg   : out std_logic_vector(6 downto 0)
    );
  end component;
end package;

package body gerador_pkg is
  function calc_incremento(freq : natural; f_clk : natural; largura : natural)
    return unsigned is
    variable inc_real : real;
  begin
    inc_real := round(real(freq) * (2.0 ** largura) / real(f_clk));
    return to_unsigned(integer(inc_real), largura);
  end function;

  function digito_freq(valor : natural; posicao : natural) return unsigned is
    variable v : natural := valor;
    variable d : natural := 0;
  begin
    for i in 0 to posicao loop
      d := v mod 10;
      v := v / 10;
    end loop;
    return to_unsigned(d, 4);
  end function;
end package body;
