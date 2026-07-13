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

entity sincronizador_botao is
  generic (DEBOUNCE_CICLOS : natural);
  port (
    clk     : in  std_logic;
    botao_n : in  std_logic;  -- ativo-baixo (idle '1')
    pulso   : out std_logic   -- '1' por 1 ciclo ao pressionar
  );
end entity;

architecture rtl of sincronizador_botao is
  signal sync0, sync1 : std_logic := '1';
  signal deb, deb_ant : std_logic := '1';
  signal cont : natural range 0 to DEBOUNCE_CICLOS-1 := 0;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      -- sincronizacao de 2 estagios
      sync0 <= botao_n;
      sync1 <= sync0;

      -- debounce: aceita o nivel apos estavel por DEBOUNCE_CICLOS
      if sync1 = deb then
        cont <= 0;
      elsif cont = DEBOUNCE_CICLOS-1 then
        deb  <= sync1;
        cont <= 0;
      else
        cont <= cont + 1;
      end if;

      -- deteccao de borda idle->pressionado (1 -> 0)
      deb_ant <= deb;
      if deb_ant = '1' and deb = '0' then
        pulso <= '1';
      else
        pulso <= '0';
      end if;
    end if;
  end process;
end architecture;
