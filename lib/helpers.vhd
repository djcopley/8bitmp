library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package helpers is

  function slv2index (X : std_logic_vector) return integer;

end package;

package body helpers is

  function slv2index (X : std_logic_vector) return integer is
  begin
    return to_integer(unsigned(X));
  end function slv2index;

end package body helpers;
