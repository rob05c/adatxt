with Interfaces;            use Interfaces;
with Interfaces.C;          use Interfaces.C;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Buf;

-- Window is the viewable window.
-- It contains the position of the window in the buffer,
-- and the position of the cursor in the buffer.
--
-- It currently contains the buffer itself, but in the future this should be a link
-- Currently there's only 1 window, but in the future it should be possible to split
-- the app into multiple window panes

package Window is

   type IntCoord is record
      X : Integer;
      Y : Integer;
   end record;

   type Window is record
      -- position of the buffer in the viewable window
      Window_Buffer_Pos : IntCoord;
      -- position of the text cursor in the buffer (*not* in the window)
      Cursor_Buffer_Pos : IntCoord;
      Txt               : Buf.Buffer;
   end record;

   procedure Draw_Box
     (X_Start : Integer; Y_Start : Integer; X_End : Integer; Y_End : Integer);
   procedure Draw_Text_In_Box
     (Str   : Unbounded_String; X_Start : Integer; Y_Start : Integer;
      X_End : Integer; Y_End : Integer; Erase_Trailing : Integer);
   function Slice_Nth_Newline(Str : Unbounded_String; Nth : Integer) return Unbounded_String;
end Window;
