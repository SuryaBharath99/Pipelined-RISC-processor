library ieee;
use ieee.std_logic_1164.all;

entity DUT is
  port (
  clock,reset:in std_logic
    --PCoutt: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- DUT

architecture arch of DUT is
component datapath is
  port (
  clock: in std_logic;
  DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ,LACounter,LASAUpdate: in std_logic;
  PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl: in std_logic_vector(1 downto 0);
  Opcode: out std_logic_vector(3 downto 0);
  LASACounter: in std_logic_vector(2 downto 0);
  InstrCZ: out std_logic_vector(1 downto 0);
  ALU_Z,LA_Z,ALU_C,BEQ_Z: out std_logic
  ) ;
end component ;

component control_unit is
  port (
  clock,reset: in std_logic;
  DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ,LACounter,LASAUpdate: out std_logic;
  PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl: out std_logic_vector(1 downto 0);
  Opcode: in std_logic_vector(3 downto 0);
  LASACounter: out std_logic_vector(2 downto 0);
  InstrCZ: in std_logic_vector(1 downto 0);
  ALU_Z,LA_Z,ALU_C,BEQ_Z: in std_logic 
  ) ;
end component ;

signal DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ,LACounter,LASAUpdate: std_logic;
signal PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl: std_logic_vector(1 downto 0);
signal Opcode: std_logic_vector(3 downto 0);
signal  LASACounter: std_logic_vector(2 downto 0);
signal InstrCZ: std_logic_vector(1 downto 0);
signal ALU_Z,LA_Z,ALU_C,BEQ_Z: std_logic;
begin
d1: datapath port map(clock,
  DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ,LACounter,LASAUpdate,
  PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl,
  Opcode,
  LASACounter,
  InstrCZ,
  ALU_Z,LA_Z,ALU_C,BEQ_Z);
cu: control_unit port map(clock,reset,
  DatatoMem,MemWrite,IRWrite,RF_A1,RF_A2,RegWrite,RF_D1,ALUSrcA,PCWrite,ModifyC,ModifyZ,LACounter,LASAUpdate,
  PCSelect,IorD,RF_A3,RF_D3,ALUSrcB,ALUControl,
  Opcode,
  LASACounter,
  InstrCZ,
  ALU_Z,LA_Z,ALU_C,BEQ_Z);

end architecture ; -- arch