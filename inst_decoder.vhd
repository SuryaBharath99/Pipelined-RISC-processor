library ieee;
use ieee.std_logic_1164.all;

entity inst_decoder is
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
end;
architecture instdec of inst_decoder is
begin
opcode<= inst(15 downto 12);
ra<=inst(11 downto 9);
rb<=inst(8 downto 6);
rc<=inst(5 downto 3);
cz<= inst(1 downto 0);
imm6<= inst(5 downto 0);
imm9<= inst(8 downto 0);
process(opcode)
begin
case opcode is
when "1100" =>   --beq
pc_con1<="0";
pc_con2<="1";
pc_sel1<="1";
when "1000" =>	  --jal
pc_con1<="1";
pc_con2<="1";
pc_sel1<="0";
when "0011" =>   --lhi
pc_con1<="1";
pc_con2<="0";
pc_sel1<="0";
when "0110"=>    --lm
pc_con1<="1";
pc_con2<="0";
pc_sel1<="0";
when "0111" =>   --sm
pc_con1<="1";
pc_con2<="0";
pc_sel1<="0";
when others =>
pc_con1<="0";
pc_con2<="0";
pc_sel1<="0";
end case;
end process;


end instdec;
