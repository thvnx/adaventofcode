with Ada.Text_IO; use Ada.Text_IO;

procedure Part2 is
   F   : File_Type;
   Acc : Natural := 0;

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

      return not (Elf1Max < Elf2Min or Elf2Max < Elf1Min);
   end Process_IDs;

begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         if Process_IDs (Line) then
            Acc := Acc + 1;
         end if;
      end;
   end loop;
   Close (F);
   Put_Line (Acc'Image);
end Part2;
