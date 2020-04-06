library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;
entity lm_sm is
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
end entity;

architecture lmsm of lm_sm is
--component reg_n is 
-- generic (n : integer := 16);
-- port (
-- Input: in std_logic_vector(n-1 downto 0);
-- Output: out std_logic_vector(n-1 downto 0);
-- en : in std_logic;
-- reset: in std_logic;
-- clock: in std_logic);
-- end component;

type FsmState is (S0,S1,S2);
signal fsm_state: FsmState;
signal reg_address,inst_s:std_logic_vector(7 downto 0);
signal rd2_s,mem_ins,LMSMaddr:std_logic_vector(15 downto 0);
signal reg_select_s:std_logic_vector(2 downto 0);
--signal counter:integer;
begin
inst_s<=inst(7 downto 0);
--reg1:reg_n port(rd1,LMSMCountersig);
pro : process(clock,reset,inst,fsm_state,rd1,rd2,con,en,mem_in,inst_s,rd2_s,mem_ins,LMSMaddr)
variable next_fsm_state: FsmState;
variable counter,counter_var: integer:=0;
variable LMSMaddr_var,mem_addr_var,reg_wr_var,mem_wr_var: std_logic_vector(15 downto 0);
variable over_var,mem_sig_var,reg_sig_var:std_logic;
variable reg_select_var:std_logic_vector(2 downto 0);
begin
--reg_address <= inst(7 downto 0);
rd2_s<=rd2;
mem_ins<=mem_in;
next_fsm_state:=fsm_state;
over_var:='0';
LMSMaddr_var:=rd1;
counter_var:=0;
reg_select_var:="000";
mem_addr_var:=x"0000";
reg_wr_var:=x"0000";
mem_wr_var:=x"0000";
case (fsm_state) is
	when S0 =>
		--variables
		--if (Opcode="0000" or Opcode="0010" or Opcode="0001" or Opcode="1001" or Opcode="0111" or Opcode="0110" or Opcode="0100" or Opcode="0101" or Opcode="1100") then
		--	next_fsm_state:=S1;
		--reg_address <= inst(7 downto 0);
		LMSMaddr_var :=rd1;
		counter_var:=-2;
		reg_select_var:="000";
		mem_addr_var:=x"0000";
		reg_wr_var:=x"0000";
		mem_wr_var:=x"0000";
		reg_sig_var:='0';
		mem_sig_var:='0';
		if (en='1' and con='1') then
			next_fsm_state:=S1;
			over_var:='0';
			
		elsif (en='1' and con='0') then
			next_fsm_state :=S2;
			over_var:='0';
 		else
 			next_fsm_state :=S0;
			counter_var:=0;
			over_var:='0';
			
		end if;
		
	when S1=>
	if( counter_var>=0) then
		if(inst_s(conv_integer(to_unsigned(counter_var,3)))='1') then
			mem_addr_var:=LMSMaddr;
			--reg_select_var:=std_logic_vector(to_unsigned(counter_var,3));
			LMSMaddr_var:=std_logic_vector(unsigned(LMSMaddr)+1);
			reg_wr_var:=mem_ins;
			reg_sig_var:='1';
			mem_sig_var:='0';
		else
			reg_sig_var:='0';
			mem_sig_var:='0';
		end if;
	end if;
		counter_var:=counter+1;
 		   if(counter_var=7) then
			next_fsm_state:=S0;
			over_var:='1';
			else
			next_fsm_state:=S1;
			over_var:='0';
			end if;
			
 	when S2 =>
	  if( counter_var>=0) then
		if(inst_s(conv_integer(to_unsigned(counter_var,3)))='1') then
		mem_addr_var:=LMSMaddr;
		--reg_select_var:=std_logic_vector(to_unsigned(counter_var,3));
		LMSMaddr_var:=std_logic_vector(unsigned(LMSMaddr)+1);
		mem_wr_var:=rd2_s;
		reg_sig_var:='0';
		mem_sig_var:='1';
	else
			reg_sig_var:='0';
			mem_sig_var:='0';
		end if;
	end if;	
		counter_var:=counter+1;
 		if(counter_var=7) then
			next_fsm_state:=S0;
			over_var:='1';
			else
			next_fsm_state:=S2;
			over_var:='0';
		end if;
 	
-- 	when S8 =>
-- 		RegWritevar := '1';
-- 		RF_D3var:="10";
-- 		RF_A3var:="00";
-- 		next_fsm_state := S0;

 	
	when others =>
		null;
end case;
	
if(rising_edge(clock)) then
	if(reset='1') then
	fsm_state<=S0;
	counter:=0;
	--counter_var:=-1;
else
	fsm_state<=next_fsm_state;
	mem_addr<=mem_addr_var;
	reg_select <=std_logic_vector(to_unsigned(counter_var,3));
	reg_wr<=reg_wr_var;
	mem_wr<=mem_wr_var;
	over<=over_var;
	counter:=counter_var;
	LMSMaddr<=LMSMaddr_var;
	reg_sig<=reg_sig_var;
	mem_sig<=mem_sig_var;
end if;
end if;
end process;

end lmsm;