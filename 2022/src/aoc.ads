package AoC is
   type Solver_Procedure is access procedure (Line : String);

   procedure Solve_Puzzle
     (Input  :          String;
      Solver : not null Solver_Procedure);

   procedure Set_Input_Dir (Input : String);

private
   type String_Access is access String;

   Input_Dir : String_Access := null;
end AoC;
