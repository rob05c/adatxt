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

procedure Main is

    X     : Integer;
    Y     : Integer;
    Errno : Integer;
    Input : Unbounded_String;

    Txt : Buf.Buffer;
    -- ECode : Integer;

    Win_Buf : Buf.Buffer;
    -- Win : Window.Window;

begin
    -- Txt := Buf.Buffer;

    --     Put_Line (Consts.Ansi_Red & "Hallo, Welt!" & Consts.Ansi_Reset);

    --     -- Put_Line ("Term Size is: " & Ascii.CR & Ascii.LF);

    --     Errno := Term.My_Screen_Size (X, Y);
    --     if Errno /= 0 then
    --         Put_Line ("Error getting term size: errno " & Errno'Img);
    --         return;
    --     end if;
    --     Put ("Term Size is: ");
    --     Put (X, Width => 0);
    --     Put ("x");
    --     Put (Y, Width => 0);
    --     Put_Line ("");

    --     Put_Line ("Enter text:");

    --     Input := Get_Line;

    --     Put_Line ("You entered '" & Input & "'");

    --     ECode :=
    --        Buf.Add_At_Cursor
    --           (Txt, To_Unbounded_String ("abcdefghijklmnopqrstuvwxyz"));
    --     if ECode /= 0 then
    --         Put_Line ("Error adding at cursor: code " & ECode'Img);
    --         return;
    --     end if;

    --     Put_Line ("cursor pos " & Buf.Cursor_Pos (Txt)'Img);
    --     Put_Line ("buf len " & Buf.Buffer_Len (Txt)'Img);

    --     ECode := Buf.Move_Cursor (Txt, -13);
    --     if ECode /= 0 then
    --         Put_Line ("Error moving cursor: errno " & ECode'Img);
    --         return;
    --     end if;

    --     Put_Line ("moved");

    --     Put_Line ("cursor pos " & Buf.Cursor_Pos (Txt)'Img);
    --     Put_Line ("buf len " & Buf.Buffer_Len (Txt)'Img);
    --     Put_Line ("Buf.Print '" & Buf.Print (Txt, 0, 0, ECode) & "'");

    --     ECode := Buf.Del_At_Cursor (Txt, 5);
    --     if ECode /= 0 then
    --         Put_Line ("Error deleting at cursor: errno " & ECode'Img);
    --         return;
    --     end if;

    --     ECode := Buf.Add_At_Cursor (Txt, To_Unbounded_String ("<foo>"));
    --     if ECode /= 0 then
    --         Put_Line ("Error deleting at cursor: errno " & ECode'Img);
    --         return;
    --     end if;

    --     Input := Buf.Print (Txt, 0, 0, ECode);

    --     Put_Line ("Buf.Print '" & Input & "'");
    --     Put_Line (To_Unbounded_String ("Buf.A '") & Txt.A & "'");
    --     Put_Line (To_Unbounded_String ("Buf.B '") & Txt.B & "'");

    --     -- tui

    --     Put_Line ("Starting TUI");
    --     Put (Consts.Ansi_Altbuf_Enable);
    --     Put (Consts.Ansi_Screen_Erase);
    --     Put (Consts.Ansi_Cursor_Hide);
    --     Put_Line (Consts.Ansi_Move_Cursor (0, 0));

    --     loop
    --         Put_Line ("Change the window size, and press any key, q to quit...");
    --         Input := Get_Line;

    --         exit when Input = "q";

    --         Errno := Term.My_Screen_Size (X, Y);
    -- p        if Errno /= 0 then
    --             Put_Line ("Error getting term size: errno " & Errno'Img);
    --             return;
    --         end if;
    --         Put ("Term Size is: ");
    --         Put (X, Width => 0);
    --         Put ("x");
    --         Put (Y, Width => 0);
    --         Put_Line ("");
    --     end loop;

    --     Put (Consts.Ansi_Altbuf_Disable);
    --     Put (Consts.Ansi_Cursor_Show);
    --     Put_Line ("Restoring Term");

    --     -- file loading

    --     Put_Line ("Enter the file path to load:");
    --     Input := Get_Line;

    --     -- TODO fix to work with relative paths
    --     Errno := Files.Fill_Buffer_From_File (Input, Win_Buf);
    --     if Errno /= 0 then
    --         Put_Line ("filling win buffer from file: errno " & Errno'Img);
    --         return;
    --     end if;

    --     Input := Buf.Print (Win_Buf, 0, Buf.Buffer_Len (Win_Buf), Errno);
    --     if Errno /= 0 then
    --         Put_Line ("printing win buffer: errno " & Errno'Img);
    --         return;
    --     end if;

    Put_Line ("Starting TUI");
    Put (Consts.Ansi_Altbuf_Enable);
    Put (Consts.Ansi_Screen_Erase);
    Put (Consts.Ansi_Cursor_Hide);
    Put_Line (Consts.Ansi_Move_Cursor (0, 0));

    Errno := Term.My_Screen_Size (X, Y);
    if Errno /= 0 then
        Put_Line ("Error getting term size: errno " & Errno'Img);
        return;
    end if;

    Put (Input);

    Put (Consts.Ansi_Move_Cursor (2, 2));

    Put ("Term Size is: ");
    Put (X, Width => 0);
    Put ("x");
    Put (Y, Width => 0);
    Put_Line ("");

    Window.Draw_Box (3, 3, 50, 100);

    Window.Draw_Text_In_Box
       (To_Unbounded_String
           ("Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo." &
            Ascii.Cr & Ascii.Lf &
            "Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione voluptatem sequi nesciunt, neque porro quisquam est, qui dolorem ipsum, quia dolor sit amet consectetur adipisci[ng] velit, sed quia non numquam [do] eius modi tempora inci[di]dunt, ut labore et dolore magnam aliquam quaerat voluptatem." &
            Ascii.Cr & Ascii.Lf & Ascii.Cr & Ascii.Lf &
            "Ut enim ad minima veniam, quis nostrum[d] exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? [D]Quis autem vel eum i[r]ure reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur?"),
        4, 4, 49, 99);

    Put_Line ("");
    Put ("Press any key to quit" & Ascii.CR & Ascii.LF);
    Put (Consts.Ansi_Cursor_Show);
    Input := Get_Line;

    Put (Consts.Ansi_Cursor_Show);
    Put (Consts.Ansi_Altbuf_Disable);
    Put_Line ("Restoring Term");

    null;
end Main;
