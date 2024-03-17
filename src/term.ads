with Interfaces;   use Interfaces;
with Interfaces.C; use Interfaces.C;
with Ada.Text_IO;  use Ada.Text_IO;

package Term is

   function My_Screen_Size (SX : out Integer; SY : out Integer) return Integer;
end Term;
