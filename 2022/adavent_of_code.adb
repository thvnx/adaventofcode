with Ada.Command_Line; use Ada.Command_Line;

with AoC.Calorie_Counting;
with AoC.Monkey_In_The_Middle;

procedure Adavent_Of_Code is
begin
   if Argument_Count > 0 then
      AoC.Set_Input_Dir (Argument (1));
   end if;

   --  Day 1: Calorie Counting
   AoC.Calorie_Counting.Solve ("1");

   --  Day 11: Monkey in the Middle
   AoC.Monkey_In_The_Middle.Solve ("11");
end Adavent_Of_Code;
