with Ada.Command_Line; use Ada.Command_Line;

with AoC.Calorie_Counting;

procedure Adavent_Of_Code is
begin
   if Argument_Count > 0 then
      AoC.Set_Input_Dir (Argument (1));
   end if;

   --  Day 1: Calorie Counting
   AoC.Calorie_Counting.Solve ("1");
end Adavent_Of_Code;
