with Ada.Text_IO; use Ada.Text_IO;

procedure Part1 is
   F              : File_Type;
   Signal_Strengh : Natural := 0;
   X              : Integer := 1;
   Cycle          : Natural := 1;
   Signal_Cycle   : Natural := 20;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         if Line (Line'First .. 4) = "noop" then
            if Cycle + 1 > Signal_Cycle then
               Signal_Strengh := Signal_Strengh + (Signal_Cycle * X);
               Signal_Cycle := Signal_Cycle + 40;
            end if;
            Cycle := Cycle + 1;
         elsif Line (Line'First .. 4) = "addx" then
            if Cycle + 2 > Signal_Cycle then
               Signal_Strengh := Signal_Strengh + (Signal_Cycle * X);
               Signal_Cycle := Signal_Cycle + 40;
            end if;
            Cycle := Cycle + 2;
            X := X + Integer'Value (Line (6 .. Line'Last));
         else
            raise Constraint_Error;
         end if;
      end;
   end loop;
   Close (F);

   Put_Line (Natural'Image(Signal_Strengh));
end Part1;
