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

entity maquina_estados is
  port (
    clk      : in  std_logic;
    avanca   : in  std_logic;  -- pulso (key1)
    reset_sb : in  std_logic;  -- pulso (key0) -> STANDBY, prioritario
    estado   : out estado_t
  );
end entity;

architecture rtl of maquina_estados is
  signal estado_r : estado_t := STANDBY;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if reset_sb = '1' then
        estado_r <= STANDBY;
      elsif avanca = '1' then
        case estado_r is
          when STANDBY    => estado_r <= ENXAGUE;
          when ENXAGUE    => estado_r <= MOLHO;
          when MOLHO      => estado_r <= CENTRIFUGA;
          when CENTRIFUGA => estado_r <= STANDBY;
        end case;
      end if;
    end if;
  end process;
  estado <= estado_r;
end architecture;
