library ieee;
use ieee.std_logic_1164.all;


entity pipeline_risc is

port (con,en,clock,reset: in std_logic;
inst:in std_logic_vector(15 downto 0);
over:out std_logic);

end entity;

architecture check of pipeline_risc is

component lm_sm is
port(
con,en: in std_logic;
inst:in std_logic_vector(15 downto 0);
rd1:in std_logic_vector(15 downto 0);
rd2:in std_logic_vector(15 downto 0);
mem_in: in std_logic_vector(15 downto 0);
clock,reset:in std_logic;
over: out std_logic;
mem_addr:out std_logic_vector(15 downto 0);
reg_select: out std_logic_vector(2 downto 0);
mem_wr: out std_logic_vector(15 downto 0);
reg_wr: out std_logic_vector(15 downto 0);
reg_sig,mem_sig: out std_logic
);
end component;

component Memory_asyncread_syncwrite is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
end component;

component regfile is
  port (
	clock,enable,reset: in std_logic;
	A1,A2,A3: in std_logic_vector(2 downto 0);
	WD3: in std_logic_vector(15 downto 0);
	RD1,RD2: out std_logic_vector(15 downto 0)
  ) ;
end component ;
signal A2: std_logic_vector(2 downto 0);
signal rw_wr,rd1t,rd2t,memint,mem_addrt,mem_wrt:std_logic_vector(15 downto 0);
signal overt,rwr,mwr: std_logic;
begin

regfile1: regfile port map(clock,rwr,reset,inst(11 downto 9),A2,A2,rw_wr,rd1t,rd2t);

lmsm1: lm_sm port map(con,en,inst,rd1t,rd2t,memint,clock,reset,overt,mem_addrt,A2,mem_wrt,rw_wr,rwr,mwr);

mem: memory_asyncread_syncwrite port map(mem_addrt,mem_wrt,clock,mwr,memint);
over<=overt;
end check; 