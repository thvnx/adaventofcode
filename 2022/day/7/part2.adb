with Ada.Containers.Vectors;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Part2 is
   F : File_Type;

   type String_Access is access String;
   type Integer_Access is access Integer;

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

   procedure Sum_Part1 (Node : Item_Access) is
      Total : constant Integer := Node.Size.all;
      Needed_Space : constant Integer := 30_000_000 - (70_000_000 - Total);
      Candidate_Space : Integer := 70_000_000;

      procedure Traverse (Node : Item_Access) is
      begin
         for I of Node.Content loop
            Traverse (I);
         end loop;

         if Node.Dir and then Node.Size.all >= Needed_Space then 
            Put_Line (Node.Name.all & " (" & Node.Size.all'Image & " ) " & (if Node.Dir then "d" else "f"));
            if Node.Size.all < Candidate_Space then
               Candidate_Space := Node.Size.all;
            end if;
         end if;
      end Traverse;
   begin
      Traverse (Node);
      Put_Line (Candidate_Space'Image);
   end Sum_Part1;

   Root, Curr_Dir, Tmp : Item_Access := null;
   Name                : String_Access;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         if Line (1) = '$' then
            if Line (3 .. 4) = "cd" then
               if Line (6) = '.' and then Line (7) = '.' then
                  Curr_Dir := Curr_Dir.Parent;
               elsif Line (6) = '/' then
                  Name     := new String'(Line (6 .. Line'Last));
                  Curr_Dir := new Item'(True, Name, null, Curr_Dir, Files.Empty_Vector);
                  Root     := Curr_Dir;
               else
                  declare
                     Found : Boolean := False;
                  begin
                     for I of Curr_Dir.Content loop
                        if I.Name.all = Line (6 .. Line'Last) then
                           Curr_Dir := I;
                           Found := True;
                        end if;
                     end loop;
                     if not Found then
                        raise Constraint_Error;
                     end if;
                  end;
               end if;
            elsif Line (3 .. 4) = "ls" then
               --  nothing to do
               null;
            else
               raise Constraint_Error;
            end if;
         
         elsif Line (1 .. 3) = "dir" then
            Name     := new String'(Line (5 .. Line'Last));
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
      end;
   end loop;
   Close (F);

   Compute_Size (Root);
   Print (Root);
   Sum_Part1 (Root);

   Put_Line (Root.all'Image);
   Put_Line (Root.Size.all'Image);
end Part2;
