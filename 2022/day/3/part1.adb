with Ada.Text_IO; use Ada.Text_IO;

procedure Day3 is
   F   : File_Type;
   Acc : Natural := 0;

   function Process_Rucksack (R : String) return Natural is
      Compartment1 : constant String := R (R'First .. R'Length / 2);
      Compartment2 : constant String := R (R'Length / 2 + 1 .. R'Last);

      Res : Natural := 0;
   begin
      for C1 of Compartment1 loop
         for C2 of Compartment2 loop
            if C1 = C2 then
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
         exit when Res /= 0;
      end loop;

      return Res;
   end Process_Rucksack;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         Acc := Acc + Process_Rucksack (Line);
      end;
   end loop;
   Close (F);
   Put_Line (Acc'Image);
end Day3;
