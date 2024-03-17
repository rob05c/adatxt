with Interfaces;   use Interfaces;
with Interfaces.C; use Interfaces.C;
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

-- Buf is the text buffer of a buffer, a la Emacs Buffers.
package Buf is

   type Buffer is record

      -- We use 2 character buffers, where the cursor position is between the two.
      -- This is the same thing Emacs does; it has pros and cons.
      -- We could switch to a "smarter" structure like a Rope in the future.
      -- TODO use a regular String, and keep track of the length, reallocate, etc ourselves.
      A : Unbounded_String;
      B : Unbounded_String;

   end record;

   -- type New_Buf is new Buf;

   -- Returns 0 on success, or an error code
   function Add_At_Cursor
     (B : in out Buffer; S : Unbounded_String) return Integer;

   -- Returns 0 on success, or an error code
   function Del_At_Cursor (B : in out Buffer; I : Integer) return Integer;

   -- Returns 0 on success, or an error code
   function Move_Cursor (B : in out Buffer; I : Integer) return Integer;
   -- Returns the character in Buf between the indexes PStart and PEnd
   function Print
     (B     : in out Buffer; PStart : Integer; PEnd : Integer;
      Ecode :    out Integer) return Unbounded_String;

   function Cursor_Pos (B : Buffer) return Integer;
   function Buffer_Len (B : Buffer) return Integer;
end Buf;
