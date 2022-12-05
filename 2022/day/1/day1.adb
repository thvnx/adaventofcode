with Ada.Text_IO; use Ada.Text_IO;

procedure Day1 is
   F : File_Type;
   Acc, Max : Natural := 0;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : String := Get_Line (F);
      begin
         if Line'Length /= 0 then
            Acc := Acc + Natural'Value(Line);
         else
            if Acc > Max then
               Max := Acc;
            end if;
            Acc := 0;
         end if;
      end;
   end loop;
   Close (F);
   Put_Line (Max'Image);
end Day1;
