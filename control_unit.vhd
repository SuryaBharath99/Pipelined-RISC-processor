library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions

entity control_unit is
  port (
	
	Reg_write_sel,Reg_write_address,Reg_write,conditionC,conditionZ,ALU_operation,Mem_write,LM_SM_enable,er,WB0,WB1,JLR: out std_logic_vector(0 downto 0);
	
	Opcode: in std_logic_vector(3 downto 0);
	Opr1 :in std_logic_vector(1 downto 0)
  ) ;
end entity ; -- control_unit


architecture arch of control_unit is
	begin

process(Opcode,Opr1)

variable conditionC_v,conditionZ_v,ALU_operation_v,Mem_write_v,LM_SM_enable_v,er_v,WB0_v,WB1_v,JLR_v,Reg_write_sel_v,Reg_write_v,Reg_write_address_v : std_logic_vector(0 downto 0);

begin

    Reg_write_sel_v := "0" ;
	conditionC_v := "0" ;-- no condition
	conditionZ_v := "0" ;-- no condition
	ALU_operation_v := "0";--addition
	Mem_write_v := "0" ;--donot write
	LM_SM_enable_v := "0" ;--
	er_v := "0" ;--selects alu output as the input to MEM data 
	WB0_v := "0";
	WB1_v := "0";
	JLR_v := "0";
	Reg_write_v := "1";
	Reg_write_address_v := "0";
	if (Opcode = "0000" and Opr1 ="10") then 
		conditionC_v := "1"; 
		Reg_write_sel_v := "1";

	elsif (Opcode = "0000" and Opr1 = "01") then
		conditionZ_v := "1";
		Reg_write_sel_v := "1";
	elsif (Opcode = "0010") then
		ALU_operation_v := "1";
		if(Opr1 = "10")then	
		 conditionC_v := "1";
		 Reg_write_sel_v := "1";
		elsif(Opr1 = "01") then
		 conditionZ_v := "1";
		 Reg_write_sel_v := "1";
        end if; 
	elsif (Opcode = "0011") then
		WB1_v := "1";
	elsif (Opcode = "0100") then
		WB0_v := "1";		
    elsif (Opcode = "0101") then
    	er_v := "1";
    	Mem_write_v := "1";
    	Reg_write_v := "0"; 

    elsif (Opcode = "0110" or Opcode = "0111") then
    	LM_SM_enable_v := "1";
    elsif (Opcode = "1100") then
    	Reg_write_v := "0"; 
        
    elsif (Opcode = "1000") then
        WB0_v := "1";
        WB1_v := "1";
        
    else
      
      JLR_v := "1";
	  WB1_v := "1";
	  WB0_v := "1";
	end if;


conditionC  <= conditionC_v;

conditionZ <= conditionZ_v;

ALU_operation <=  ALU_operation_v;
Mem_write <= Mem_write_v;
LM_SM_enable<= LM_SM_enable_v;
er <= er_v;

WB0 <= WB0_v;
WB1 <= WB1_v;
JLR <= JLR_v;
Reg_write_sel <= Reg_write_sel_v;
Reg_write <= Reg_write_v;
Reg_write_address <= Reg_write_address_v;

	
	
end process;

end architecture ;