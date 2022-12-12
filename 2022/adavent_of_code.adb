with Ada.Command_Line; use Ada.Command_Line;

with AoC.Calorie_Counting;
with AoC.Monkey_In_The_Middle;
with AoC.Rock_Paper_Scissors;
with AoC.Ruckstack_Reorganization;
with AoC.Camp_Cleanup;

procedure Adavent_Of_Code is
begin
   if Argument_Count > 0 then
      AoC.Set_Input_Dir (Argument (1));
   end if;

   --  Day 1: Calorie Counting
   AoC.Calorie_Counting.Solve ("1");

   --  Day 2: Rock Paper Scissors
   Aoc.Rock_Paper_Scissors.Solve ("2");

   --  Day 3: Ruckstack Reorganization
   Aoc.Ruckstack_Reorganization.Solve ("3");

   --  Day 4: Camp Cleanup
   Aoc.Camp_Cleanup.Solve ("4");

   --  Day 11: Monkey in the Middle
   AoC.Monkey_In_The_Middle.Solve ("11");
end Adavent_Of_Code;
