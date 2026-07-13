library ieee;
use ieee.std_logic_1164.all;

entity teste_tb is
end entity;

architecture sim of teste_tb is
  signal a : std_logic := '0';
  signal b : std_logic := '0';
  signal y : std_logic;
begin
  dut: entity work.teste
    port map (
      a => a,
      b => b,
      y => y
    );

  stimulus: process
  begin
    a <= '0'; b <= '0'; wait for 10 ns;
    assert y = '0' report "Erro: 0 and 0 deve ser 0" severity error;

    a <= '0'; b <= '1'; wait for 10 ns;
    assert y = '0' report "Erro: 0 and 1 deve ser 0" severity error;

    a <= '1'; b <= '0'; wait for 10 ns;
    assert y = '0' report "Erro: 1 and 0 deve ser 0" severity error;

    a <= '1'; b <= '1'; wait for 10 ns;
    assert y = '1' report "Erro: 1 and 1 deve ser 1" severity error;

    report "Simulacao concluida com sucesso" severity note;
    wait;
  end process;
end architecture;
