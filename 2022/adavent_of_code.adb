with Ada.Command_Line; use Ada.Command_Line;

with AoC.Calorie_Counting;
with AoC.Rock_Paper_Scissors;
with AoC.Ruckstack_Reorganization;
with AoC.Camp_Cleanup;
with AoC.Supply_Stacks;
with AoC.Tuning_Trouble;
with Aoc.No_Space_Left_On_Device;
with AoC.Treetop_Tree_House;

with AoC.Cathode_Ray_Tube;
with AoC.Monkey_In_The_Middle;

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

   --  Day 5: Supply Stacks (warning: only works for my private input data
   --  since I hardcoded the stacks :/).
   AoC.Supply_Stacks.Solve ("5");

   --  Day 6: Tuning Trouble
   Aoc.Tuning_Trouble.Solve ("6");

   --  Day 7: No Space Left On Device
   AoC.No_Space_Left_On_Device.Solve ("7");

   --  Day 8: Treetop Tree House
   AoC.Treetop_Tree_House.Solve ("8");

   --  Day 10: Cathode-Ray Tube
   AoC.Cathode_Ray_Tube.Solve ("10");

   --  Day 11: Monkey in the Middle
   AoC.Monkey_In_The_Middle.Solve ("11");
end Adavent_Of_Code;
