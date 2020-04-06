library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions

entity reordering_reg is
	port (
			Inst : in std_logic_vector(14 downto 0);

	        Ra,Rb,Rc : out std_logic_vector(2 downto 0)

		);
end entity;	



architecture reordering_reg_arc of reordering_reg is

begin

process(Inst)
variable Ra_var,Rb_var,Rc_var : std_logic_vector(2 downto 0);
variable Inst_opcode : std_logic_vector(3 downto 0);


begin
    Inst_opcode  := Inst(14 downto 11);
	if (Inst_opcode = "0000" or Inst_opcode = "0010") then
       Rc_var := Inst(4 downto 2);
       Ra_var := Inst(10 downto 8);
       Rb_var := Inst(7 downto 5);

    elsif(Inst_opcode = "0001") then
       Rc_var := Inst(7 downto 5);
        Ra_var := Inst(10 downto 8);

    elsif(Inst_opcode = "0011" or Inst_opcode = "0110" or Inst_opcode = "0111" or Inst_opcode ="1000") then
    	Rc_var := Inst(10 downto 8);

    elsif (Inst_opcode = "0100") then
    	Rc_var := Inst(10 downto 8);
    	Ra_var := Inst(7 downto 5);
    else
    	Rc_var := Inst(10 downto 8);
    	Ra_var := Inst(7 downto 5);

	end if;
	Rc <= Rc_var;
	Rb <= Rb_var;
	Ra <= Ra_var;



end process;
end architecture;