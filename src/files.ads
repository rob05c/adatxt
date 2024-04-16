with Interfaces;            use Interfaces;
with Interfaces.C;          use Interfaces.C;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Buf;
-- File contains utilities for reading and writing files into buffers.
package Files is

   File_Error_Success  : constant Integer := 0;
   File_Error_No_Exist : constant Integer := 1;
   File_Error_Unknown  : constant Integer := 255;

   -- populates Buf from File_Path, and returns any error code.
   -- TODO don't load the whole file, only load the screen +/- x
   -- to enable large file loading
   function Fill_Buffer_From_File
     (File_Path : Unbounded_String; My_Buf : in out Buf.Buffer) return Integer;
end Files;
