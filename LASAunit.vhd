rfmux1gh_out_rrlibrary ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder3bit is
  port (
	A: in std_logic_vector(2 downto 0);
	o: out std_logic_vector(2 downto 0)
	--z: out std_logic
  ) ;
end entity ; -- adder3bit

architecture arch of adder3bit is
component Full_Adder is
  port (
	A,B,Cin: in std_logic;
	O,Cout: out std_logic
  ) ;
end component ;
	signal C:std_logic_vector(3 downto 0);
	signal res:std_logic_vector(2 downto 0);
begin
C(0)<='1';
afhakj : for i in 0 to 2 generate
	faX: Full_Adder port map (
		A(i),'0',C(i),res(i),C(i+1)
	);
	o<=res;
--	z<=not(res(2) or res(1) or res(0));
	--z<=((not(res(0))) and (not(res(1)))) and (not(res(2)));
end generate ; -- a
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;

entity zero_det3bit is
  port (
	a:in std_logic_vector(2 downto 0);
	z: out std_logic
  ) ;
end entity ; -- zero_det3bit

architecture arch of zero_det3bit is
begin
z<=not(a(2) or a(1) or a(0));
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity LASAunit is
  port (
	clock,LACounter,LASAUpdate: in std_logic;
	O: out std_logic_vector(2 downto 0);
	z: out std_logic
  ) ;
end entity ; -- LASAunit

architecture arch of LASAunit is
component adder3bit is
  port (
	A: in std_logic_vector(2 downto 0);
	o: out std_logic_vector(2 downto 0)
	--z: out std_logic
  ) ;
end component ;
component register3bitwithenable is
  port (
	clock,enable: in std_logic;
	A: in std_logic_vector(2 downto 0);
	O: out std_logic_vector(2 downto 0)
  ) ;
end component ;
component mux3bit2inp is
   port (
	sel: in std_logic;
	A,B: in std_logic_vector(2 downto 0);
	C: out std_logic_vector(2 downto 0)
  ) ;
end component ;
component zero_det3bit is
  port (
	a:in std_logic_vector(2 downto 0);
	z: out std_logic
  ) ;
end component ;
signal adderA,adderop,muxop: std_logic_vector(2 downto 0);
begin
r: register3bitwithenable port map (clock,LASAUpdate,muxop,adderA);
a: adder3bit port map (adderA,adderop);
m: mux3bit2inp port map (LACounter,adderop,"000",muxop);
O<=adderA;
zzs:zero_det3bit port map (
	adderop,z
);
end architecture ; -- arch