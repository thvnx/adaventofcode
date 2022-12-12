package body AoC.Camp_Cleanup is

   Acc : Natural := 0;
   Part_1 : Boolean := True;

   function Process_IDs (IDs : String) return Boolean is
      First, Last : Positive;
      Elf1Min, Elf1Max, Elf2Min, Elf2Max : Natural := 0;
   begin
      First := 1;
      Last := First;
      for C of IDs loop
         if C = '-' then
            if Elf1Min = 0 then
               Elf1Min := Natural'Value (IDs (First .. Last - 1));
            else
               Elf2Min := Natural'Value (IDs (First + 1 .. Last - 1));
            end if;
            First := Last;
         end if;

         if C = ',' then
            Elf1Max := Natural'Value (IDs (First + 1 .. Last - 1));
            First := Last;
         end if;

         Last := Last + 1;
      end loop;
      Elf2Max := Natural'Value (IDs (First + 1 .. IDs'Last));

      if Part_1 then
         return (Elf1Min <= Elf2Min and Elf1Max >= Elf2Max) or
                 (Elf2Min <= Elf1Min and Elf2Max >= Elf1Max);
      else
         return not (Elf1Max < Elf2Min or Elf2Max < Elf1Min);
      end if;
   end Process_IDs;

   procedure Process_Line (Line : String) is
   begin
      if Process_IDs (Line) then
         Acc := Acc + 1;
      end if;
   end Process_Line;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);
      Put_Line ("Day 4.1:" & Acc'Image);

      Part_1 := False;
      Acc := 0;
      Solve_Puzzle (Input, Process_Line'Access);
      Put_Line ("Day 4.2:" & Acc'Image);
   end Solve;

end AoC.Camp_Cleanup;
