package body AoC.Rope_Bridge is

   Part_1 : Boolean := True;

   type Position;
   type Position_Access is access Position;

   type Position is record
      Visite_Count          : Natural_Access;
      Up, Down, Left, Right : Position_Access;
   end record;

   type Rope is array (1 .. 10) of Position_Access;
   R : Rope;

   Zero  : constant Natural_Access  := new Natural'(0);
   Start : constant Position_Access :=
      new Position'(Zero, null, null, null, null);

   procedure Increment_Visite_Count (Pos : Position_Access) is
   begin
      Pos.Visite_Count := new Natural'(Pos.Visite_Count.all + 1);
   end Increment_Visite_Count;


   procedure Adjust_Grid
     (Head : Position_Access; Direction : Character; Steps : Positive) is
      Temp : Position_Access := Head;
   begin
      case Direction is
      when 'U' =>
         if Temp.Up = null then
            while Temp.Left /= null loop
               Temp := Temp.Left;
            end loop;
            loop
               Temp.Up := new Position'(Zero,
                                        null,
                                        Temp,
                                        (if Temp.Left /= null then Temp.Left.Up else null),
                                        null);
               if Temp.Left /= null then
                  Temp.Left.Up.Right := Temp.Up;
               end if;
               Temp := Temp.Right;
               exit when Temp = null;
            end loop;
         end if;
         Temp := Head.Up;
      when 'D' =>
         if Temp.Down = null then
            while Temp.Left /= null loop
               Temp := Temp.Left;
            end loop;
            loop
               Temp.Down := new Position'(Zero,
                                          Temp,
                                          null,
                                          (if Temp.Left /= null then Temp.Left.Down else null),
                                          null);
               if Temp.Left /= null then
                  Temp.Left.Down.Right := Temp.Down;
               end if;
               Temp := Temp.Right;
               exit when Temp = null;
            end loop;
         end if;
         Temp := Head.Down;
      when 'L' =>
         if Temp.Left = null then
            while Temp.Up /= null loop
               Temp := Temp.Up;
            end loop;
            loop
               Temp.Left := new Position'(Zero,
                                          (if Temp.Up /= null then Temp.Up.Left else null),
                                          null,
                                          null,
                                          Temp);
               if Temp.Up /= null then
                  Temp.Up.Left.Down := Temp.Left;
               end if;
               Temp := Temp.Down;
               exit when Temp = null;
            end loop;
         end if;
         Temp := Head.Left;
      when 'R' =>
         if Temp.Right = null then
            while Temp.Up /= null loop
               Temp := Temp.Up;
            end loop;
            loop
               Temp.Right := new Position'(Zero,
                                           (if Temp.Up /= null then Temp.Up.Right else null),
                                           null,
                                           Temp,
                                           null);
               if Temp.Up /= null then
                  Temp.Up.Right.Down := Temp.Right;
               end if;
               Temp := Temp.Down;
               exit when Temp = null;
            end loop;
         end if;
         Temp := Head.Right;
      when others => raise Constraint_Error;
      end case;

      if Steps > 1 then
         Adjust_Grid (Temp, Direction, Steps - 1);
      end if;
   end Adjust_Grid;

   procedure Print_Grid (Start : Position_Access; R : Rope);

   procedure Move_Rope 
     (R : in out Rope;
      Direction : Character)
   is
      procedure Move_Tail (Head : Position_Access;
                           Tail : in out Position_Access) is
      begin
         if Head = Tail 
         or else (Head.Up /= null and then Tail = Head.Up)
         or else (Head.Down /= null and then Tail = Head.Down)
         or else (Head.Left /= null and then Tail = Head.Left)
         or else (Head.Right /= null and then Tail = Head.Right)
         or else (Head.Up /= null and then Head.Up.Left /= null and then Tail = Head.Up.Left)
         or else (Head.Left /= null and then Head.Left.Down /= null and then Tail = Head.Left.Down)
         or else (Head.Down /= null and then Head.Down.Right /= null and then Tail = Head.Down.Right)
         or else (Head.Right /= null and then Head.Right.Up /= null and then Tail = Head.Right.Up) then
            null;
         elsif Tail.Up /= null and then Tail.Up.Up /= null
            and then
              (Tail.Up.Up = Head
               or else (Tail.Up.Up.Left /= null and then Tail.Up.Up.Left = Head)
               or else (Tail.Up.Up.Right /= null and then Tail.Up.Up.Right = Head)) then
                  Tail := Head.Down;
         elsif Tail.Down /= null and then Tail.Down.Down /= null
            and then
              (Tail.Down.Down = Head
               or else (Tail.Down.Down.Left /= null and then Tail.Down.Down.Left = Head)
               or else (Tail.Down.Down.Right /= null and then Tail.Down.Down.Right = Head)) then
                  Tail := Head.Up;
         elsif Tail.Left /= null and then Tail.Left.Left /= null
            and then
              (Tail.Left.Left = Head
               or else (Tail.Left.Left.Up /= null and then Tail.Left.Left.Up = Head)
               or else (Tail.Left.Left.Down /= null and then Tail.Left.Left.Down = Head)) then
                  Tail := Head.Right;
         elsif Tail.Right /= null and then Tail.Right.Right /= null
            and then
              (Tail.Right.Right = Head
               or else (Tail.Right.Right.Up /= null and then Tail.Right.Right.Up = Head)
               or else (Tail.Right.Right.Down /= null and then Tail.Right.Right.Down = Head)) then
                  Tail := Head.Left;
         elsif       Head.Up /= null 
            and then Head.Up.Up /= null
            and then Head.Up.Up.Right /= null
            and then Head.Up.Up.Right.Right /= null
            and then Head.Up.Up.Right.Right = Tail then
               Tail := Head.Up.Right;
         elsif       Head.Right /= null 
            and then Head.Right.Right /= null
            and then Head.Right.Right.Down /= null
            and then Head.Right.Right.Down.Down /= null
            and then Head.Right.Right.Down.Down = Tail then
               Tail := Head.Right.Down;   
         elsif       Head.Down /= null 
            and then Head.Down.Down /= null
            and then Head.Down.Down.Left /= null
            and then Head.Down.Down.Left.Left /= null
            and then Head.Down.Down.Left.Left = Tail then
               Tail := Head.Down.Left;     
         elsif       Head.Left /= null
            and then Head.Left.Left /= null
            and then Head.Left.Left.Up /= null
            and then Head.Left.Left.Up.Up /= null
            and then Head.Left.Left.Up.Up = Tail then
               Tail := Head.Left.Up;
         else
            raise Constraint_Error;
         end if;
      end Move_Tail;

      Head, Tail, Temp : Position_Access;
   begin
      Head := R (1);
      --Temp := R (1);
      case Direction is
      when 'L' =>
         Head := Head.Left;
      when 'R' =>
         Head := Head.Right;
      when 'U' =>
         Head := Head.Up;
      when 'D' =>
         Head := Head.Down;
      when others => raise Constraint_Error;
      end case;

      R (1) := Head;
      --Print_Grid (Start, R);
      for I in 2 .. 10 loop
         Tail := R (I);
         Head := R (I - 1);
         Move_Tail (Head, Tail);
         --Temp := R (I);
         R (I) := Tail;
         --Print_Grid (Start, R);
      end loop;
      Increment_Visite_Count (R (if Part_1 then 2 else 10));
   end Move_Rope;

   procedure Process_Line
     (Line : String;
      R : in out Rope)
   is
      Direction   : constant Character := Line (Line'First);
      Steps, Last : Positive;
   begin
      Positive_IO.Get (Line (Line'First + 2 .. Line'Last), Steps, Last);
      --  Put_Line (Direction & Steps'Image);
      Adjust_Grid (R (1), Direction, Steps);
      loop
         Move_Rope (R, Direction);
         exit when Steps = 1;
         Steps := Steps - 1;
      end loop;
   end Process_Line;


   procedure Grid_Size (Start : Position_Access) is
      Lenght, Height : Natural := 1;
      Temp           : Position_Access := Start;
   begin
      while Temp.Right /= null loop
         Lenght := Lenght + 1;
         Temp := Temp.Right;
      end loop;
      while Temp.Up /= null loop
         Temp := Temp.Up;
      end loop;
      while Temp.Down /= null loop
         Height := Height + 1;
         Temp := Temp.Down;
      end loop;
      Put_Line (Lenght'Image & " * " & Height'Image);
   end Grid_Size;
   pragma Unreferenced (Grid_Size);


   procedure Print_Grid (Start : Position_Access; R : Rope) is
      Temp : Position_Access := Start;

      procedure Print_Position (P : Position_Access) is
         C : Character := '.';
      begin
         if P.Visite_Count.all > 0 then
            C := '#';
         end if;
         if P = Start then
            C := 's';
         elsif P = R (10)  then
            C := '9';
         elsif P = R (9)  then
            C := '8';
         elsif P = R (8)  then
            C := '7';
         elsif P = R (7)  then
            C := '6';
         elsif P = R (6)  then
            C := '5';
         elsif P = R (5)  then
            C := '4';
         elsif P = R (4)  then
            C := '3';
         elsif P = R (3)  then
            C := '2';
         elsif P = R (2)  then
            C := '1';
         elsif P = R (1) then
            C := 'H';
         end if;
         Put (C);
      end Print_Position;
   begin
      while Temp.Up /= null loop
         Temp := Temp.Up;
      end loop;
      while Temp.Left /= null loop
         Temp := Temp.Left;
      end loop;
      loop
         loop
            Print_Position (Temp);
            exit when Temp.Right = null;
            Temp := Temp.Right;
         end loop;
         Put_Line ("");

         while Temp.Left /= null loop
            Temp := Temp.Left;
         end loop;

         exit when Temp.Down = null;
         Temp := Temp.Down;
      end loop;
   end Print_Grid;
   pragma Unreferenced (Print_Grid);


   procedure Count_Visited_Places (Start : Position_Access) is
      Temp : Position_Access := Start;
      Acc : Natural := 0;
   begin
      while Temp.Up /= null loop
         Temp := Temp.Up;
      end loop;
      while Temp.Left /= null loop
         Temp := Temp.Left;
      end loop;
      loop
         loop
            if Temp.Visite_Count.all > 0 then
               Acc := Acc + 1;
            end if;
            exit when Temp.Right = null;
            Temp := Temp.Right;
         end loop;

         while Temp.Left /= null loop
            Temp := Temp.Left;
         end loop;

         exit when Temp.Down = null;
         Temp := Temp.Down;
      end loop;
      Put_Line ("Day 9" & (if Part_1 then ".1" else ".2") & ":" & Acc'Image);
   end Count_Visited_Places;


   procedure Process_Line (Line : String) is
   begin
      --  Grid_Size (Start);
      Process_Line (Line, R);
      -- Put_Line (R'Image);
   end Process_Line;

   procedure Solve (Input : String) is
   begin
      R := [Start, Start, Start, Start, Start, Start, Start, Start, Start, Start];
      Increment_Visite_Count (Start);
      Solve_Puzzle (Input & ".1", Process_Line'Access);
      --Print_Grid (Start, R);
      Count_Visited_Places (Start);

      Part_1 := False;
      Start.Up := null;
      Start.Down := null;
      Start.Left := null;
      Start.Right := null;

      -- TODO: do it in one pass!
      R := [Start, Start, Start, Start, Start, Start, Start, Start, Start, Start];
      Increment_Visite_Count (Start);
      Solve_Puzzle (Input & ".2", Process_Line'Access);
      --Print_Grid (Start, R);
      Count_Visited_Places (Start);
   end Solve;

end AoC.Rope_Bridge;
