package body AoC.Template is

   procedure Process_Line (Line : String) is
   begin
      Put_Line (Line);
   end Process_Line;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);
   end Solve;

end AoC.Template;
