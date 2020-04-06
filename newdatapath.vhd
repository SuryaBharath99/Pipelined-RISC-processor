library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity newdatapath is
  port (
	clock,reset: in std_logic
  ) ;
end entity ; -- datapath

architecture arch of newdatapath is
component control_unit is
  port (
	clock,reset: in std_logic;
	DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ: out std_logic;
	PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl: out std_logic_vector(1 downto 0);
	Opcode: in std_logic_vector(3 downto 0);
	LASACounter: out std_logic_vector(2 downto 0);
	InstrCZ: in std_logic_vector(1 downto 0);
	ALU_Z,LA_Z,ALU_C,BEQ_Z: in std_logic
  ) ;
end component ;

signal DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ: std_logic;
	signal PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl: std_logic_vector(1 downto 0);
	signal Opcode:std_logic_vector(3 downto 0);
	signal LASACounter: std_logic_vector(2 downto 0);
	signal InstrCZ:std_logic_vector(1 downto 0);
	signal ALU_Z,LA_Z,ALU_C,BEQ_Z:std_logic;
--component declarations
component mux16bit4inp is
  port (
	sel1,sel0: in std_logic;
	A,B,C,D: in std_logic_vector(15 downto 0);
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

component IRreg is
  port (
  enable:in std_logic;
  A: in std_logic_vector(15 downto 0);
  O: out std_logic_vector(15 downto 0)
  ) ;
end component ; -- IRreg

component register16bitwithoutenable is
  port (
	clock: in std_logic;
	A: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end component ;
component register16bitwithenable is
  port (
	clock,enable: in std_logic;
	A: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end component ;

component Memory_asyncread_syncwrite is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
end component;

component regfile is
  port (
	clock,enable: in std_logic;
	A1,A2,A3: in std_logic_vector(2 downto 0);
	WD3:in std_logic_vector(15 downto 0);
	RD1,RD2: out std_logic_vector(15 downto 0)
  ) ;
end component ;

component ALU is
  port (
	A,B: in std_logic_Vector(15 downto 0);
	ALUControl: in std_logic_Vector(1 downto 0);
	ModifyC,ModifyZ: in std_logic;
	--ConC,ConZ: in std_logic;
	O: out std_logic_Vector(15 downto 0);
	C,Z,BEQ_Z: out std_logic
  ) ;
end component ;

component mux3bit2inp is
   port (
	sel: in std_logic;
	A,B: in std_logic_vector(2 downto 0);
	C: out std_logic_vector(2 downto 0)
  ) ;
end component ;

component mux3bit4inp is
   port (
	sel1,sel0: in std_logic;
	A,B,C,D: in std_logic_vector(2 downto 0);
	O: out std_logic_vector(2 downto 0)
  ) ;
end component ;
component LHI is
  port (
	A: in std_logic_Vector(8 downto 0);
	O: out std_logic_Vector(15 downto 0)
  ) ;
end component ;
component Simm6 is
  port (
	A: in std_logic_vector(5 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end component ;
component Simm9 is
  port (
	A: in std_logic_vector(8 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end component ;
component LASAunit is 
  port (
	clock,LACounter,LASAUpdate: in std_logic;
	O: out std_logic_vector(2 downto 0);
	z: out std_logic
  ) ;
end component ;
--component declarations end
-- signal declarations

signal PCtoReg,PC_Out,PCtoMem,Memoutput,IROutput,to_RF_D3,Mem_data_write: std_logic_vector(15 downto 0);
signal LHItoD3,SE6,SE9,D1toMux,D2_Out,MuxtoT1,T1_Out,ALU_A,T2_Out,ALU_B,ALU_output: std_logic_vector(15 downto 0);
signal ALU_zero,ALU_carry,Cinternal,Zinternal: std_logic;
signal to_RF_A1,to_RF_A2,to_RF_A3: std_logic_vector(2 downto 0);
begin
 cu:control_unit port map (
	clock,reset,
	DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ,
	PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl,
	Opcode,
	LASACounter,
	InstrCZ,
	ALU_Z,LA_Z,ALU_C,BEQ_Z
  ) ;


PCSelMux: mux16bit4inp port map (PCSelect(1),PCSelect(0),ALU_output,T2_Out,x"0000",x"0001",PCtoReg);
PCRegister: register16bitwithenable port map(clock,PCWrite,PCtoReg,PC_Out);
PCMux: mux16bit4inp port map (IorD(1),IorD(0),PC_Out,T2_Out,T1_Out,ALU_output,PCtoMem);
memdatawrite: mux16bit2inp port map(DatatoMem,T1_Out,D2_Out,Mem_data_write);
mem: Memory_asyncread_syncwrite port map(PCtoMem,Mem_data_write,clock,MemWrite,Memoutput);
IR: IRreg port map(IRWrite,Memoutput,IROutput);
RA1: mux3bit2inp port map(RF_A1,IROutput(11 downto 9),IROutput(8 downto 6),to_RF_A1);
RA2: mux3bit2inp port map(RF_A2,LASAcounter,IROutput(8 downto 6),to_RF_A2);
--T3: register16bitwithoutenable port map(clock,Memoutput,T3toMux);
lhi2: LHI port map(IROutput(8 downto 0),LHItoD3);
RA3: mux3bit4inp port map(RF_A3(1),RF_A3(0),IROutput(11 downto 9),IROutput(8 downto 6),IROutput(5 downto 3),LASAcounter,to_RF_A3);
rd3: mux16bit4inp port map(RF_D3(1),RF_D3(0),Memoutput,PC_Out,LHItoD3,T1_Out,to_RF_D3);
Regfi2le: regfile port map(clock,RegWrite,to_RF_A1,to_RF_A2,to_RF_A3,to_RF_D3,D1toMux,D2_Out);
md1:mux16bit2inp port map(RF_D1,ALU_output,D1toMux,MuxtoT1);
rT2:register16bitwithoutenable port map(clock,D2_Out,T2_Out);
rT1:register16bitwithoutenable port map(clock,MuxtoT1,T1_Out);
alua:mux16bit2inp port map(ALUSrcA,PC_Out,T1_Out,ALU_A);
sim6:Simm6 port map(IROutput(5 downto 0),SE6);
sim9:Simm9 port map(IROutput(8 downto 0),SE9);
alub:mux16bit4inp port map(ALUSrcB(1),ALUSrcB(0),T2_Out,SE6,SE9,x"0001",ALU_B);
aluuuuu:ALU port map(ALU_A,ALU_B,ALUControl,ModifyC,ModifyZ,ALU_output,Cinternal,Zinternal,BEQ_Z);
ALU_Z <= Zinternal;
ALU_C <= Cinternal;
Opcode <= IROutput(15 downto 12);
InstrCZ <= IROutput(1 downto 0);

end architecture ; -- arch