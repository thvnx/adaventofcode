package body AoC.Rock_Paper_Scissors is

   type Shifumi is (Rock, Paper, Scissors);
   for Shifumi use (Rock => 1, Paper => 2, Scissors => 3);

   type Score is (Lost, Draw, Won);
   for Score use (Lost => 0, Draw => 3, Won => 6);

   function PlayRound (Opponent, Me : Character) return Natural is
      OpPos : constant Natural := Character'Pos(Opponent) - Character'Pos('A');
      MePos : constant Natural := Character'Pos(Me) - Character'Pos('X');

      Result : Integer;
      Round : Score;
      Shi : Shifumi;
   begin
      Result := OpPos - MePos;
      Shi := Shifumi'Enum_Val (MePos+1);

      if Result = 0 then
         Round := Draw;
      elsif Result > 0 then
         Round := (if Result = 1 then Lost else Won);
      else
         Round := (if Result = -1 then Won else Lost);
      end if;

      Result := Score'Enum_Rep(Round) + Shifumi'Enum_Rep(Shi);

      --  Put_Line (Round'Image & " " & Shi'Image & " => " & Result'Image);

      return Result;
   end PlayRound;
   
   function PlayRound2 (Opponent, Me : Character) return Natural is
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
   end PlayRound2;

   Acc : Natural := 0;

   procedure Process_Line (Line : String) is
   begin
      --Put_Line (Line);
      Acc := Acc + PlayRound (Line (Line'First), Line (Line'First + 2));
   end Process_Line;

   procedure Process_Line2 (Line : String) is
   begin
      --Put_Line (Line);
      Acc := Acc + PlayRound2 (Line (Line'First), Line (Line'First + 2));
   end Process_Line2;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);
      Put_Line ("Day 2.1:" & Acc'Image);

      Acc := 0;
      Solve_Puzzle (Input, Process_Line2'Access);
      Put_Line ("Day 2.2:" & Acc'Image);
   end Solve;

end AoC.Rock_Paper_Scissors;
