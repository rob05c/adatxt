package body Term is

   -- Screen_Size returns X, Y, and any errno.
   function My_Screen_Size(SX : out Integer; SY : out Integer) return Integer
   is
      TIOCGWINSZ : unsigned_long := 16#5413#;

      type winsize is record
         ws_row  : unsigned_short;
         ws_col  : unsigned_short;
         unused1 : unsigned_short;
         unused2 : unsigned_short;
      end record;
      pragma Pack (winsize);

      function ioctl
        (Fildes : in int; Request : in unsigned_long; ws : in out winsize)
         return int;
      pragma Import (C, ioctl, "ioctl");

      -- Err_No : Integer;
      -- pragma Import (C, Err_No, "errno");

      ws     : winsize;
      result : int;
   begin
      result := ioctl (0, TIOCGWINSZ, ws);
      if result = 0 then
         SX := Integer(ws.Ws_Row);
         SY := Integer(Ws.Ws_Col);
         -- Put_Line
         --   ("Screen width: " & ws.ws_row'Img & " Screen height: " &
         --    ws.ws_col'Img);
         return 0;
      else
         -- TODO fix
         return -1;
         -- Put_Line ("Error getting terminal size");
         -- Put_Line ("Err_No: " & Err_No'Img);
      end if;
   end My_Screen_Size;

end Term;
