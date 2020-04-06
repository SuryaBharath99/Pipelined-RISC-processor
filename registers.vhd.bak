library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register16bitwithoutenable is
  port (
	clock: in std_logic;
	A: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- register16bitwithoutenable

architecture arch of register16bitwithoutenable is
begin
agh : process( clock )
begin
	if(rising_edge(clock)) then
      O<=A;
      end if;
end process ; -- a
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;

entity IRreg is
  port (
  enable:in std_logic;
  A: in std_logic_vector(15 downto 0);
  O: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- IRreg
architecture arch of IRreg is
begin
pro : process( enable,A )
begin
  if(enable='1') then
    O<=A;
  end if;
end process ; -- pro


end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity register16bitwithenable is
  port (
	clock,enable: in std_logic;
	A: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- register16bitwithenable

architecture arch of register16bitwithenable is
--signal last: std_logic_vector(15 downto 0);
begin
atgr : process( clock,enable )
begin
	if(clock'event and clock='1') then
		if(enable='1') then
      O<=A;
      --last<=A;
      end if;
     --else O<=last;
      end if;
end process ; -- a
end architecture ; -- arch

library ieee;
use ieee.std_logic_1164.all;
entity register3bitwithenable is
  port (
	clock,enable: in std_logic;
	A: in std_logic_vector(2 downto 0);
	O: out std_logic_vector(2 downto 0)
  ) ;
end entity ; -- register3bitwithenable

architecture arch of register3bitwithenable is
begin
aw : process( clock )
begin
	if(rising_edge(clock) and enable='1') then
      O<=A;
      end if;
end process ; -- a
end architecture ; -- arch