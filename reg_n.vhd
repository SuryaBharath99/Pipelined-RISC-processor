library ieee;
use ieee.std_logic_1164.all;
 entity reg_n is 
 generic (n : integer := 16);
 port (
 Input: in std_logic_vector(n-1 downto 0);
 Output: out std_logic_vector(n-1 downto 0);
 en : in std_logic_vector(0 downto 0);
 reset: in std_logic;
 clock: in std_logic);
 end entity;
 
 
 architecture beh of reg_n is
 
 begin
aw : process( clock,en,reset)
begin
	if(rising_edge(clock) and en="1" and reset='0') then
      Output<=Input;
	elsif(rising_edge(clock) and en="1" and reset='1') then
	   Output<=(others =>'0');
      end if;
end process ; -- a 
end architecture ; -- arch