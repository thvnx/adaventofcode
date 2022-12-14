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
      C, Done : Boolean := False;

      function Compare (Left, Right : Packet_Access) return Boolean is
         B : Boolean := True;
      begin
         --Put ("Compare: "); Print_Packet (Left); Put (" and "); Print_Packet (Right); Put_Line ("");

         if Left.Kind /= Right.Kind then
            declare
               P : Packet_Access := new Packet'(List, Packet_Vectors.Empty_Vector);
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
                  C := True;
                  Done := True;
               elsif Left.Value < Right.Value then
                  C := True;
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

         P.Left := null;
         P.Right := null;
      end if;
   end Process_Line;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);

      Put_Line ("Day 13.1:" & Index_Sum'Image);
   end Solve;

end AoC.Distress_Signal;
