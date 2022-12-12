with Ada.Text_IO; use Ada.Text_IO;

package AoC is
   type Solver_Procedure is access procedure (Line : String);

   procedure Solve_Puzzle
     (Input  :          String;
      Solver : not null Solver_Procedure);

   procedure Set_Input_Dir (Input : String);

   function Is_Sample_Input return Boolean;

private
   type String_Access is access String;
   type Positive_Access is access Positive;
   type Natural_Access is access Natural;
   type Integer_Access is access Integer;
   type Boolean_Access is access Boolean;

   package Positive_IO is new Integer_IO (Positive);
   package Natural_IO is new Integer_IO (Natural);
   package LLI_IO is new Integer_IO (Long_Long_Integer);

   Input_Dir : String_Access := null;
end AoC;
