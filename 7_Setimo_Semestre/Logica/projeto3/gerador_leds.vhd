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
use work.lavadora_pkg.all;

entity gerador_leds is
  generic (DIV_ENX : natural; DIV_MOL : natural; DIV_CEN : natural);
  port (
    clk    : in  std_logic;
    estado : in  estado_t;
    ledr   : out std_logic_vector(9 downto 0)
  );
end entity;

architecture rtl of gerador_leds is
  signal en_enx, en_mol, en_cen : std_logic;
  signal estado_ant : estado_t := STANDBY;
  signal troca      : std_logic;
  signal alt        : std_logic := '0';            -- enxague: cenario
  signal pisca      : std_logic := '1';            -- molho: LEDR9
  signal indice     : integer range 0 to 9 := 0;   -- centrifuga
begin
  -- troca de estado: 1 ciclo quando estado muda
  process(clk)
  begin
    if rising_edge(clk) then
      estado_ant <= estado;
    end if;
  end process;
  troca <= '1' when estado /= estado_ant else '0';

  -- divisores reiniciam a fase ao trocar de estado
  d_enx: divisor_clock generic map (DIV => DIV_ENX)
    port map (clk => clk, rst => troca, enable => en_enx);
  d_mol: divisor_clock generic map (DIV => DIV_MOL)
    port map (clk => clk, rst => troca, enable => en_mol);
  d_cen: divisor_clock generic map (DIV => DIV_CEN)
    port map (clk => clk, rst => troca, enable => en_cen);

  -- avanco das fases
  process(clk)
  begin
    if rising_edge(clk) then
      if troca = '1' then
        alt <= '0'; pisca <= '1'; indice <= 0;   -- estado de partida de cada animacao
      else
        if en_enx = '1' then alt <= not alt; end if;
        if en_mol = '1' then pisca <= not pisca; end if;
        if en_cen = '1' then
          if indice = 9 then indice <= 0; else indice <= indice + 1; end if;
        end if;
      end if;
    end if;
  end process;

  -- saida combinacional por estado
  process(estado, alt, pisca, indice)
  begin
    ledr <= (others => '0');
    case estado is
      when STANDBY =>
        ledr <= "0000000001";
      when ENXAGUE =>
        if alt = '0' then ledr <= "1111100000"; else ledr <= "0000011111"; end if;
      when MOLHO =>
        ledr <= (others => '0');
        ledr(9) <= pisca;
      when CENTRIFUGA =>
        ledr <= (others => '0');
        ledr(indice) <= '1';
    end case;
  end process;
end architecture;
