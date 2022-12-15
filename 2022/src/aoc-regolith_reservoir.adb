package body AoC.Regolith_Reservoir is

   Part_1 : Boolean := True;

   type Cave;

   type Cave_Point is (Air, Sand, Rock);
   type Cave_Point_Access is access Cave_Point;

   type Cave_Access is access Cave;

   type Cave is record
      X, Y : Natural;
      Kind : Cave_Point_Access;
      Up, Down, Left, Right : Cave_Access;
   end record;

   Sand_Source : Cave_Access := new Cave'(500, 0, null, null, null, null, null);
   X_Min : Natural := Sand_Source.X;
   X_Max : Natural := X_Min;
   Y_Max : Natural := Sand_Source.Y;

   procedure Print_Cave is
      Cursor : Cave_Access := Sand_Source;
   begin
      while Cursor.Left /= null loop
         Cursor := Cursor.Left;
      end loop;

      loop
         loop
            if Cursor.Kind /= null then
               case Cursor.Kind.all is
               when Air    => Put (".");
               when Sand   => Put ("o");
               when Rock   => Put ("#");
               end case;
            else
               Put ("+");
            end if;
            exit when Cursor.Right = null;
            Cursor := Cursor.Right;
         end loop;
         Put_Line ("");

         while Cursor.Left /= null loop
            Cursor := Cursor.Left;
         end loop;

         exit when Cursor.Down = null;
         Cursor := Cursor.Down;
      end loop;
      Put_Line ("");
   end Print_Cave;

   procedure Adjust_Cave (X1, Y1, X2, Y2 : Natural) is
      X_Min : constant Natural := (if X1 < X2 then X1 else X2);
      X_Max : constant Natural := (if X1 > X2 then X1 else X2);
      Y_Max : constant Natural := (if Y1 > Y2 then Y1 else Y2);

      Cursor : Cave_Access;
   begin
      while X_Min < Regolith_Reservoir.X_Min loop
         Cursor := Sand_Source;
         while Cursor.Left /= null loop
            Cursor := Cursor.Left;
         end loop;

         loop
            Cursor.Left := new Cave'(Regolith_Reservoir.X_Min - 1, Cursor.Y, new Cave_Point'(Air), (if Cursor.Up /= null then Cursor.Up.Left else null), null, null, Cursor);
            if Cursor.Left.Up /= null then
               Cursor.Left.Up.Down := Cursor.Left;
            end if;
            exit when Cursor.Down = null;
            Cursor := Cursor.Down;
         end loop;

         Regolith_Reservoir.X_Min := Regolith_Reservoir.X_Min - 1;
      end loop;

      while X_Max > Regolith_Reservoir.X_Max loop
         Cursor := Sand_Source;
         while Cursor.Right /= null loop
            Cursor := Cursor.Right;
         end loop;

         loop
            Cursor.Right := new Cave'(Regolith_Reservoir.X_Max + 1, Cursor.Y, new Cave_Point'(Air), (if Cursor.Up /= null then Cursor.Up.Right else null), null, Cursor, null);
            if Cursor.Right.Up /= null then
               Cursor.Right.Up.Down := Cursor.Right;
            end if;
            exit when Cursor.Down = null;
            Cursor := Cursor.Down;
         end loop;

         Regolith_Reservoir.X_Max := Regolith_Reservoir.X_Max + 1;
      end loop;

      while Y_Max > Regolith_Reservoir.Y_Max loop
         Cursor := Sand_Source;
         while Cursor.Down /= null loop
            Cursor := Cursor.Down;
         end loop;
         while Cursor.Left /= null loop
            Cursor := Cursor.Left;
         end loop;

         loop
            Cursor.Down := new Cave'(Cursor.X, Regolith_Reservoir.Y_Max + 1, new Cave_Point'(Air), Cursor, null, (if Cursor.Left /= null then Cursor.Left.Down else null), null);
            if Cursor.Down.Left /= null then
               Cursor.Down.Left.Right := Cursor.Down;
            end if;
            exit when Cursor.Right = null;
            Cursor := Cursor.Right;
         end loop;

         Regolith_Reservoir.Y_Max := Regolith_Reservoir.Y_Max + 1;
      end loop;
   end Adjust_Cave;

   procedure Draw_Line (X1, Y1, X2, Y2 : Natural) is
      Cursor : Cave_Access := Sand_Source;
      Rocky : constant Cave_Point_Access := new Cave_Point'(Rock);
   begin
      while Cursor.X /= X1 loop
         if Cursor.X > X1 then
            Cursor := Cursor.Left;
         else
            Cursor := Cursor.Right;
         end if;
      end loop;

      while Cursor.Y /= Y1 loop
         Cursor := Cursor.Down;
      end loop;

      Cursor.Kind := Rocky;
      while Cursor.X /= X2 loop
         if Cursor.X > X2 then
            Cursor := Cursor.Left;
            Cursor.Kind := Rocky;
         else
            Cursor := Cursor.Right;
            Cursor.Kind := Rocky;
         end if;
      end loop;

      while Cursor.Y /= Y2 loop
         if Cursor.Y > Y2 then
            Cursor := Cursor.Up;
            Cursor.Kind := Rocky;
         else
            Cursor := Cursor.Down;
            Cursor.Kind := Rocky;
         end if;
      end loop;
   end Draw_Line;

   procedure Add_Rock_Line (X1, Y1, X2, Y2 : Natural) is
   begin
      Adjust_Cave (X1, Y1, X2, Y2);
      Draw_Line (X1, Y1, X2, Y2);
   end Add_Rock_Line;

   function Add_One_Sand_Unit return Boolean is
      Cursor, T : Cave_Access := Sand_Source;

      function One_Step (CA : Cave_Access) return Cave_Access is
      begin
         if Part_1 then
         if CA.Down = null then
            return null;
         else
            if CA.Down.Kind.all = Air then
               return CA.Down;
            else
               if CA.Left = null or else CA.Left.Down = null then
                  return null;
               else
                  if CA.Left.Down.Kind.all = Air then
                     return CA.Left.Down;
                  else
                     if CA.Right = null or else CA.Right.Down = null then
                        return null;
                     else
                        if CA.Right.Down.Kind.all = Air then
                           return CA.Right.Down;
                        else
                           return CA;
                        end if;
                     end if;
                  end if;
               end if;
            end if;
         end if;
         else
            if CA.Down.Kind.all = Air then
               return CA.Down;
            else
               if CA.Left = null then
                  Add_Rock_Line (X_Min - 1, Y_Max, X_Min, Y_Max);
               end if;
               if CA.Left.Down.Kind.all = Air then
                  return CA.Left.Down;
               else
                  if CA.Right = null then
                     Add_Rock_Line (X_Max, Y_Max, X_Max + 1, Y_Max);
                  end if;
                  if CA.Right.Down.Kind.all = Air then
                     return CA.Right.Down;
                  else
                     return CA;
                  end if;
               end if;
            end if;
         end if;
      end One_Step;
   begin
      loop
         T := One_Step (Cursor);
         exit when T = null or else T = Cursor; 
         Cursor := T;
      end loop;

      if (if Part_1 then T = null else T = Sand_Source) then
         return False;
      else
         Cursor.Kind := new Cave_Point'(Sand);
         return True;
      end if;
   end Add_One_Sand_Unit;

   X, Y, Z, T : Natural;
   procedure Process_Line (Line : String) is
      Coor, Last, C : Natural;
   begin
      --Put_Line (Line);

      C := Line'First;
      loop
         if Line (C) = ',' then
            X := Coor;
         elsif Line (C) = '>' then
            Y := Coor;
            

            if Z /= 0 and then T /= 0 then
            --Put_Line (Z'Image & T'Image & X'Image & Y'Image);
               Add_Rock_Line (Z, T, X, Y);
            end if;

            Z := X;
            T := Y;

         elsif Line (C) = '-' or else Line (C) = ' ' then
            null;
         else
            Natural_IO.Get (Line (C .. Line'Last), Coor, Last);
            C := Last;
         end if;

         exit when C = Line'Last;
         C := C + 1;
      end loop;
      Add_Rock_Line (Z, T, X, Coor);
      --Put_Line (Z'Image & T'Image & X'Image & Coor'Image);

      Z := 0;
      T := 0;
      
   end Process_Line;

   procedure Solve (Input : String) is
      I : Natural := 0;
   begin
      Solve_Puzzle (Input, Process_Line'Access);

      while Add_One_Sand_Unit loop
         I := I + 1;
      end loop;

      --Print_Cave;
      Put_Line ("Day 14.1:" & I'Image);

      Add_Rock_Line (X_Min, Y_Max + 2, X_Max, Y_Max + 2);
      Part_1 := False;
      while Add_One_Sand_Unit loop
         I := I + 1;
      end loop;
      I := I + 1;
      --Print_Cave;
      Put_Line ("Day 14.2:" & I'Image);
   end Solve;

end AoC.Regolith_Reservoir;
