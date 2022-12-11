with Ada.Text_IO; use Ada.Text_IO;

package body AoC.Calorie_Counting is
   Acc : Natural := 0;

   type MaxArr is array (1 .. 3) of Natural;
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

   procedure Process_Line (Line : String) is
   begin
      --  Put_Line (Line);

      if Line'Length /= 0 then
         Acc := Acc + Natural'Value(Line);
      else
         UpdateArray (Max, Acc);
         Acc := 0;
      end if;

   end Process_Line;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);
      --  Run Process_Line one last time to update the array with the last item
      Process_Line ("");

      Acc := Max (1) + Max (2) + Max (3);

      Put_Line ("Day 1.1:" & Max (1)'Image);
      Put_Line ("Day 1.2:" & Acc'Image);
   end Solve;

end AoC.Calorie_Counting;
