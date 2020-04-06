library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;


entity regfile is
  port (
	clock:in std_logic;
	enable: in std_logic_vector(0 downto 0);
	reset: in std_logic;
	A1,A2,A3: in std_logic_vector(2 downto 0);
	WD3: in std_logic_vector(15 downto 0);
	RD1,RD2: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- regfile

architecture arch of regfile is

type regfiletype is array (7 downto 0) of std_logic_vector(15 downto 0);
signal reggfile: regfiletype;

begin
a : process( clock,enable,reset )
begin
if(reset='1') then
	reggfile(0)<=x"0000";
	reggfile(1)<=x"0000";
	reggfile(2)<=x"0000";
	reggfile(3)<=x"0000";
	reggfile(4)<=x"0000";
	reggfile(5)<=x"0000";
	reggfile(6)<=x"0000";
	reggfile(7)<=x"0000";
elsif(rising_edge(clock) and enable="1" and reset='0') then
	reggfile(conv_integer(A3))<=WD3;
	end if;
end process ; -- a

RD1<=reggfile(conv_integer(A1));
RD2<=reggfile(conv_integer(A2));

end architecture ; -- arch