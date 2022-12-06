with Ada.Text_IO; use Ada.Text_IO;

procedure Part2 is
   F   : File_Type;
   Acc : Natural := 0;

   function Process_Rucksack (A, B, C : String) return Natural is
      Res : Natural := 0;
   begin
      for C1 of A loop
         for C2 of B loop
            if C1 = C2 then
               for C3 of C loop
                  if C1 = C3 then
                     Res := Character'Pos(C1);
                     if Res > 96 then
                        -- lowercase
                        Res := Res - Character'Pos('a') + 1;
                     else
                        -- uppercase
                        Res := Res - Character'Pos('A') + 27;
                     end if;

                     --  Put_Line (C1 & " " & Res'Image);
                     exit when Res /= 0;
                  end if;
               end loop;
            end if;
            exit when Res /= 0;
         end loop;
         exit when Res /= 0;
      end loop;

      return Res;
   end Process_Rucksack;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line1 : constant String := Get_Line (F);
         Line2 : constant String := Get_Line (F);
         Line3 : constant String := Get_Line (F);
      begin
         Acc := Acc + Process_Rucksack (Line1, Line2, Line3);
      end;
   end loop;
   Close (F);
   Put_Line (Acc'Image);
end Part2;
