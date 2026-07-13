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
use work.gerador_pkg.all;

entity gerador_sinais is
  generic (
    CLK_HZ    : natural := 50_000_000;
    N_BITS    : natural := 8;
    ACC_WIDTH : natural := 32;
    FREQ1     : natural := 400;
    FREQ2     : natural := 800;
    WAV_NUM   : natural := 5
  );
  port (
    clk50 : in  std_logic;                              -- MAX10_CLK1_50
    key0  : in  std_logic;                              -- reset (ativo-baixo)
    sw0   : in  std_logic;                              -- '0'=freq1, '1'=freq2
    sw9   : in  std_logic;                              -- '0'=quadrada, '1'=serra
    gpio  : out std_logic_vector(N_BITS-1 downto 0);    -- GPIO[7:0] -> R-2R
    hex2  : out std_logic_vector(6 downto 0);           -- unidade da freq
    hex3  : out std_logic_vector(6 downto 0);           -- dezena da freq
    hex4  : out std_logic_vector(6 downto 0);           -- centena da freq
    hex5  : out std_logic_vector(6 downto 0)            -- numero da onda
  );
end entity;

architecture rtl of gerador_sinais is
  constant INC1 : unsigned(ACC_WIDTH-1 downto 0) := calc_incremento(FREQ1, CLK_HZ, ACC_WIDTH);
  constant INC2 : unsigned(ACC_WIDTH-1 downto 0) := calc_incremento(FREQ2, CLK_HZ, ACC_WIDTH);

  signal rst        : std_logic;
  signal incremento : unsigned(ACC_WIDTH-1 downto 0);
  signal fase       : unsigned(ACC_WIDTH-1 downto 0);
  signal fase_top   : unsigned(N_BITS-1 downto 0);

  signal d_cent, d_dez, d_uni, d_onda : unsigned(3 downto 0);
begin
  rst        <= not key0;
  incremento <= INC2 when sw0 = '1' else INC1;

  acc: acumulador_fase
    generic map (ACC_WIDTH => ACC_WIDTH)
    port map (clk => clk50, rst => rst, incremento => incremento, fase => fase);

  fase_top <= fase(ACC_WIDTH-1 downto ACC_WIDTH-N_BITS);

  conf: conformador_onda
    generic map (N_BITS => N_BITS)
    port map (fase_msb => fase_top, sel_onda => sw9, dado => gpio);

  -- Digitos da frequencia ativa (constantes mux por sw0)
  d_cent <= digito_freq(FREQ2, 2) when sw0 = '1' else digito_freq(FREQ1, 2);
  d_dez  <= digito_freq(FREQ2, 1) when sw0 = '1' else digito_freq(FREQ1, 1);
  d_uni  <= digito_freq(FREQ2, 0) when sw0 = '1' else digito_freq(FREQ1, 0);
  d_onda <= to_unsigned(WAV_NUM, 4) when sw9 = '1' else to_unsigned(0, 4);

  dec_h4: decodificador_7seg port map (valor => d_cent, seg => hex4);
  dec_h3: decodificador_7seg port map (valor => d_dez,  seg => hex3);
  dec_h2: decodificador_7seg port map (valor => d_uni,  seg => hex2);
  dec_h5: decodificador_7seg port map (valor => d_onda, seg => hex5);
end architecture;
