with Ada.Text_IO; use Ada.Text_IO;

procedure Day2 is
   type Shifumi is (Rock, Paper, Scissors);
   for Shifumi use (Rock => 1, Paper => 2, Scissors => 3);

   type Score is (Lost, Draw, Won);
   for Score use (Lost => 0, Draw => 3, Won => 6);

   function PlayRound (Opponent, Me : Character) return Natural is
      OpPos : Natural := Character'Pos(Opponent) - Character'Pos('A');
      MePos : Natural := Character'Pos(Me) - Character'Pos('X');

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

   F   : File_Type;
   Acc : Natural := 0;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : String := Get_Line (F);
      begin
         Acc := Acc + PlayRound (Line (1), Line (3));
      end;
   end loop;
   Close (F);
   Put_Line (Acc'Image);
end Day2;
