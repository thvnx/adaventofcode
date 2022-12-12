package body AoC.Tuning_Trouble is

   function Check_Marker (M : String) return Boolean is
   begin
      if M = "" then
         return True;
      end if;

      for C of M (M'First + 1 .. M'Last) loop
         if M (M'First) = C then
            return False;
         end if;
      end loop;

      return Check_Marker (M (M'First + 1 .. M'Last));
   end Check_Marker;

   procedure Process_Line (Line : String) is
      Found_1, Found_2 : Boolean := False;
   begin
      for Marker in 14 .. Line'Last loop
         if not Found_1 and then Check_Marker (Line (Marker - 3 .. Marker)) then
            Put_Line ("Day 6.1:" & Marker'Image);
            Found_1 := True;
         end if;
         if Check_Marker (Line (Marker - 13 .. Marker)) then
            Put_Line ("Day 6.2:" & Marker'Image);
            Found_2 := True;
         end if;
         exit when Found_1 and then Found_2;
      end loop;
   end Process_Line;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);
   end Solve;

end AoC.Tuning_Trouble;
