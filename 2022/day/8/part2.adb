with Ada.Text_IO; use Ada.Text_IO;

procedure Part2 is
   type Boolean_Access is access Boolean;
   type Natural_Access is access Natural;

   type Tree;

   type Tree_Access is access Tree;

   type Tree is record
      Height                   : Natural;
      Top, Bottom, Left, Right : Tree_Access;
      Visible                  : Boolean_Access;
      Scenic_Score             : Natural_Access;
   end record;

   F                   : File_Type;
   Bottom_Right_Corner : Tree_Access := null;
   Pred_Tree, Top_Tree : Tree_Access := null;

   procedure Navigate_Top_Left (Tree : in out Tree_Access) is
   begin
      while Tree.Left /= null loop
         Tree := Tree.Left;
      end loop;
      while Tree.Top /= null loop
         Tree := Tree.Top;
      end loop;
   end Navigate_Top_Left;

   procedure Print_Map (Bottom_Right_Corner : Tree_Access) is
      Top_Left_Corner : Tree_Access := Bottom_Right_Corner;
   begin
      Navigate_Top_Left (Top_Left_Corner);
      while Top_Left_Corner /= null loop
         Put (Top_Left_Corner.Height'Image);
         while Top_Left_Corner.Right /= null loop
            Put (Top_Left_Corner.Right.Height'Image);
            Top_Left_Corner := Top_Left_Corner.Right;
         end loop;
         Put_Line ("");
         while Top_Left_Corner.Left /= null loop
            Top_Left_Corner := Top_Left_Corner.Left;
         end loop;
         Top_Left_Corner := Top_Left_Corner.Bottom;
      end loop;
   end Print_Map;

   function Compute_Scenic_Score (Bottom_Right_Corner : Tree_Access) return Natural is
      Curr_Tree : Tree_Access := Bottom_Right_Corner;
      Max_Score : Natural := 0;
      Go_Left   : Boolean := True;

      procedure Process_Compute (Tree : Tree_Access) is
         Temp        : Tree_Access := Tree;
         Continue    : Boolean := True;
         Score       : Natural := 1;
         Local_Score : Natural := 0;
         Height      : constant Natural := Tree.Height;
      begin
         while Continue and then Temp.Bottom /= null loop
            Local_Score := Local_Score + 1;

            if Height <= Temp.Bottom.Height then
               Continue := False;
            end if;

            Temp := Temp.Bottom;
         end loop;

         Score := Score * Local_Score;
         Temp := Tree;
         Local_Score := 0;
         Continue := True;

         while Continue and then Temp.Top /= null loop
            Local_Score := Local_Score + 1;

            if Height <= Temp.Top.Height then
               Continue := False;
            end if;

            Temp := Temp.Top;
         end loop;

         Score := Score * Local_Score;
         Temp := Tree;
         Local_Score := 0;
         Continue := True;

         while Continue and then Temp.Left /= null loop
            Local_Score := Local_Score + 1;

            if Height <= Temp.Left.Height then
               Continue := False;
            end if;

            Temp := Temp.Left;
         end loop;

         Score := Score * Local_Score;
         Temp := Tree;
         Local_Score := 0;
         Continue := True;

         while Continue and then Temp.Right /= null loop
            Local_Score := Local_Score + 1;

            if Height <= Temp.Right.Height then
               Continue := False;
            end if;

            Temp := Temp.Right;
         end loop;

         Score := Score * Local_Score;

         Tree.Scenic_Score := new Natural'(Score);

      end Process_Compute;
   begin
      while Curr_Tree /= null loop
         Process_Compute (Curr_Tree);
         if Curr_Tree.Scenic_Score.all > Max_Score then
            Max_Score := Curr_Tree.Scenic_Score.all;
         end if;
         if Go_Left then
            if Curr_Tree.Left /= null then
               Curr_Tree := Curr_Tree.Left;
            else
               Curr_Tree := Curr_Tree.Top;
               Go_Left := False;
            end if;
         elsif Curr_Tree.Right /= null then
            Curr_Tree := Curr_Tree.Right;
         else
            Curr_Tree := Curr_Tree.Top;
            Go_Left := True;
         end if;
      end loop;
      
      return Max_Score;
   end Compute_Scenic_Score;
begin
   Open (F, In_File, "input");
   while not End_Of_File (F) loop
      declare
         Line : constant String := Get_Line (F);
      begin
         for C of Line loop

            Bottom_Right_Corner := new Tree'(Natural'Value([1 => C]),
                                             Top_Tree,
                                             null,
                                             Pred_Tree,
                                             null,
                                             null,
                                             null);

            if Top_Tree /= null then
               Top_Tree.Bottom := Bottom_Right_Corner;
               Top_Tree := Top_Tree.Right;
            end if;
            if Pred_Tree /= null then
               Pred_Tree.Right := Bottom_Right_Corner;
            end if;

            Pred_Tree := Bottom_Right_Corner;
         end loop;
         Pred_Tree := null;
         Top_Tree := Bottom_Right_Corner;
         while Top_Tree.Left /= null loop
            Top_Tree := Top_Tree.Left;
         end loop;
      end;
   end loop;
   Close (F);

   --  Print_Map (Bottom_Right_Corner);
   Put_Line (Compute_Scenic_Score (Bottom_Right_Corner)'Image);
end Part2;
