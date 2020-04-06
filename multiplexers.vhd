library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4inp1bit is
  port (
	sel1,sel0: in std_logic;
	A,B,C,D: in std_logic;
	O: out std_logic
  ) ;
end entity ; -- mux4inp1bit

architecture arch of mux4inp1bit is
signal notsel1,notsel0: std_logic;
begin
notsel0 <= not(sel0);
notsel1 <= not(sel1); 
O <= (A and (notsel0 and notsel1)) or (B and (notsel1 and sel0)) or (C and (sel1 and notsel0)) or (D and (sel1 and sel0));
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity mux16bit4inp is
  port (
	sel1,sel0: in std_logic;
	A,B,C,D: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- mux16bit4inp

architecture arch of mux16bit4inp is
component mux4inp1bit is
  port (
	sel1,sel0: in std_logic;
	A,B,C,D: in std_logic;
	O: out std_logic
  ) ;
end component ;
begin
mX : for i in 0 to 15 generate
	m1X: mux4inp1bit port map(sel1,sel0,A(i),B(i),C(i),D(i),O(i));
end generate ; -- mX
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity mux2inp1bit is
  port (
	sel,A,B: in std_logic;
	C: out std_logic
  ) ;
end entity ; -- mux2inp1bit

architecture arch of mux2inp1bit is
begin
C<= (A and not(sel)) or (B and sel);
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity mux16bit2inp is
  port (
	sel: in std_logic;
	A,B: in std_logic_vector(15 downto 0);
	C: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- mux16bit2inp

architecture arch of mux16bit2inp is
component mux2inp1bit is
  port (
	sel,A,B: in std_logic;
	C: out std_logic
  ) ;
end component ;

begin
mX : for i in 0 to 15 generate
	m1X: mux2inp1bit port map(sel,A(i),B(i),C(i));
end generate ; -- mX
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity mux3bit2inp is
   port (
	sel: in std_logic;
	A,B: in std_logic_vector(2 downto 0);
	C: out std_logic_vector(2 downto 0)
  ) ;
end entity ; -- mux3bit2inp

architecture arch of mux3bit2inp is
component mux2inp1bit is
  port (
	sel,A,B: in std_logic;
	C: out std_logic
  ) ;
end component ;
begin
mX : for i in 0 to 2 generate
	m1X: mux2inp1bit port map(sel,A(i),B(i),C(i));
end generate ; -- mX
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity mux3bit4inp is
   port (
	sel1,sel0: in std_logic;
	A,B,C,D: in std_logic_vector(2 downto 0);
	O: out std_logic_vector(2 downto 0)
  ) ;
end entity ; -- mux3bit4inp

architecture arch of mux3bit4inp is
component mux4inp1bit is
  port (
	sel1,sel0: in std_logic;
	A,B,C,D: in std_logic;
	O: out std_logic
  ) ;
end component ;
begin
mX : for i in 0 to 2 generate
	m1X: mux4inp1bit port map(sel1,sel0,A(i),B(i),C(i),D(i),O(i));
end generate ; -- mX
end architecture ; -- arch