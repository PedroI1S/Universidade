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

entity decodificador_7seg is
  port (
    estado : in  estado_t;
    hex2   : out std_logic_vector(6 downto 0);  -- ativo-baixo, seg(0)=a..seg(6)=g
    hex1   : out std_logic_vector(6 downto 0);
    hex0   : out std_logic_vector(6 downto 0)
  );
end entity;

architecture rtl of decodificador_7seg is
begin
  process(estado)
  begin
    case estado is
      when STANDBY    => hex2 <= "0010010"; hex1 <= "0000111"; hex0 <= "0000011"; -- Stb
      when ENXAGUE    => hex2 <= "0000110"; hex1 <= "1001000"; hex0 <= "0001001"; -- EnH
      when MOLHO      => hex2 <= "1001000"; hex1 <= "1000000"; hex0 <= "1000111"; -- nOL
      when CENTRIFUGA => hex2 <= "1000110"; hex1 <= "0000110"; hex0 <= "1001000"; -- CEn
    end case;
  end process;
end architecture;
