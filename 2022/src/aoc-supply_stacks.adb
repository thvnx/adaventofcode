with Ada.Containers.Vectors;

package body AoC.Supply_Stacks is

   Part_1 : Boolean := True;

   subtype Crate is Character range 'A' .. 'Z';

   package Stack is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Crate);

   package Int_IO is new Integer_IO (Positive); use Int_IO;

   type Stock is array (1 .. 9) of Stack.Vector;
  
   --      [W]         [J]     [J]        
   --      [V]     [F] [F] [S] [S]        
   --      [S] [M] [R] [W] [M] [C]        
   --      [M] [G] [W] [S] [F] [G]     [C]
   --  [W] [P] [S] [M] [H] [N] [F]     [L]
   --  [R] [H] [T] [D] [L] [D] [D] [B] [W]
   --  [T] [C] [L] [H] [Q] [J] [B] [T] [N]
   --  [G] [G] [C] [J] [P] [P] [Z] [R] [H]
   --   1   2   3   4   5   6   7   8   9 

   Dock : Stock;

   function Fill_Stack (Crates : String) return Stack.Vector is
      V : Stack.Vector;
   begin
      for C of Crates loop
         V.Append (C);
      end loop;
      return V;
   end Fill_Stack;

   procedure Move_Crane (Orders : String; Dock : in out Stock) is
      type Order is record
         Move, From, To : Positive;
      end record;

      Last : Positive;
      Ord  : Order;
   begin
      Get (Orders (Orders'First + 4 .. Orders'Last), Ord.Move, Last);
      Get (Orders (Last + 6 .. Orders'Last), Ord.From, Last);
      Get (Orders (Last + 4 .. Orders'Last), Ord.To, Last);

      if Part_1 then
         for M in 1 .. Ord.Move loop
            Dock (Ord.To).Append (Stack.Last_Element (Dock (Ord.From)));
            Stack.Delete_Last (Dock (Ord.From));
         end loop;
      else
         for M in (Positive (Dock (Ord.From).Length) - Ord.Move + 1) .. Positive (Dock (Ord.From).Length) loop
            Dock (Ord.To).Append (Stack.Element (Dock (Ord.From), M));
         end loop;

         for M in 1 .. Ord.Move loop
            Stack.Delete_Last (Dock (Ord.From));
         end loop;
      end if;
   end Move_Crane;

   procedure Process_Line (Line : String) is
   begin
      if Line'Last >= 4 and then Line (1 .. 4) = "move" then
         Move_Crane (Line, Dock);
      end if;
   end Process_Line;

   procedure Solve (Input : String) is
      Part : String (1 .. 2);
   begin
      for P in 1 .. 2 loop
         if Is_Sample_Input then
            Dock (1) := Fill_Stack ("ZN");
            Dock (2) := Fill_Stack ("MCD");
            Dock (3) := Fill_Stack ("P");           
         else
            Dock (1) := Fill_Stack ("GTRW");
            Dock (2) := Fill_Stack ("GCHPMSVW");
            Dock (3) := Fill_Stack ("CLTSGM");
            Dock (4) := Fill_Stack ("JHDMWRF");
            Dock (5) := Fill_Stack ("PQLHSWFJ");
            Dock (6) := Fill_Stack ("PJDNFMS");
            Dock (7) := Fill_Stack ("ZBDFGCSJ");
            Dock (8) := Fill_Stack ("RTB");
            Dock (9) := Fill_Stack ("HNWLC");
         end if;
         Solve_Puzzle (Input, Process_Line'Access);

         Part := P'Image;
         
         Put ("Day 5." & Part (2) & ": ");
         for T in 1 .. (if Is_Sample_Input then 3 else 9) loop
            Put (Stack.Last_Element (Dock (T)));
         end loop;
         Put_Line ("");

         Part_1 := False;
      end loop;
      
   end Solve;

end AoC.Supply_Stacks;
