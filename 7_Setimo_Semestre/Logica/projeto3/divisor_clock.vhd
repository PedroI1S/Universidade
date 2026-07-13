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

entity divisor_clock is
  generic (DIV : natural);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;   -- sincrono, reinicia a contagem (alinha a fase)
    enable : out std_logic    -- '1' por 1 ciclo a cada DIV ciclos
  );
end entity;

architecture rtl of divisor_clock is
  signal cont : natural range 0 to DIV-1 := 0;
  signal en   : std_logic := '0';
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        cont <= 0;
        en   <= '0';
      elsif cont = DIV-1 then
        cont <= 0;
        en   <= '1';
      else
        cont <= cont + 1;
        en   <= '0';
      end if;
    end if;
  end process;
  enable <= en;
end architecture;
