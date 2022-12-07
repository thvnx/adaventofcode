with Ada.Containers.Vectors;

with Ada.Text_IO; use Ada.Text_IO;

procedure Part1 is
   F   : File_Type;

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

      for M in 1 .. Ord.Move loop
         Dock (Ord.To).Append (Stack.Last_Element (Dock (Ord.From)));
         Stack.Delete_Last (Dock (Ord.From));
      end loop;
   end Move_Crane;
begin
   Dock (1) := Fill_Stack ("GTRW");
   Dock (2) := Fill_Stack ("GCHPMSVW");
   Dock (3) := Fill_Stack ("CLTSGM");
   Dock (4) := Fill_Stack ("JHDMWRF");
   Dock (5) := Fill_Stack ("PQLHSWFJ");
   Dock (6) := Fill_Stack ("PJDNFMS");
   Dock (7) := Fill_Stack ("ZBDFGCSJ");
   Dock (8) := Fill_Stack ("RTB");
   Dock (9) := Fill_Stack ("HNWLC");

   Put_Line (Dock'Image);

   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         if Line'Last >= 4 and then Line (1 .. 4) = "move" then
            Move_Crane (Line, Dock);
         end if;
      end;
   end loop;
   Close (F);

   Put_Line (Dock'Image);

   Put_Line (
      Stack.Last_Element (Dock (1))
      & Stack.Last_Element (Dock (2))
      & Stack.Last_Element (Dock (3))
      & Stack.Last_Element (Dock (4))
      & Stack.Last_Element (Dock (5))
      & Stack.Last_Element (Dock (6))
      & Stack.Last_Element (Dock (7))
      & Stack.Last_Element (Dock (8))
      & Stack.Last_Element (Dock (9))
   );
end Part1;
