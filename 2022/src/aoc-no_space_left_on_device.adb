with Ada.Containers.Vectors;

with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body AoC.No_Space_Left_On_Device is

   type Item;
   type Item_Access is access Item;

   package Files is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Item_Access);

   type Item is record
      Dir     : Boolean;
      Name    : String_Access;
      Size    : Integer_Access;
      Parent  : Item_Access;
      Content : Files.Vector;
   end record;

   package Int_IO is new Integer_IO (Positive); use Int_IO;

   procedure Compute_Size (Node : Item_Access) is
   begin
      if Node.Dir then
         for I of Node.Content loop
            Compute_Size (I);
            if Node.Size /= null then
               Node.Size.all := Node.Size.all + I.Size.all;
            else
               Node.Size := new Integer'(I.Size.all);
            end if;
         end loop;
      end if;
   end Compute_Size;

   procedure Print (Node : Item_Access; Indent : Integer := 0) is
   begin
      Put_Line (Indent * "-" & Node.Name.all & " (" & Node.Size.all'Image & " ) " & (if Node.Dir then "d" else "f"));
      for I of Node.Content loop
         Print (I, Indent+2);
      end loop;
   end Print;
   pragma Unreferenced (Print);

   procedure Sum_Part1 (Node : Item_Access) is
      Acc : Integer := 0;
      procedure Traverse (Node : Item_Access) is
      begin
         for I of Node.Content loop
            Traverse (I);
         end loop;

         if Node.Dir and then Node.Size.all <= 100000 then 
            --Put_Line (Node.Name.all & " (" & Node.Size.all'Image & " ) " & (if Node.Dir then "d" else "f"));
            Acc := Acc + Node.Size.all;
         end if;
      end Traverse;
   begin
      Traverse (Node);
      Put_Line ("Day 7.1:" & Acc'Image);
   end Sum_Part1;

   procedure Sum_Part2 (Node : Item_Access) is
      Total : constant Integer := Node.Size.all;
      Needed_Space : constant Integer := 30_000_000 - (70_000_000 - Total);
      Candidate_Space : Integer := 70_000_000;

      procedure Traverse (Node : Item_Access) is
      begin
         for I of Node.Content loop
            Traverse (I);
         end loop;

         if Node.Dir and then Node.Size.all >= Needed_Space then 
            --Put_Line (Node.Name.all & " (" & Node.Size.all'Image & " ) " & (if Node.Dir then "d" else "f"));
            if Node.Size.all < Candidate_Space then
               Candidate_Space := Node.Size.all;
            end if;
         end if;
      end Traverse;
   begin
      Traverse (Node);
      Put_Line ("Day 7.2:" & Candidate_Space'Image);
   end Sum_Part2;

   Root, Curr_Dir, Tmp : Item_Access := null;
   Name                : String_Access;

   procedure Process_Line (Line : String) is
   begin
      if Line (Line'First) = '$' then
         if Line (Line'First + 2 .. Line'First + 3) = "cd" then
            if Line (Line'First + 5) = '.' and then Line (Line'First + 6) = '.' then
               Curr_Dir := Curr_Dir.Parent;
            elsif Line (Line'First + 5) = '/' then
               Name     := new String'(Line (Line'First + 5 .. Line'Last));
               Curr_Dir := new Item'(True, Name, null, Curr_Dir, Files.Empty_Vector);
               Root     := Curr_Dir;
            else
               declare
                  Found : Boolean := False;
               begin
                  for I of Curr_Dir.Content loop
                     if I.Name.all = Line (Line'First + 5 .. Line'Last) then
                        Curr_Dir := I;
                        Found := True;
                     end if;
                  end loop;
                  if not Found then
                     raise Constraint_Error;
                  end if;
               end;
            end if;
         elsif Line (Line'First + 2 .. Line'First + 3) = "ls" then
            --  nothing to do
            null;
         else
            raise Constraint_Error;
         end if;
      
      elsif Line (Line'First .. Line'First + 2) = "dir" then
         Name     := new String'(Line (Line'First + 4 .. Line'Last));
         Tmp      := new Item'(True, Name, null, Curr_Dir, Files.Empty_Vector);
         Curr_Dir.Content.Append(Tmp);
      else
         --  file!
         declare
            Last, Size : Positive;
            S : Integer_Access;
         begin
            Get (Line, Size, Last);
            S := new Integer'(Size);
            Name := new String'(Line (Last + 2 .. Line'Last));
            Tmp  := new Item'(False, Name, S, Curr_Dir, Files.Empty_Vector);
            Curr_Dir.Content.Append(Tmp);
         end;
      end if;
   end Process_Line;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);

      Compute_Size (Root);
      --Print (Root);
      Sum_Part1 (Root);

      --Put_Line (Root.all'Image);
      --Put_Line (Root.Size.all'Image);

      Sum_Part2 (Root);
   end Solve;

end AoC.No_Space_Left_On_Device;
