with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with Ada.Strings;              use Ada.Strings;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Consts;
with Term;
with Buf;
with Files;
with Window;

package body Files is

   function Fill_Buffer_From_File
     (File_Path : Unbounded_String; My_Buf : in out Buf.Buffer) return Integer
   is
      My_File : File_Type;
      Input   : Unbounded_String;
      Errno : Integer;
   begin
      begin
         Open (My_File, In_File, To_String(File_Path));
      exception
         when Name_Error =>
            Put_Line ("Files.Open threw name err");
            -- do nothing - if the file doesn't exist, return success and an empty buffer
            -- TODO return feedback to the user/ui?
            return 0;
         when others     =>
            Put_Line ("Files.Open threw unknown");
            return File_Error_Unknown;
      end;

      Put_Line ("Files.Open reading to eof");
      while not End_Of_File (My_File) loop
         -- TODO handle get_line error
         Input := Get_Line (My_File) & Ascii.CR & Ascii.LF;
         Errno := Buf.Add_At_Cursor (My_Buf, Input);
         if Errno /= 0 then
           return Errno;
         end if;
      end loop;
      Close (My_File);
      return File_Error_Success;
   end Fill_Buffer_From_File;
end Files;
