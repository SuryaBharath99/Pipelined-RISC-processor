library ieee;
use ieee.std_logic_1164.all;

entity LHI is
  port (
	A: in std_logic_Vector(8 downto 0);
	O: out std_logic_Vector(15 downto 0)
  ) ;
end entity ; -- LHI

architecture arch of LHI is
begin
O<= A & "0000000";
end architecture ; -- arch