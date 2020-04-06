library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SixteenBitNand is
  port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- SixteenBitNand
architecture arch of SixteenBitNand is
begin
fx : for i in 0 to 15 generate
	O(i) <= A(i) nand B(i);
end generate ; -- fx
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity Full_Adder is
  port (
	A,B,Cin: in std_logic;
	O,Cout: out std_logic
  ) ;
end entity ; -- Full_Adder
architecture arch of Full_Adder is
begin
O<= (A xor B xor Cin);
Cout<= (A and B) or (A and Cin) or (Cin and B);
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity SixteenBitAdder is
  port (
		A,B: in std_logic_vector(15 downto 0);
		Cin: in std_logic;
	O: out std_logic_vector(15 downto 0);
	Cout: out std_logic
  ) ;
end entity ; -- SixteenBitAdder
architecture arch of SixteenBitAdder is
component Full_Adder is
  port (
	A,B,Cin: in std_logic;
	O,Cout: out std_logic
  ) ;
end component ;
signal C: std_logic_vector(16 downto 0);
begin
C(0)<=Cin;
fr : for i in 0 to 15 generate
	faX: Full_Adder port map(A(i),B(i),C(i),O(i),C(i+1));
end generate ; -- fr
Cout<=C(16);
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity OnesComplement is
  port (
	A: in std_logic_vector(15 downto 0);
	C: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- OnesComplement

architecture arch of OnesComplement is
begin
ab : for i in 0 to 15 generate
	C(i)<=not(A(i));
end generate ; -- a
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity latch1bit is
  port (
	a,enable: in std_logic;
	o: out std_logic
  ) ;
end entity ; -- latch1bit

architecture arch of latch1bit is
signal lastres: std_logic;
begin
o<= a when enable='1'
		else lastres;
lastres<=a when enable='1';
end arch ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity ALU is
  port (
	A,B: in std_logic_Vector(15 downto 0);
	ALUControl: in std_logic_Vector(1 downto 0);
	ModifyC,ModifyZ: in std_logic;
	--ConC,ConZ: in std_logic;
	O: out std_logic_Vector(15 downto 0);
	C,Z,BEQ_Z: out std_logic
  ) ;
end entity ; -- ALU

architecture arch of ALU is
component SixteenBitAdder is
  port (
		A,B: in std_logic_vector(15 downto 0);
		Cin: in std_logic;
	O: out std_logic_vector(15 downto 0);
	Cout: out std_logic
  ) ;
end component ;
component OnesComplement is
  port (
	A: in std_logic_vector(15 downto 0);
	C: out std_logic_vector(15 downto 0)
  ) ;
end component ;
component SixteenBitNand is
  port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end component ;
component mux16bit2inp is
  port (
	sel: in std_logic;
	A,B: in std_logic_vector(15 downto 0);
	C: out std_logic_vector(15 downto 0)
  ) ;
end component ;
component latch1bit is
  port (
	a,enable: in std_logic;
	o: out std_logic
  ) ;
end component ;

signal b1scomplement,boutput,Adderoutput,Nandoutput,Muxoutput: std_logic_vector(15 downto 0);
signal Cinternal,Zinternal: std_logic;
begin
o1:OnesComplement port map(b,b1scomplement);
m1: mux16bit2inp port map(ALUControl(1),B,b1scomplement,boutput);
a1: SixteenBitAdder port map(A,boutput,ALUControl(1),Adderoutput,Cinternal);
n1: SixteenBitNand port map(A,B,Nandoutput);
m2:mux16bit2inp port map(ALUControl(0),Adderoutput,Nandoutput,Muxoutput);
Zinternal<=not(Muxoutput(15) or Muxoutput(14) or Muxoutput(13) or Muxoutput(12) or Muxoutput(11) or Muxoutput(10) or Muxoutput(9) or Muxoutput(8) or Muxoutput(7) or Muxoutput(6) or Muxoutput(5) or Muxoutput(4) or Muxoutput(3) or Muxoutput(2) or Muxoutput(1) or Muxoutput(0));
--Zenable <= ModifyZ or (Cinternal and ConC) or (Zinternal and ConZ);
--Cenable <= ModifyC or (Cinternal and ConC) or (Zinternal and ConZ);
l1: latch1bit port map(Cinternal,ModifyC,C);
l2: latch1bit port map (Zinternal,ModifyZ,Z);
BEQ_Z<=Zinternal;
O<=Muxoutput;
end architecture ; -- arch