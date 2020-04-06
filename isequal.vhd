library ieee;
use ieee.std_logic_1164.all;

entity isequal is
port(
A,B : in std_logic_vector(15 downto 0);
eq: out std_logic_vector(0 downto 0));
end entity;

architecture equalarch of isequal is
signal cheq: std_logic_vector(15 downto 0);
begin
cheq<= not(A xor B);
process(A,B,cheq)
begin
if(cheq=x"0000") then
eq<="1";
else 
eq<="0";
end if;
end process;

end equalarch;