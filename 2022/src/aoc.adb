package body AoC is
   procedure Solve_Puzzle
     (Input  :          String;
      Solver : not null Solver_Procedure)
   is
      File : File_Type;
   begin
      Open (File, In_File,
            (if Input_Dir = null then "input/" & Input
                                 else Input_Dir.all & "/" & Input));
      while not End_Of_File (File) loop
         declare
            Line : constant String := Get_Line (File);
         begin
            Solver.all (Line);
         end;
      end loop;
      Close (File);
   end Solve_Puzzle;

   procedure Set_Input_Dir (Input : String) is
   begin
      Input_Dir := new String'(Input);
   end Set_Input_Dir;

   function Is_Sample_Input return Boolean is
   begin
      return Input_Dir = null or else Input_Dir.all = "input";
   end Is_Sample_Input;
end AoC;
