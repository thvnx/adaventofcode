with Ada.Text_IO; use Ada.Text_IO;

procedure Part2 is
   F : File_Type;

   function Check_Marker (M : String) return Boolean is
   begin
      if M = "" then
         return True;
      end if;

      for C of M (M'First + 1 .. M'Last) loop
         if M (M'First) = C then
            return False;
         end if;
      end loop;

      return Check_Marker (M (M'First + 1 .. M'Last));
   end Check_Marker;

begin
   Open (F, In_File, "input");
   declare
      Line  : constant String := Get_Line (F);
      Found : Boolean := False;
   begin
      for Marker in 14 .. Line'Last loop
         if Check_Marker (Line (Marker - 13 .. Marker)) then
            Put_Line (Marker'Image);
            Found := True;
         end if;
         exit when Found;
      end loop;
   end;
   Close (F);
end Part2;
