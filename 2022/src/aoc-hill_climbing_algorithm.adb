with Ada.Containers.Vectors;

package body AoC.Hill_Climbing_Algorithm is

   subtype Height_Type is Character range 'a' .. 'z';

   type Node;
   type Node_Access is access Node;

   type Node is record
      Height                : Height_Type;
      Up, Down, Left, Right : Node_Access;
      Pred                  : Node_Access;
      Distance              : Natural_Access;
      Dijkstraed            : Boolean_Access;
   end record;

   S, E, Temp : Node_Access;

   procedure Process_Line (Line : String) is
      Up, Left : Node_Access := null;

      function To_Height (C : Character) return Height_Type is
        (if C = 'S' then 'a' else (if C = 'E' then 'z' else C));
   begin
      Up   := Temp;
      Left := null;

      for C of Line loop
         Temp := new Node'(To_Height (C), Up, null, Left, null, null, null, new Boolean'(False));

         if Up /= null then
            Up.Down := Temp;
            Up      := Up.Right;
         end if;
         if Left /= null then
            Left.Right := Temp;
         end if;
         Left := Temp;

         case C is
         when 'S' =>
            S := Temp;
            S.Distance := new Natural'(0);
         when 'E' => E := Temp;
         when others => null;
         end case;
      end loop;

      while Temp.Left /= null loop
         Temp := Temp.Left;
      end loop;
   end Process_Line;

   procedure Print_Map (S : Node_Access) is
      Temp : Node_Access := S;
   begin
      while Temp.Left /= null loop
         Temp := Temp.Left;
      end loop;
      while Temp.Up /= null loop
         Temp := Temp.Up;
      end loop;

      loop
         loop
            Put (Temp.Height);
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
   end Print_Map;

   procedure Print_Map_Symbols (S : Node_Access) is
      Temp : Node_Access := S;
   begin
      while Temp.Left /= null loop
         Temp := Temp.Left;
      end loop;
      while Temp.Up /= null loop
         Temp := Temp.Up;
      end loop;

      loop
         loop
            if Temp.Pred /= null then
               if Temp.Pred = Temp.Up then
                  Put ("^");
               elsif Temp.Pred = Temp.Down then
                  Put ("v");
               elsif Temp.Pred = Temp.Left then
                  Put ("<");
               elsif Temp.Pred = Temp.Right then
                  Put (">");
               else
                  raise Constraint_Error;
               end if;
            else
               Put (".");
            end if;
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
   end Print_Map_Symbols;

   --  function Map_Size (S : Node_Access) return Positive is
   --     Temp : Node_Access := S;
   --     L, H : Natural := 0;
   --  begin
   --     while Temp.Left /= null loop
   --        Temp := Temp.Left;
   --     end loop;
   --     while Temp.Up /= null loop
   --        Temp := Temp.Up;
   --     end loop;

   --     while Temp.Right /= null loop
   --        Temp := Temp.Right;
   --        L := L + 1;
   --     end loop;
   --     while Temp.Down /= null loop
   --        Temp := Temp.Down;
   --        H := H + 1;
   --     end loop;

   --     return L * H;
   --  end Map_Size;

   procedure Dijkstra (S : Node_Access) is
      package Node_Vectors is new Ada.Containers.Vectors
        (Index_Type   => Positive,
         Element_Type => Node_Access);

      function "<" (Left, Right : Node_Access) return Boolean is
      begin
         if Left.Distance = null or else Right.Distance = null then
            if Left.Distance = null then
               return False;
            else
               return True;
            end if;
         else
            return Left.Distance.all < Right.Distance.all;
         end if;
      end "<";

      package Node_Sorter is new Node_Vectors.Generic_Sorting;

      procedure Map_To_Vector (S : Node_Access; V : in out Node_Vectors.Vector) is
         Temp : Node_Access := S;
      begin
         while Temp.Left /= null loop
            Temp := Temp.Left;
         end loop;
         while Temp.Up /= null loop
            Temp := Temp.Up;
         end loop;

         loop
            loop
               V.Append (Temp);
               exit when Temp.Right = null;
               Temp := Temp.Right;
            end loop;
            while Temp.Left /= null loop
               Temp := Temp.Left;
            end loop;
            exit when Temp.Down = null;
            Temp := Temp.Down;
         end loop;
      end Map_To_Vector;

      procedure Update_Distance (N, M : Node_Access) is
      begin
         if M /= null and then M.Dijkstraed.all /= True then
            declare
               Weight : constant Integer := Height_Type'Pos(M.Height) - Height_Type'Pos(N.Height) + 1;
            begin
               if Weight <= 2 then
                  if M.Distance = null or else
                    (M.Distance /= null and then M.Distance.all > N.Distance.all + Weight) then
                        M.Distance := new Natural'(N.Distance.all + Weight);
                        M.Pred := N;
                  end if;
               end if;
            end;
         end if;
      end Update_Distance;

      Q : Node_Vectors.Vector;
      N : Node_Access;
   begin
      Map_To_Vector (S, Q);
      
      loop
         Node_Sorter.Sort (Q);
         N := Q.First_Element;

         exit when N.Distance = null;

         Update_Distance (N, N.Right);
         Update_Distance (N, N.Left);
         Update_Distance (N, N.Up);
         Update_Distance (N, N.Down);

         N.Dijkstraed := new Boolean'(True);

         Q.Delete_First;
         exit when Q.Is_Empty;
      end loop;
   end Dijkstra;

   function Compute_Steps (S, E : Node_Access) return Natural is
      N : Node_Access := E;
      Steps : Natural := 0;
   begin
      while N /= S loop
         if N.Pred = null then
            return 0;
         end if;
         N := N.Pred;
         Steps := Steps + 1;
      end loop;
      return Steps;
   end Compute_Steps;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);
      --Print_Map (S);
      Dijkstra (S);
      Put_Line ("Day 12.1:" & Compute_Steps (S, E)'Image);
      --Print_Map_Symbols (S);
   end Solve;

end AoC.Hill_Climbing_Algorithm;
