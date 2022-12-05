with Ada.Text_IO; use Ada.Text_IO;

procedure Day2 is
   type Shifumi is (Rock, Paper, Scissors);
   for Shifumi use (Rock => 1, Paper => 2, Scissors => 3);

   type Score is (Lost, Draw, Won);
   for Score use (Lost => 0, Draw => 3, Won => 6);

   function PlayRound (Opponent, Me : Character) return Natural is
      OpPos : constant Natural := Character'Pos(Opponent) - Character'Pos('A') + 1;

      Result : Integer;
      Round : Score;
      Shi : Shifumi;
   begin

      case Me is
         --  lose
         when 'X' =>
            Round := Lost;
            Shi := Shifumi'Enum_Val ((if OpPos - 1 = 0 then 3 else OpPos - 1));
         --  draw
         when 'Y' =>
            Round := Draw;
            Shi := Shifumi'Enum_Val (OpPos);
         --  win
         when 'Z' =>
            Round := Won;
            Shi := Shifumi'Enum_Val ((if OpPos + 1 = 4 then 1 else OpPos + 1));
         when others => raise Constraint_Error;
      end case;

      Result := Score'Enum_Rep(Round) + Shifumi'Enum_Rep(Shi);

      --  Put_Line (Round'Image & " " & Shi'Image & " => " & Result'Image);

      return Result;
   end PlayRound;

   F   : File_Type;
   Acc : Natural := 0;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         Acc := Acc + PlayRound (Line (1), Line (3));
      end;
   end loop;
   Close (F);
   Put_Line (Acc'Image);
end Day2;
