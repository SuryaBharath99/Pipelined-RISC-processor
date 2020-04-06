library ieee;
use ieee.std_logic_1164.all;
use work.multiplexer_pkg.all;

entity datapath is
  port (
	clock,reset: in std_logic
  ) ;
end entity ; -- datapath

architecture arch of datapath is

component control_unit is
 port (
	
	Reg_write_sel,Reg_write_address,Reg_write,conditionC,conditionZ,ALU_operation,Mem_write,LM_SM_enable,er,WB0,WB1,JLR: out std_logic_vector(0 downto 0);
	
	Opcode: in std_logic_vector(3 downto 0);
	Opr1 :in std_logic_vector(1 downto 0)
  ) ;
end component ; -- control_unit


 component reg_n is 
 generic (n : integer := 16);
 port (
 Input: in std_logic_vector(n-1 downto 0);
 Output: out std_logic_vector(n-1 downto 0);
 en : in std_logic_vector(0 downto 0);
 reset: in std_logic;
 clock: in std_logic);
 end component;
 
component Memory_asyncread_syncwrite is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0);
	clk: in std_logic ;Mem_wrbar: in std_logic_vector(0 downto 0);
				Mem_dataout: out std_logic_vector(15 downto 0));
				end component;

component regfile is
   port (
	clock:in std_logic;
	enable: in std_logic_vector(0 downto 0);
	reset: in std_logic;
	A1,A2,A3: in std_logic_vector(2 downto 0);
	WD3: in std_logic_vector(15 downto 0);
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

component inst_decoder is
port(
inst: in std_logic_vector(15 downto 0);
opcode: out std_logic_vector(3 downto 0);
ra: out std_logic_vector(2 downto 0);
rb: out std_logic_vector(2 downto 0);
rc: out std_logic_vector(2 downto 0);
cz: out std_logic_vector(1 downto 0);
imm6: out std_logic_vector(5 downto 0);
imm9: out std_logic_vector(8 downto 0);
pc_con1:out std_logic_vector(0 downto 0); --0 for 6 bit 1 for 9 bit imm
pc_con2:out std_logic_vector(0 downto 0); -- 0 for pc++ 1 for pc+imm
pc_sel1:out std_logic_vector(0 downto 0));
end component;

component mux_n is
generic(n: integer:=16;
		  m: integer :=2);
port (input: in mux_array(2**m -1 downto 0) (n-1 downto 0);
		sel : in std_logic_vector(m-1 downto 0);
		output : out std_logic_vector(n-1 downto 0));
end component;

component Simm6 is
  port (
	A: in std_logic_vector(5 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end component ; -- Simm6

component Simm9 is
  port (
	A: in std_logic_vector(8 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end component ;

component LHI is
  port (
	A: in std_logic_Vector(8 downto 0);
	O: out std_logic_Vector(15 downto 0)
  ) ;
end component ; -- LHI
component isequal is
port(
A,B : in std_logic_vector(15 downto 0);
eq: out std_logic_vector(0 downto 0));
end component;
component SixteenBitAdder is
  port (
		A,B: in std_logic_vector(15 downto 0);
		Cin: in std_logic;
	O: out std_logic_vector(15 downto 0);
	Cout: out std_logic
  ) ;
end component ; -- SixteenBitAdder
component reordering_reg is
	port (
			Inst : in std_logic_vector(14 downto 0);
			Ra,Rb,Rc : out std_logic_vector(2 downto 0)
		);
end component;
component hazard_detection is
port (
	
	I1,I2,I3 : in std_logic_vector(15 downto 0);
    Ra3,Rb3,Rc1,Rc2 : in std_logic_vector(2 downto 0);    
    Cin1,Zin1,Cin2,Zin2 : in std_logic_vector(0 downto 0);
    BEQ_flag1,BEQ_flag2 : in std_logic_vector(0 downto 0);
    a,b,c,d,g,h,load_f,FL_C,LS_stall,i,j : out std_logic_vector(0 downto 0);
    IF_ID_stall,PC_stall,ID_RR_stall : out std_logic_vector(0 downto 0)
    );
end component;
signal  
 pc_in,pc_out,pcplus_if,pc_if,inst_out,inst_in,pcplus_ir,
 lhi16,se6,se9,pcmux1_out,adder2_out,pc_id,lhi16_id,se6id,RD1s,RD2s,loadmux_out,
 alu1_out,rd1mux_out,rd2mux_out,rfmux1gh_out,rfmux2ij_out,pcmux2_out,alu1out_ex,alu1out_mm,mem2out,mem2add,
 rfmux1gh_out_rr,rfmux2ij_out_rr,rfmux1gh_out_ex,WD3s,pc_rr,lhi16_rr,rd2mux_out_rr,rd1mux_out_rr,aluin1_rr,aluin2_rr,pc_ex,lhi16_ex,alu1_out_ex,
 mem2data,RD2s_ex,pc_mm,lhi16_mm,mem2out_mm,alu1_out_mm: std_logic_vector(15 downto 0);
--signal : std_logic_vector(15 downto 0);
signal  imm6bit  :std_logic_vector(5 downto 0);
signal  imm9bit  :std_logic_vector(8 downto 0);
signal  code ,code_id,code_rr,code_ex: std_logic_vector(3 downto 0);
signal  ra1,rb1,rc1,ra1_id,rb1_id,rc1_id ,ra1_rr,rb1_rr,rc1_rr,ra1_ex,rb1_ex,rc1_ex,A3s:  std_logic_vector(2 downto 0);
signal   reorder_a,reorder_b,wr_add,wr_add_rr,wr_add_ex,wr_add_mm,addr:  std_logic_vector(2 downto 0);
signal   cz1,cz1_id,cz1_ex,cz1_rr,cz1_mm,aluop_rr0,rw_sel,cont_mux_out:  std_logic_vector(1 downto 0);
signal  pccon1,pccon2,pcsel1,flush,reg_sel,rw_add_sel,reg_w,
condc,condz,aluop,mw,er_sel,wb0sel,wb1sel,jlrd,rw_sel_rr,rw_sel_ex,rw_sel_mm,reg_wr_port: std_logic_vector(0 downto 0);
signal   haz_a,haz_b,haz_c,haz_d,haz_g,haz_h,haz_i,haz_j,loadf,
WB1s,WB0s,WB1s_rr,WB1s_ex,WB1s_mm,WB0s_rr,WB0s_ex,WB0s_mm,beqflag,beqflag_rr,beqflag_ex,
aluop_rr,coutrin,zoutrin,coutrin_ex,zoutrin_ex,cont_mem_out_ex,
lmsme,lmsme_ex,lmsme_rr,rw_add_sel_rr,rw_add_sel_ex,rw_add_sel_mm,cont_reg_out_rr,
cont_mem_out_rr,cont_reg_out_ex,cont_reg_out_mm,lstall,lstall_rr,enb,er_sel_rr,
er_sel_ex,mem_wr_out,random11,czwr_mm: std_logic_vector(0 downto 0);
signal  czwr,condc_rr,condz_rr,cout,zout: std_logic;
--signal   :  std_logic_vector(2 downto 0);

begin
pc:reg_n port map (pc_in,pc_out,"1",reset,clock);
adder1:SixteenBitAdder port map(pc_out,x"0002",'0',pcplus_if);
mem1:Memory_asyncread_syncwrite port map(pc_out,x"0000",clock,"1",inst_out);
--pcmux0:mux_n generic map(16,1) port map(pcmux0in,random1,pc_in); --pcmux0in has pc select or 

if_id:reg_n generic map(48) port map (Input(47 downto 32)=>pc_out,Input(31 downto 16)=>pcplus_if,
Input(15 downto 0)=>inst_out,Output(47 downto 32)=>pc_if,
Output(31 downto 16)=>pcplus_ir,Output(15 downto 0)=>inst_in,en=>enb,reset=>reset,clock=>clock);

adder2:SixteenBitAdder port map(pc_if,pcmux1_out,'0',adder2_out);
lhi1:LHI port map(imm9bit,lhi16);
sim6:Simm6 port map(imm6bit,se6);
sim9:Simm9 port map(imm9bit,se9);
dec:inst_decoder port map(inst_in,code,ra1,rb1,rc1,cz1,imm6bit,imm9bit,pccon1,pccon2,pcsel1);
pcmux1:mux_n generic map(16,1) port map(input(0)=>se6,input(1)=>se9,sel=>pccon2,output=>pcmux1_out);
pcmux2:mux_n generic map(16,1) port map(input(0)=>pcplus_if,input(1)=>adder2_out,sel=>pcsel1 ,output=>pcmux2_out);

id_ir:reg_n generic map(63) port map(Input(62 downto 47)=>pc_if,Input(46 downto 31)=>lhi16,Input(30 downto 15)=>se6,Input(14 downto 11)=>code,Input(10 downto 8)=>ra1,Input(7 downto 5)=>rb1,Input(4 downto 2)=>rc1,Input(1 downto 0)=>cz1,
Output(62 downto 47)=>pc_id,Output(46 downto 31)=>lhi16_id,Output(30 downto 15)=>se6id,Output(14 downto 11)=>code_id,Output(10 downto 8)=>ra1_id,Output(7 downto 5)=>rb1_id,Output(4 downto 2)=>rc1_id,Output(1 downto 0)=>cz1_id, 
 en=>enb,reset=>reset,clock=>clock );


rf: regfile port map(clock,reg_wr_port,reset,ra1_id,addr,A3s,WD3s,RD1s,RD2s);
rfa3mux:mux_n generic map(3,2) port map(input(0)=>ra1_id,input(1)=>rb1_id,input(2)=>rc1_id,input(3)=>addr,sel=>rw_sel,output=>A3s);
rfrd1mux:mux_n generic map(16,2) port map(input(0)=>RD1s,input(1)=>RD2s,input(2)=>loadmux_out,input(3)=>alu1_out,sel(0 downto 0)=>haz_b,sel(1 downto 1)=>haz_a,output=>rd1mux_out);
rfrd2mux:mux_n generic map(16,2) port map(input(0)=>RD2s,input(1)=>se6id,input(2)=>loadmux_out,input(3)=>alu1_out,sel(0 downto 0)=>haz_d,sel(1 downto 1)=>haz_c,output=>rd2mux_out);
rfmux1gh:mux_n generic map(16,2) port map(input(0)=>RD1s,input(1)=> alu1_out ,input(2)=> loadmux_out,input(3)=> RD2s,sel(0 downto 0)=>haz_h,sel(1 downto 1)=>haz_g, output=>rfmux1gh_out);
rfmux2ij:mux_n generic map(16,2) port map(input(0)=>RD2s ,input(1)=>alu1_out ,input(2)=>loadmux_out,input(3)=>RD1s ,sel(0 downto 0)=>haz_j,sel(1 downto 1)=>haz_i, output=>rfmux2ij_out);
cont_mux:mux_n generic map(2,1) port map(input(0)(0)=>reg_w(0),input(0)(1)=>mw(0),input(1)=>"00",sel=>flush,output=>cont_mux_out);
iseq:isequal port map(rd1mux_out,rd2mux_out,beqflag);
controlunit: control_unit port map(reg_sel,rw_add_sel,reg_w,condc,condz,aluop,mw,lmsme,er_sel,wb0sel,wb1sel,jlrd,code_id,cz1_id);
pcmux3:mux_n generic map(16,1) port map(input(0)=>pcmux2_out,input(1)=>rfmux2ij_out,sel=>jlrd,output=>pc_in);
reorder:reordering_reg port map(Inst(14 downto 11)=>code_id,Inst(10 downto 8)=>ra1_id,Inst(7 downto 5)=>rb1_id,Inst(4 downto 2)=>rc1_id,Inst(1 downto 0)=>cz1_id,Ra=>reorder_a,Rb=>reorder_b,Rc=>wr_add);
loadmux:mux_n generic map(16,1) port map(input(0)=>alu1out_ex,input(1)=>mem2out,sel=>loadf,output=>loadmux_out);
rr_ex:reg_n generic map(112) port map(
    Input(111 downto 111)=>rw_add_sel,
    Input(110 downto 110)=>WB1s,Input(109 downto 109)=>WB0s,Input(108 downto 107)=> rw_sel,
    Input(106)=>cont_mux_out(0),--regwr
    Input(105)=>cont_mux_out(1),--memwr
    Input(104 downto 104)=>lmsme,Input(103 downto 103)=>condz,Input(102 downto 102)=>condc,Input(101 downto 101)=>aluop,Input(100 downto 85)=>pc_id,Input(84 downto 69)=>rfmux1gh_out,Input(68 downto 53)=>lhi16_id,Input(52 downto 52)=>er_sel,Input(51 downto 51)=>beqflag,Input(50 downto 35)=>rd1mux_out,Input(34 downto 19)=>rd2mux_out,Input(18 downto 15)=>code_id,Input(14 downto 12)=>ra1_id,Input(11 downto 9)=>rb1_id,Input(8 downto 6)=>rc1_id,Input(5 downto 4)=>cz1_id,Input(3 downto 3)=>lstall,Input(2 downto 0)=>wr_add,
         Output(110 downto 110)=>rw_add_sel_rr,
	     Output(109 downto 109)=>WB1s_rr,Output(108 downto 108)=>WB0s_rr,Output(107 downto 107)=> rw_sel_rr,Output(106 downto 106)=>cont_reg_out_rr,Output(105 downto 105)=>cont_mem_out_rr,
	     Output(104 downto 104)=>lmsme_rr,Output(103)=>condz_rr,Output(102)=>condc_rr,Output(101 downto 101)=>aluop_rr,Output(100 downto 85)=>pc_rr,
		  Output(84 downto 69)=>rfmux1gh_out_rr,Output(68 downto 53)=>lhi16_rr,Output(52 downto 52)=>er_sel_rr,
		  Output(51 downto 51)=>beqflag_rr,Output(50 downto 35)=>rd1mux_out_rr,Output(34 downto 19)=>rd2mux_out_rr,
		  Output(18 downto 15)=>code_rr,Output(14 downto 12)=>ra1_rr,Output(11 downto 9)=>rb1_rr,
		  Output(8 downto 6)=>rc1_rr,Output(5 downto 4)=>cz1_rr,Output(3 downto 3)=>lstall_rr,
		  Output(2 downto 0)=>wr_add_rr,en=>enb,reset=>reset,clock=>clock);

aluop_rr0(1 downto 1)<="0";
aluop_rr0(0 downto 0)<=aluop_rr;
al1:alu port map(aluin1_rr,aluin2_rr,aluop_rr0,condc_rr,condz_rr,alu1_out,cout,zout);
czreg:reg_n generic map(2) port map(Input(1)=>zout,Input(0)=>cout,Output(1 downto 1)=>zoutrin,Output(0 downto 0)=>coutrin,en=>enb,reset=>reset,clock=>clock);

ex_mem:reg_n generic map(93) port map(
		 Input(92 downto 92)=>lmsme_rr,
		 Input(91 downto 91)=>rw_add_sel_rr,
	     Input(90 downto 90)=>WB1s_rr,Input(89 downto 89)=>WB0s_rr,Input(88 downto 88)=> rw_sel_rr,Input(87 downto 87)=>cont_reg_out_rr,Input(86 downto 86)=>cont_mem_out_rr,
		  Input(85 downto 70)=>pc_rr ,Input(69 downto 54)=>lhi16_rr ,Input(53 downto 53)=>beqflag_rr,Input(52 downto 52)=>er_sel_rr,
Input(51 downto 36)=>rfmux1gh_out_rr,Input(35 downto 20)=>alu1_out,Input(19 downto 19)=>zoutrin,Input(18 downto 18)=>coutrin,
Input(17 downto 14)=>code_rr,Input(13 downto 11)=>ra1_rr,Input(10 downto 8)=>rb1_rr,
Input(7 downto 5)=>rc1_rr,Input(4 downto 3)=>cz1_rr,Input(2 downto 0)=>wr_add_rr,
		 Output(92 downto 92)=>lmsme_ex,
		 Output(91 downto 91)=>rw_add_sel_rr,
	     Output(90 downto 90)=>WB1s_ex, Output(89 downto 89)=>WB0s_ex,Output(88 downto 88)=> rw_sel_ex,Output(87 downto 87)=>cont_reg_out_ex,
		  Output(86 downto 86)=>cont_mem_out_ex,Output(85 downto 70)=>pc_ex ,Output(69 downto 54)=>lhi16_ex ,
		  Output(53 downto 53)=>beqflag_ex,Output(52 downto 52)=>er_sel_ex,Output(51 downto 36)=>rfmux1gh_out_ex,Output(35 downto 20)=>alu1_out_ex,
		  Output(19 downto 19)=>zoutrin_ex,Output(18 downto 18)=>coutrin_ex,Output(17 downto 14)=>code_ex,Output(13 downto 11)=>ra1_ex,
		  Output(10 downto 8)=>rb1_ex,Output(7 downto 5)=>rc1_ex,
Output(4 downto 3)=>cz1_ex,Output(2 downto 0)=>wr_add_ex,en=>enb,reset=>reset,clock=>clock);
 czwr<=(cz1_ex(0) and coutrin_ex(0)) or (cz1_ex(1) and zoutrin_ex(0));
mem2:Memory_asyncread_syncwrite port map(mem2add,mem2data,clock,mem_wr_out,mem2out);
memwrmux1:mux_n generic map(1,1) port map(input(0)=>cont_mem_out_ex,input(1)=>random11,sel=>lmsme_ex,output=>mem_wr_out);
memmux1:mux_n generic map(16,1) port map(input(0)=>alu1out_ex,input(1)=>RD2s_ex,sel=>lmsme_ex,output=>mem2add);
memmux2:mux_n generic map(16,1) port map(input(0)=>alu1out_ex,input(1)=>RD2s_ex,sel=>er_sel_ex,output=>mem2data);
mem_wb:reg_n generic map(75) port map( Input(74) => czwr ,Input(73)=>rw_add_sel_ex(0),
	     Input(72)=>WB1s_ex(0),Input(71)=>WB0s_ex(0),Input(70)=> rw_sel_ex(0),Input(69)=>cont_reg_out_ex(0),Input(68 downto 53)=>pc_ex ,Input(52 downto 37)=>lhi16_ex,Input(36 downto 21)=>mem2out,Input(20 downto 5)=>alu1out_ex,Input(4 downto 3)=>cz1_ex,Input(2 downto 0)=>wr_add_ex,
	     Output(74)=>czwr_mm(0),
	     Output(73)=>rw_add_sel_mm(0),
	     Output(72)=>WB1s_mm(0),Output(71)=>WB0s_mm(0),Output(70)=> rw_sel_mm(0),Output(69)=>cont_reg_out_mm(0),
		  Output(68 downto 53)=>pc_mm ,Output(52 downto 37)=>lhi16_mm,Output(36 downto 21)=>mem2out_mm,Output(20 downto 5)=>alu1out_mm,Output(4 downto 3)=>cz1_mm,Output(2 downto 0)=>wr_add_mm,en=>enb,reset=>reset,clock=>clock);
czwrmux1:mux_n generic map(1,1) port map(input(0)=>cont_reg_out_mm,input(1)=>czwr_mm,sel=>rw_sel_rr,
output=>reg_wr_port);
wbmux1:mux_n generic map(16,2) port map(input(0)=>alu1_out_mm,input(1)=>mem2out_mm,input(2)=>lhi16_mm,input(3)=>pc_mm,sel(1)=>WB1s_mm(0),sel(0)=>WB0s_mm(0),output=>WD3s);

hazard_detection1:hazard_detection port map(I3(14 downto 11)=> code_id,I3(10 downto 8)=>ra1_id , 
I3(7 downto 5)=>rb1_id, I3(4 downto 2)=>rc1_id ,I3(1 downto 0)=>cz1_id,
I2(14 downto 11)=>code_rr ,I2(10 downto 8)=> ra1_rr, I2(7 downto 5)=>rb1_rr, I2(4 downto 2)=> rc1_rr,
I2(1 downto 0)=>cz1_rr, I1(14 downto 11)=>code_ex ,I1(10 downto 8)=>ra1_ex, I1(7 downto 5)=>rb1_ex, 
I1(4 downto 2)=>rc1_ex ,I1(1 downto 0)=>cz1_ex, Ra3=> reorder_a,Rb3=> reorder_b,
Rc1=> wr_add_ex,Rc2=>wr_add_rr,Cin1=>coutrin ,Cin2(0)=>cout ,Zin1=> zoutrin,Zin2(0)=>zout ,
beq_flag1=> beqflag_rr,beq_flag2=>beqflag_ex,a=>haz_a,b=>haz_b,c=>haz_c,d=>haz_d,g=>haz_g,h=>haz_h,i=>haz_i,j=>haz_j, 
load_f=>loadf,FL_C=>flush,LS_stall=>lstall  ) ;


end arch; 


