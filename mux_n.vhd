library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;
use ieee.numeric_std.all;

package multiplexer_pkg is
        type mux_array is array(natural range <>) of std_logic_vector;
end package;
library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;
use ieee.numeric_std.all;
use work.multiplexer_pkg.all;

entity mux_n is
generic(n: integer:=16;
		  m: integer :=2);
port (input: in mux_array(2**m -1 downto 0) (n-1 downto 0);
		sel : in std_logic_vector(m-1 downto 0);
		output : out std_logic_vector(n-1 downto 0));
end entity;

architecture arch of mux_n is

begin
output <= input(to_integer(unsigned(sel)));
end arch;

