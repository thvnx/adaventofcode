with Ada.Text_IO; use Ada.Text_IO;

procedure Part1 is
   F : File_Type;
begin
   Open (F, In_File, "input");
   declare
      Line  : constant String := Get_Line (F);
      Found : Boolean := False;
   begin
      for Marker in 4 .. Line'Last loop
         --  brute force!
         if          Line (Marker - 3) /= Line (Marker - 2)
            and then Line (Marker - 3) /= Line (Marker - 1)
            and then Line (Marker - 3) /= Line (Marker)
            and then Line (Marker - 2) /= Line (Marker - 1)
            and then Line (Marker - 2) /= Line (Marker)
            and then Line (Marker - 1) /= Line (Marker) then
            Put_Line (Marker'Image);
            Found := True;
         end if;
         exit when Found;
      end loop;
   end;
   Close (F);
end Part1;
