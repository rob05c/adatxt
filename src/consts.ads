with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Consts is

   Ansi_Reset : constant String := ASCII.ESC & "[0m";
   Ansi_Red   : constant String := ASCII.ESC & "[31;1m";
   Ansi_Green : constant String := ASCII.ESC & "[32;1m";

   -- the smcup code puts the term in the 2nd buffer for TUI apps
   Ansi_Altbuf_Enable  : constant String := ASCII.ESC & "[?1049h";
   Ansi_Altbuf_Disable : constant String := ASCII.ESC & "[?1049l";
   Ansi_Screen_Erase   : constant String := ASCII.ESC & "[2J";

   Ansi_Cursor_Show : constant String := ASCII.ESC & "[?25h";
   Ansi_Cursor_Hide : constant String := ASCII.ESC & "[?25l";

   function Ansi_Move_Cursor
     (X : in Integer; Y : in Integer) return Unbounded_String;

end Consts;
