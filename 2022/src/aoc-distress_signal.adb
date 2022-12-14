with Ada.Containers.Vectors;

package body AoC.Distress_Signal is

   type Packet;
   type Packet_Access is access all Packet;

   package Packet_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive,
      Element_Type => Packet_Access);

   type Packet_Kind is (Number, List);
   type Packet (Kind: Packet_Kind) is record
      case Kind is
         when Number => Value: Natural;
         when List   => Packet_List: Packet_Vectors.Vector;
      end case;
   end record;

   type Pair is record
      Left, Right : Packet_Access;
   end record;

   P : Pair := (null, null);

   Index : Positive;

   Index_Nb : Positive := 1;
   Index_Sum : Natural := 0;


   procedure Print_Packet (P : Packet_Access) is
   begin
      if P.Kind = Number then
         Put (P.Value'Image);
      else
         Put ("[");
         for I of P.Packet_List loop
            Print_Packet (I); Put(",");
         end loop;
         Put ("]");
      end if;
   end Print_Packet;

   function Build_List (Nested_List : String) return Packet_Access is
      V : constant Packet_Access := new Packet'(List, Packet_Vectors.Empty_Vector);
      Nat, Last : Natural;
   begin
      Index := Nested_List'First;
      loop
         exit when Index > Nested_List'Last;

         if Nested_List (Index) = '[' then
            V.Packet_List.Append (Build_List (Nested_List (Index + 1 .. Nested_List'Last)));
         elsif Nested_List (Index) = ']' then
            return V;
         elsif Nested_List (Index) = ',' then
            null;
         else
            Natural_IO.Get (Nested_List (Index .. Nested_List'Last), Nat, Last);
            V.Packet_List.Append (new Packet'(Number, Nat));
            if Nat > 9 then
               Index := Index + 1;
            end if;
         end if;

         Index := Index + 1;
      end loop;

      return V;
   end Build_List;

   function "<" (Left, Right : Packet_Access) return Boolean is
      Done : Boolean := False;

      function Compare (Left, Right : Packet_Access) return Boolean is
         B : Boolean := True;
      begin
         --Put ("Compare: "); Print_Packet (Left); Put (" and "); Print_Packet (Right); Put_Line ("");

         if Left.Kind /= Right.Kind then
            declare
               P : constant Packet_Access := new Packet'(List, Packet_Vectors.Empty_Vector);
            begin
               if Left.Kind = Number and then Right.Kind = List then
                  P.Packet_List.Append (Left);
                  B := Compare (P, Right);
               else
                  P.Packet_List.Append (Right);
                  B := Compare (Left, P);
               end if;
            end;
         else
            if Left.Kind = Number then
               --Put_Line ("- Compare" & Left.Value'Image & " vs" & Right.Value'Image);
               if Left.Value > Right.Value then
                  B := False;
                  Done := True;
               elsif Left.Value < Right.Value then
                  Done := True;
               end if;
            else
               for I in Left.Packet_List.First_Index .. Left.Packet_List.Last_Index loop
                  if not Done and then I > Right.Packet_List.Last_Index then
                     B := False;
                     Done := True;
                  else
                     if not Done then
                        B := Compare (Left.Packet_List.Element (I), Right.Packet_List.Element (I));
                     end if;
                  end if;
               end loop;
               if Right.Packet_List.Last_Index > Left.Packet_List.Last_Index then
                  Done := True;
               end if;
            end if;
         end if;
         return B;
      end Compare;
   begin
      return Compare (Left, Right);
   end "<";

   package Packet_Sorter is new Packet_Vectors.Generic_Sorting;

   function Analyse_Pair (Left, Right : Packet_Access) return Boolean is
   begin
      if Left < Right then
         --Put_Line ("Right Order");
         return True;
      else
         --Put_Line ("Not Right Order");
         return False;
      end if;
   end Analyse_Pair;

   Part_2 : Packet_Vectors.Vector;

   procedure Process_Line (Line : String) is
   begin
      --Put_Line (Line);

      if Line /= "" then
         if P.Left = null then
            P.Left := Build_List (Line);
            --Print_Packet (P.Left); Put_Line ("");
         else
            P.Right := Build_List (Line);
            --Print_Packet (P.Right); Put_Line ("");
            if Analyse_Pair (P.Left, P.Right) then
               Index_Sum := Index_Sum + Index_Nb;
            end if;
            Index_Nb := Index_Nb + 1;
         end if;
      else
         --Print_Packet (P.Left); Put_Line ("");

         Part_2.Append (P.Left);
         Part_2.Append (P.Right);
         P.Left := null;
         P.Right := null;
      end if;
   end Process_Line;

   pragma Unreferenced (Print_Packet);

   procedure Solve (Input : String) is
      Divider_1, Divider_2 : Packet_Access;
      D1, D2 : Natural;
   begin
      Solve_Puzzle (Input, Process_Line'Access);
               Part_2.Append (P.Left);
         Part_2.Append (P.Right);

      Put_Line ("Day 13.1:" & Index_Sum'Image);

      Divider_1 := Build_List ("[[2]]");
      Divider_2 := Build_List ("[[6]]");

      Part_2.Append (Divider_1);
      Part_2.Append (Divider_2);
      Packet_Sorter.Sort (Part_2);
      for I in Part_2.First_Index .. Part_2.Last_Index loop
         if Part_2 (I) = Divider_1 then
            D1 := I;
         elsif Part_2 (I) = Divider_2 then
            D2 := I;
         end if;
         --Print_Packet (Part_2 (I)); Put_Line ("");
      end loop;
      D1 := D1 * D2;
      Put_Line ("Day 13.2:" & D1'Image);
   end Solve;

end AoC.Distress_Signal;
