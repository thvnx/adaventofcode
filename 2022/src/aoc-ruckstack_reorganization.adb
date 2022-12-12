package body AoC.Ruckstack_Reorganization is

   Acc : Natural := 0;
   Count : Positive := 1;
   Old, OldOld : String_Access;

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

   function Process_Rucksack_2 (A, B, C : String) return Natural is
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
   end Process_Rucksack_2;

   procedure Process_Line (Line : String) is
   begin
      Acc := Acc + Process_Rucksack (Line);
   end Process_Line;

   procedure Process_Line2 (Line : String) is
   begin
      if Count = 3 then
         Acc := Acc + Process_Rucksack_2 (Line, Old.all, OldOld.all);
         Count := 1;
      else
         Count := Count + 1;
      end if;
      OldOld := Old;
      Old := new String'(Line);   
   end Process_Line2;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);

      Put_Line ("Day 3.1:" & Acc'Image);

      Acc := 0;
      Solve_Puzzle (Input, Process_Line2'Access);
      Put_Line ("Day 3.2:" & Acc'Image);
   end Solve;

end AoC.Ruckstack_Reorganization;
