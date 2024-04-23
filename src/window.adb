with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Maps;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with Ada.Strings;              use Ada.Strings;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Consts;
with Term;
with Buf;
with Files;
with Window;

with Consts;

package body Window is

   -- Draws a box at the given coordinates, inclusive.
   --
   -- TODO create a "Draw_Box_In_Frame" that takes a "window"
   -- and draws via Put relatively in the frame/window instead of absolutely
   -- TODO can we put all the movements and writes in a single Put?
   -- TODO styles: pretty unicode chars, colors, etc
   procedure Draw_Box
     (X_Start : Integer; Y_Start : Integer; X_End : Integer; Y_End : Integer)
   is
      Write_Buf : Unbounded_String;
      Height    : Integer;
      Width     : Integer;
   begin
      -- send the ansi code to move the cursor to the draw position
      Write_Buf := Consts.Ansi_Move_Cursor (X_Start, Y_Start);
      Put (Write_Buf);

      Height := X_End - X_Start;
      Width  := Y_End - Y_Start;

      -- draw the top of the box
      Write_Buf := To_Unbounded_String ("");
      for I in 0 .. Width loop
         Ada.Strings.Unbounded.Append (Write_Buf, "-");
      end loop;
      Put (Write_Buf);

      -- move cursor back to the start of the next line
      Write_Buf := Consts.Ansi_Move_Cursor (X_Start + 1, Y_Start);
      Put (Write_Buf);

      -- draw the empty sides of the box, all the way down
      for Cur_X in 1 .. Height - 1 loop
         Write_Buf := Consts.Ansi_Move_Cursor (X_Start + Cur_X, Y_Start);
         Put (Write_Buf);
         Put ("|");
         Write_Buf := Consts.Ansi_Move_Cursor (X_Start + Cur_X, Y_End);
         Put (Write_Buf);
         Put ("|");
      end loop;

      -- finally, draw the bottom of the box

      -- move cursor to the start of the bottom line
      Write_Buf := Consts.Ansi_Move_Cursor (X_End - 1, Y_Start);
      Put (Write_Buf);

      Write_Buf := To_Unbounded_String ("");
      for I in 0 .. Width loop
         Ada.Strings.Unbounded.Append (Write_Buf, "-");
      end loop;
      Put (Write_Buf);

      null;
   end Draw_Box;

   -- Draws the given text inside the given coordinates.
   -- Lines longer than the width are wrapped onto the next line inside the box.
   -- Text larger than the box is truncated.
   --
   -- TODO add params for whether to lines wrap or truncate.
   -- TODO return the point where the text outside the box was truncated?
   -- TODO coord and/or box type, instead of raw ints?
   -- TODO for line truncation, configurable delimiter indicating truncation took place (e.g. hyphen, tilde)
   --
   -- TODO erase trailing lines (and characters!) in box, to clear old text
   --
   procedure Draw_Text_In_Box
     (Str   : Unbounded_String; X_Start : Integer; Y_Start : Integer;
      X_End : Integer; Y_End : Integer; Erase_Trailing: Integer)
   is
      Write_Buf : Unbounded_String;
      Height    : Integer;
      Width     : Integer;

      Cur_X     : Integer;
      Cur_Str   :
        Unbounded_String;    -- Cur_Str is the remaining Str that hasn't been written    -- Cur_Str is the remaining Str that hasn't been written
      Cur_Width : Integer;
      Next_Str  : Unbounded_String;

      Newline_From : Integer;
      Newline_To   : Integer;

      Tempi : Integer;

      Tmp_loopi : Integer;
   begin
      -- send the ansi code to move the cursor to the draw position
      Write_Buf := Consts.Ansi_Move_Cursor (X_Start, Y_Start);
      Put (Write_Buf);

      Height := X_End - X_Start;
      Width  := Y_End - Y_Start + 1;

      Cur_X := 0; -- current x (vertical) relative to the box

      Next_Str := Str;

      Tmp_loopi := 0;

      loop
         Write_Buf := Consts.Ansi_Move_Cursor (X_Start + Cur_X, Y_Start);
         Put (Write_Buf);

         Tmp_loopi := Tmp_loopi + 1;
         if Next_Str = "" then
            -- Put_Line ("DEBUG eNext_Str '" & Next_Str & "'");
            exit;
         end if;
         -- Put_Line ("DEBUG Next_Str '" & Next_Str & "'");

         Cur_Str := Next_Str;

         Newline_From := 0;
         Newline_To   := 0;
         Find_Token
           (Source => Cur_Str, Set => Ada.Strings.Maps.To_Set (Ascii.Lf),
            Test   => Inside, From => 1, First => Newline_From,
            Last   => Newline_To);

         if Newline_From = 1 and Newline_To = 0 then
            -- if there's no newline, no more string, terminate the loop next time,
            -- and keep Cur_Str as the rest of the remaining string
            Next_Str := To_Unbounded_String ("");
            -- Put_Line ("DEBUG Next_Str '" & Next_Str & "'");
            -- return;
         else
            Next_Str :=
              Unbounded_Slice
                (Cur_Str, Newline_From + 1, Length (Cur_Str));
            Cur_Str  := Unbounded_Slice (Cur_Str, 1, Newline_From - 1);
            -- Put_Line
            --   ("DEBUG Newline_from '" & Newline_From'Img & "'");
            -- Put_Line
            --   ("DEBUG lCur_Str '" & Length (Cur_Str)'Img & "'");
            -- Put_Line ("DEBUG Next_Str1 '" & Next_Str & "'");
            -- if Tmp_loopi = 3 then
            --    Put_Line ("DEBUG Cur_Str CCC" & Cur_Str & "CCC");
            --    Put_Line ("DEBUG Next_Str SSS" & Next_Str & "SSS");
            --    return;
            -- end if;

         end if;

         -- at this point, cur_str is the line to print, and next_str is what comes after for the next loop
         -- now, we need to wrap the current line and print it

         -- if the line is a blank line, as a special case, advance Cur_X (the vertical position),
         -- since it will never enter the while len>0 loop
         if Length (Cur_Str) = 0 then
            Cur_X := Cur_X + 1;
         end if;

         Cur_Width := 0;

         -- print the line, potentially wrapping onto the next line
         while Cur_X < Height and Length (Cur_Str) > 0 loop
            Write_Buf :=
              Consts.Ansi_Move_Cursor (X_Start + Cur_X, Y_Start);
            Put (Write_Buf);

            Write_Buf := To_Unbounded_String ("");

            Cur_Width := Width;
            if Cur_Width > Length (Cur_Str) then
               Cur_Width := Length (Cur_Str);
            end if;

            Write_Buf := Unbounded_Slice (Cur_Str, 1, Cur_Width);
            Put (Write_Buf);
            Cur_X := Cur_X + 1;

            Tempi := Length (Cur_Str);
            -- Put_Line
            --    ("DEBUG width '" & Width'Img & "' cur_str len '" &
            --     Tempi'Img);

            if Length (Cur_Str) > Width then
               Cur_Str :=
                 Unbounded_Slice (Cur_Str, Width + 1, Length (Cur_Str));

            else
               -- Put_Line ("DEBUG Cur_Str '" & Cur_Str & "'");
               -- return;
               Cur_Str := To_Unbounded_String ("");
            end if;
            -- Ada.Strings.Unbounded.Append (Write_Buf, "-");
         end loop;

         -- Put_Line ("DEBUG width '" & Width'Img & "' cur_width '" & Cur_Width'Img);

         -- Put_Line ("DEBUG Cur_X '" & Cur_X'Img & "' height '" & Height'Img);

         if Cur_X < Height and Erase_Trailing /= 0 then
            for I in Cur_Width .. Width - 1 loop
               Put (' ');
            end loop;
         end if;
         -- Put ('X');

         -- if wrapping the line caused us to exceed the box height, terminate the outer loop too
         if Cur_X > Height then
            -- Put_Line ("DEBUG ch exit " & Cur_X'Img & " H " & Height'Img);
            exit;
         end if;

      end loop;

      if Erase_Trailing /= 0 then
        for I in Cur_X .. Height - 1 loop
            Write_Buf := Consts.Ansi_Move_Cursor (X_Start + I, Y_Start);
            Put (Write_Buf);
            for J in 0 .. Width - 1 loop
              Put (' ');
            end loop;
        end loop;
      end if;


      null;
   end Draw_Text_In_Box;

   -- TODO abstract to arbitrary char/set?
   -- TODO move to string util package
   -- Returns a slice of Str after the nth newline, starting at 0.
   -- This can be used e.g. to scroll text in the buffer/window
   function Slice_Nth_Newline
     (Str : Unbounded_String; Nth : Integer) return Unbounded_String
   is
      Cur_Pos      : Integer;
      Newline_From : Integer;
      Newline_To   : Integer;
      Old_Newline_From : Integer;
      Old_Newline_To   : Integer;
   begin
      Cur_Pos      := 0;
      Newline_From := 0;
      Newline_To   := 0;
      Old_Newline_From := 1;
      Old_Newline_To   := 0;

      for N in 0 .. Nth - 1 loop
         Find_Token
           (Source => Str, Set => Ada.Strings.Maps.To_Set (Ascii.Lf),
            Test   => Inside, From => Old_Newline_From + 1,
            First  => Newline_From, Last => Newline_To);
         -- n.b. if no token was found, first is set to from and last is set to 0
         if Newline_From = Old_Newline_From + 1 and Newline_To = 0 then
            -- if there's no nth newline, no more string, return the empty string
            return To_Unbounded_String ("");
         end if;
         Old_Newline_From := Newline_From;
         Old_Newline_To   := Newline_To;
      end loop;
      return Unbounded_Slice (Str, Newline_From+1, Length (Str));
   end Slice_Nth_Newline;

end Window;
