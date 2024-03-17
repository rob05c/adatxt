with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with Ada.Strings;              use Ada.Strings;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Consts;
with Term;
with Buf;

procedure Main is

   X     : Integer;
   Y     : Integer;
   Errno : Integer;
   Input : Unbounded_String;

   Txt   : Buf.Buffer;
   ECode : Integer;

begin
   -- Txt := Buf.Buffer;

   Put_Line (Consts.Ansi_Red & "Hallo, Welt!" & Consts.Ansi_Reset);

   -- Put_Line ("Term Size is: " & Ascii.CR & Ascii.LF);

   Errno := Term.My_Screen_Size (X, Y);
   if Errno /= 0 then
      Put_Line ("Error getting term size: errno " & Errno'Img);
      return;
   end if;
   Put ("Term Size is: ");
   Put (X, Width => 0);
   Put ("x");
   Put (Y, Width => 0);
   Put_Line ("");

   Put_Line ("Enter text:");

   Input := Get_Line;

   Put_Line ("You entered '" & Input & "'");

   ECode :=
     Buf.Add_At_Cursor
       (Txt, To_Unbounded_String ("abcdefghijklmnopqrstuvwxyz"));
   if ECode /= 0 then
      Put_Line ("Error adding at cursor: code " & ECode'Img);
      return;
   end if;

   Put_Line ("cursor pos " & Buf.Cursor_Pos (Txt)'Img);
   Put_Line ("buf len " & Buf.Buffer_Len (Txt)'Img);

   ECode := Buf.Move_Cursor (Txt, -13);
   if ECode /= 0 then
      Put_Line ("Error moving cursor: errno " & ECode'Img);
      return;
   end if;

   Put_Line ("moved");

   Put_Line ("cursor pos " & Buf.Cursor_Pos (Txt)'Img);
   Put_Line ("buf len " & Buf.Buffer_Len (Txt)'Img);
   Put_Line ("Buf.Print '" & Buf.Print(Txt, 0, 0, ECode) & "'");

   ECode := Buf.Del_At_Cursor (Txt, 5);
   if ECode /= 0 then
      Put_Line ("Error deleting at cursor: errno " & ECode'Img);
      return;
   end if;

   ECode := Buf.Add_At_Cursor (Txt, To_Unbounded_String ("<foo>"));
   if ECode /= 0 then
      Put_Line ("Error deleting at cursor: errno " & ECode'Img);
      return;
   end if;

   Input := Buf.Print (Txt, 0, 0, ECode);

   Put_Line ("Buf.Print '" & Input & "'");
   Put_Line (To_Unbounded_String ("Buf.A '") & Txt.A & "'");
   Put_Line (To_Unbounded_String ("Buf.B '") & Txt.B & "'");

   null;
end Main;
