with Ada.Text_IO; use Ada.Text_IO;

procedure Part1 is
   type Natural_Access is access Natural;

   type Position;
   type Position_Access is access Position;

   type Position is record
      Visite_Count          : Natural_Access;
      Up, Down, Left, Right : Position_Access;
   end record;


   package Pos_IO is new Integer_IO (Positive); use Pos_IO;

   Zero  : constant Natural_Access  := new Natural'(0);
   Start : constant Position_Access :=
      new Position'(Zero, null, null, null, null);
   Head, Tail : Position_Access;

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


   procedure Move_Rope 
     (Head, Tail : in out Position_Access;
      Direction : Character)
   is
      procedure Move_Tail (Head, Tail : in out Position_Access; Direction : Character) is
      begin
         if Tail = Head then
            null;
         elsif Head.Up /= null and then Tail = Head.Up then
            if Direction = 'D' then
               Tail := Head;
            end if;
         elsif Head.Down /= null and then Tail = Head.Down then
            if Direction = 'U' then
               Tail := Head;
            end if;
         elsif Head.Left /= null and then Tail = Head.Left then
            if Direction = 'R' then
               Tail := Head;
            end if;
         elsif Head.Right /= null and then Tail = Head.Right then
            if Direction = 'L' then
               Tail := Head;
            end if;
         elsif Head.Left /= null and then Head.Left.Up /= null and then Tail = Head.Left.Up then
            case Direction is
            when 'R' | 'D' => Tail := Head;
            when others => null;
            end case;
         elsif Head.Left /= null and then Head.Left.Down /= null and then Tail = Head.Left.Down then
            case Direction is
            when 'R' | 'U' => Tail := Head;
            when others => null;
            end case;
         elsif Head.Right /= null and then Head.Right.Up /= null and then Tail = Head.Right.Up then
            case Direction is
            when 'L' | 'D' => Tail := Head;
            when others => null;
            end case;
         elsif Head.Right /= null and then Head.Right.Down /= null and then Tail = Head.Right.Down then
            case Direction is
            when 'L' | 'U' => Tail := Head;
            when others => null;
            end case;
         else
            raise Constraint_Error;
         end if;
      end Move_Tail;

   begin
      --  Put_Line ("Move " & Direction);
      Move_Tail (Head, Tail, Direction);
      Increment_Visite_Count (Tail);
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
   end Move_Rope;

   procedure Process_Line
     (Line : String;
      Head, Tail : in out Position_Access)
   is
      Direction   : constant Character := Line (Line'First);
      Steps, Last : Positive;
   begin
      Get (Line (Line'First + 2 .. Line'Last), Steps, Last);
      --  Put_Line (Direction & Steps'Image);
      Adjust_Grid (Head, Direction, Steps);
      loop
         Move_Rope (Head, Tail, Direction);
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


   procedure Print_Grid (Start, Head, Tail : Position_Access) is
      Temp : Position_Access := Start;

      procedure Print_Position (P : Position_Access) is
         C : Character := '.';
      begin
         if P.Visite_Count.all > 0 then
            C := '#';
         end if;
         if P = Start then
            C := 's';
         elsif P = Tail then
            C := 'T';
         elsif P = Head then
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
      Put_Line (Acc'Image);
   end Count_Visited_Places;


   F : File_Type;
begin
   Head := Start;
   Tail := Head;
   Increment_Visite_Count (Start);

   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         --  Grid_Size (Start);
         Process_Line (Line, Head, Tail);
         -- Print_Grid (Start, Head, Tail);
      end;
   end loop;
   Close (F);
   Print_Grid (Start, Head, Tail);
   Count_Visited_Places (Start);
end Part1;
