with Ada.Containers.Vectors;

package body AoC.Monkey_In_The_Middle is

   Part_1 : Boolean := True;

   package Item_Vectors is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Long_Long_Integer);

   type Monkey;
   type Monkey_Access is access Monkey;

   type Monkey is record
      Identifier      : Natural;
      Items           : Item_Vectors.Vector;
      Inspected_Items : Positive_Access;
      Operation       : String_Access;
      Divisible_By    : Positive_Access;
      True, False     : Natural_Access;
   end record;

   package Monkey_Vectors is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Monkey_Access);

   function "<" (Left, Right : Monkey_Access) return Boolean is
   begin
      return Left.Inspected_Items.all > Right.Inspected_Items.all;
   end "<";

   package Monkey_Sorter is new Monkey_Vectors.Generic_Sorting;

   use Monkey_Vectors;

   Monkeys : Monkey_Vectors.Vector;

   function Moduli_Product return Long_Long_Integer is
      Acc : Long_Long_Integer := 1;
   begin
      for M of Monkeys loop
         Acc := Acc * Long_Long_Integer(M.Divisible_By.all);
      end loop;
      return Acc;
   end Moduli_Product;

   procedure Run_Round is
      Item : Long_Long_Integer;
      Monkey_ID : Natural;

      function Worry_Level (Operation : String) return Long_Long_Integer is
         Op  : constant Character := Operation (Operation'First + 10);
         RHS : Long_Long_Integer; 
         Last : Positive;
      begin
         if (Operation (Operation'First + 12 .. Operation'Last) /= "old") then
            LLI_IO.Get (Operation (Operation'First + 12 .. Operation'Last), RHS, Last);
         else
            RHS := Item;
         end if;
         --Put ("Worry level is " & Op & "by" & RHS'Image & "to ");
         if Part_1 then
            case Op is
            when '+' => return (Item + RHS) / Long_Long_Integer (3);
            when '*' => return (Item * RHS) / Long_Long_Integer (3);
            when others => raise Constraint_Error;
            end case;
         else
            case Op is --(cheated for that!)
            when '+' => return (Item + RHS) rem Moduli_Product;
            when '*' => return (Item * RHS) rem Moduli_Product;
            when others => raise Constraint_Error;
            end case;
         end if;
      end Worry_Level;

   begin
      for M of Monkeys loop
         --Put_Line ("Monkey: " & M.Identifier'Image);
         for I of M.Items loop
            M.Inspected_Items := new Positive'(if M.Inspected_Items /= null then M.Inspected_Items.all + 1 else 1);
            Item := I;
            Item := Worry_Level (M.Operation.all);
            --Put (Item'Image);

            --Item := Item / 3;
            --Put_Line (" divided by 3:" & Item'Image);
            if Item mod Long_Long_Integer (M.Divisible_By.all) = 0 then
               Monkey_ID := M.True.all;
            else
               Monkey_ID := M.False.all;
            end if;

            Monkeys (Monkey_ID).Items.Append (Item);

         end loop;
         M.Items := Item_Vectors.Empty_Vector;
      end loop;
   end Run_Round;

   procedure Process_Line (Line : String) is
      Nat : Long_Long_Integer;
      NNat, Last : Natural;
      Pos : Positive;
   begin
      --Put_Line (Line);
      if Line = "" then
         null;
      elsif Line (Line'First .. Line'First + 5) = "Monkey" then
         Monkeys.Append
           (new Monkey'(Identifier      => Natural'Value(Line (Line'First + 7 .. Line'First + 7)),
                        Items           => Item_Vectors.Empty_Vector,
                        Inspected_Items => null,
                        Operation       => null,
                        Divisible_By    => null,
                        True | False    => null));
      elsif Line (Line'First .. Line'First + 16) = "  Starting items:" then
         Last := 18;
         loop
            LLI_IO.Get (Line (Line'First + Last .. Line'Last), Nat, Last);
            Monkeys.Last_Element.Items.Append (Nat);
            exit when Last = Line'Last;
            Last := Last + 1;
         end loop;
      elsif Line (Line'First .. Line'First + 11) = "  Operation:" then
         Monkeys.Last_Element.Operation := new String'(Line (Line'First + 13 .. Line'Last));
      elsif Line (Line'First .. Line'First + 6) = "  Test:" then
         Natural_IO.Get (Line (Line'First + 21 .. Line'Last), Pos, Last);
         Monkeys.Last_Element.Divisible_By := new Positive'(Pos);
      elsif Line (Line'First .. Line'First + 11) = "    If true:" then
         Natural_IO.Get (Line (Line'First + 28 .. Line'Last), NNat, Last);
         Monkeys.Last_Element.True := new Natural'(NNat);
      elsif Line (Line'First .. Line'First + 12) = "    If false:" then
         Natural_IO.Get (Line (Line'First + 29 .. Line'Last), NNat, Last);
         Monkeys.Last_Element.False := new Natural'(NNat);
      end if;
   end Process_Line;

   procedure Solve (Input : String) is
      Res : Long_Long_Integer;
   begin
      Solve_Puzzle (Input, Process_Line'Access);
      for I in 1 .. 20 loop
         Run_Round;
      end loop;

      Monkey_Sorter.Sort (Monkeys);
      Res := Long_Long_Integer(Monkeys (0).Inspected_Items.all) * Long_Long_Integer(Monkeys (1).Inspected_Items.all);

      Put_Line ("Day 11.1:" & Res'Image);

      Part_1 := False;
      Monkeys := Monkey_Vectors.Empty_Vector;

      Solve_Puzzle (Input, Process_Line'Access);
      for I in 1 .. 10000 loop
         Run_Round;
      end loop;

      --  for M of Monkeys loop
      --     Put_Line (M.Identifier'Image & M.Inspected_Items.all'Image);
      --  end loop;

      Monkey_Sorter.Sort (Monkeys);
      Res := Long_Long_Integer(Monkeys (0).Inspected_Items.all) * Long_Long_Integer(Monkeys (1).Inspected_Items.all);

      Put_Line ("Day 11.2:" & Res'Image);
   end Solve;

end AoC.Monkey_In_The_Middle;
