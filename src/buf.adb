package body Buf is

   function Add_At_Cursor
     (B : in out Buffer; S : Unbounded_String) return Integer
   is
   begin
      -- the current cursor position is right before the first character in array B
      Append (B.A, S);
      return 0;
   end Add_At_Cursor;

   -- Deletes the text at the cursor.
   -- To delete arbitrary text in the Buf, move the cursor to the start first, then delete.
   -- Returns 0 on success, or an error code.
   -- Error codes:
   --   -1 input larger than text after the cursor
   --   -2 input negative
   function Del_At_Cursor (B : in out Buffer; I : Integer) return Integer is
   begin
      if I < 0 then
         return -2; -- TODO error code consts
      elsif I > Length (B.B) then
         return -1; -- TODO error code consts
      end if;
      Delete (B.B, 1, I);
      return 0;
   end Del_At_Cursor;

   -- Move the cursor forward or backward I characters.
   -- Returns 0 on success, or an error code
   -- Error codes:
   --   -1 I greater than text after B.B
   --   -2 I less than text before B.A
   function Move_Cursor (B : in out Buffer; I : Integer) return Integer is
      NI   : Integer;
      Temp : Unbounded_String;
   begin
      if I = 0 then
         return 0;
      elsif I > 0 then
         if I > Length (B.B) then
            return -1;
         end if;
         -- TODO make this efficient, by using a buffer with a different capacity vs length, avoid new allocation if within capacity, etc)
         Append (B.A, Slice (B.B, 1, I));
         Delete (B.B, 1, I);
         return 0;
      else -- I < 0
         NI := I * (-1) - 1;
         if NI > Length (B.A) then
            return -2;
         end if;
         -- TODO make this efficient (use a buffer with a different length and usage, shift instead of re-allocating, etc0
         Temp := Unbounded_Slice (B.A, Length (B.A) - NI, Length (B.A));
         Append (Temp, B.B);
         B.B := Temp;
         Delete (B.A, Length (B.A) - NI, Length (B.A));
         return 0;
      end if;
   end Move_Cursor;

   -- Returns the character in Buf between the indexes PStart and PEnd
   function Print
     (B     : in out Buffer; PStart : Integer; Pend : Integer;
      ECode :    out Integer) return Unbounded_String
   is
   begin
      ECode := 0;
      return B.A & B.B;
      -- -- TODO implement

      -- return To_Unbounded_String ("");
   end Print;

   function Cursor_Pos (B : Buffer) return Integer is
   begin
      return Length(B.A);
   end Cursor_Pos;

   function Buffer_Len(B : Buffer) return Integer
   is
   begin
      return Length(B.A) + Length(B.B);
   end Buffer_Len;

end Buf;
