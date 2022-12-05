with Ada.Text_IO; use Ada.Text_IO;

--  procedure Day1 is
--     F : File_Type;
--     Acc, Max : Natural := 0;
--  begin
--     Open (F, In_File, "input");
--     while not End_Of_File (F) loop
--        declare
--           Line : String := Get_Line (F);
--        begin
--           if Line'Length /= 0 then
--              Acc := Acc + Natural'Value(Line);
--           else
--              if Acc > Max then
--                 Max := Acc;
--              end if;
--              Acc := 0;
--           end if;
--        end;
--     end loop;
--     Close (F);
--     Put_Line (Max'Image);
--  end Day1;

procedure Day1 is
   type MaxArr is array (1 .. 3) of Natural;

   F   : File_Type;
   Acc : Natural := 0;
   Max : MaxArr := [0, 0, 0];

   procedure UpdateArray (Arr : in out MaxArr; N : Natural) is
      procedure Swap (Arr : in out MaxArr; I, J : Positive) is
         Tmp : Natural := Arr (I);
      begin
         Arr (I) := Arr (J);
         Arr (J) := Tmp;
      end Swap;
   begin
      if N > Arr (3) then
         Arr (3) := N;

         if Arr (3) > Arr (2) then
            Swap (Arr, 3, 2);
            if Arr (2) > Arr (1) then
               Swap (Arr, 2, 1);
            end if;
         end if;
      end if;
   end UpdateArray;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : String := Get_Line (F);
      begin
         if Line'Length /= 0 then
            Acc := Acc + Natural'Value(Line);
         else
            UpdateArray (Max, Acc);
            Acc := 0;
         end if;
      end;
   end loop;
   Close (F);
   Acc := Max (1) + Max (2) + Max (3);
   Put_Line (Acc'Image);
end Day1;
