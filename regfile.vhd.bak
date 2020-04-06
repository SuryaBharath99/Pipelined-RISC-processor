library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;


entity regfile is
  port (
	clock,enable: in std_logic;
	A1,A2,A3: in std_logic_vector(2 downto 0);
	WD3: in std_logic_vector(15 downto 0);
	RD1,RD2: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- regfile

architecture arch of regfile is

type regfiletype is array (7 downto 0) of std_logic_vector(15 downto 0);
signal reggfile: regfiletype;

begin
a : process( clock,enable )
begin
if(rising_edge(clock) and enable='1') then
	reggfile(conv_integer(A3))<=WD3;
	end if;
end process ; -- a

RD1<=reggfile(conv_integer(A1));
RD2<=reggfile(conv_integer(A2));

end architecture ; -- arch