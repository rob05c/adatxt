package Consts is

   Ansi_Reset : constant String := ASCII.Esc & "[0m";
   Ansi_Red   : constant String := Ascii.Esc & "[31;1m";
   Ansi_Green : constant String := Ascii.Esc & "[32;1m";

end Consts;
