library ieee;
use ieee.std_logic_1164.all;

entity teste is
  port (
    a : in std_logic;
    b : in std_logic;
    y : out std_logic
  );
end entity;

architecture rtl of teste is
begin
  y <= a and b;
end architecture;
