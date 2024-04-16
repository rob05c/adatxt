with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings;     use Ada.Strings;

package body Consts is

   -- Ansi_Move_Cursor returns the ANSI code to move the cursor to X,Y
   -- It does not move the cursor itself; it only returns the ansi code text to do so.
   -- The x and y inputs should be 0-based
   function Ansi_Move_Cursor
     (X : in Integer; Y : in Integer) return Unbounded_String
   is
      X0 : Integer;
      Y0 : Integer;
   begin
      -- the escape code is 1-indexed, so add 1 to our 0-based input.
      X0 := X + 1;
      Y0 := Y + 1;
      return
        To_Unbounded_String (ASCII.ESC & "") & To_Unbounded_String ("[") &
        To_Unbounded_String (Trim (X0'Img, Ada.Strings.Both)) &
        To_Unbounded_String (";") &
        To_Unbounded_String (Trim (Y0'Img, Ada.Strings.Both)) &
        To_Unbounded_String ("H");

   end Ansi_Move_Cursor;

end Consts;
