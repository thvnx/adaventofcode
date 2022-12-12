package body AoC.Cathode_Ray_Tube is

   Signal_Strengh : Natural := 0;
   X              : Integer := 1;
   Cycle          : Natural := 1;
   Signal_Cycle   : Natural := 20;
   CRT_Pos        : Natural := 1;

   procedure Process_Line (Line : String) is
      procedure Draw_Pixel is
      begin
         Put((if CRT_Pos in X .. X + 2 then "#" else "."));
         if CRT_Pos mod 40 = 0 then
            Put_Line ("");
            CRT_Pos := 0;
         end if;
         CRT_Pos := CRT_Pos + 1;
      end Draw_Pixel;
   begin
      if Line (Line'First .. 4) = "noop" then
            if Cycle + 1 > Signal_Cycle then
               Signal_Strengh := Signal_Strengh + (Signal_Cycle * X);
               Signal_Cycle := Signal_Cycle + 40;
            end if;
            Draw_Pixel;
            Cycle := Cycle + 1;
         elsif Line (Line'First .. 4) = "addx" then
            if Cycle + 2 > Signal_Cycle then
               Signal_Strengh := Signal_Strengh + (Signal_Cycle * X);
               Signal_Cycle := Signal_Cycle + 40;
            end if;
            Draw_Pixel;
            Draw_Pixel;
            Cycle := Cycle + 2;
            X := X + Integer'Value (Line (6 .. Line'Last));
         else
            raise Constraint_Error;
      end if;
   end Process_Line;

   procedure Solve (Input : String) is
   begin
      Put_Line ("Day 10.2:");
      Solve_Puzzle (Input, Process_Line'Access);

      Put_Line ("Day 10.1:" & Natural'Image(Signal_Strengh));
   end Solve;

end AoC.Cathode_Ray_Tube;
