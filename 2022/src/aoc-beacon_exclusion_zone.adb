with Ada.Containers.Vectors;

package body AoC.Beacon_Exclusion_Zone is

   Part_1 : Boolean := True;

   type Data is record
      Sensor_X, Sensor_Y : Integer;
      Beacon_X, Beacon_Y : Integer;
   end record;

   package Data_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive,
      Element_Type => Data);

   Sensor_Data : Data_Vectors.Vector;

   function Row return Natural is (if Is_Sample_Input then 10 else 2_000_000);
   X_Min, X_Max, Y_Min, Y_Max : Integer;

   function Char_Index (S : String; C : Character; N : Positive) return Positive is
      Nth : Positive := 1;
   begin
      for I in S'First .. S'Last loop
         if S (I) = C then
            if Nth = N then
               return I;
            else
               Nth := Nth + 1;
            end if;
         end if;
      end loop;
      raise Constraint_Error;
   end Char_Index;

      function Min (A, B : Integer) return Integer is
         (if A < B then A else B);

      function Max (A, B : Integer) return Integer is
         (if A > B then A else B);

   procedure Process_Line (Line : String) is
      S_X, S_Y, B_X, B_Y : Integer := 0;
      Last : Natural := Line'First;

   begin
      --Put_Line (Line);

      I_IO.Get (Line (Char_Index (Line, '=', 1) + 1 .. Char_Index (Line, ':', 1) - 1), S_X, Last);
      I_IO.Get (Line (Char_Index (Line, '=', 2) + 1 .. Char_Index (Line, ':', 1) - 1), S_Y, Last);
      I_IO.Get (Line (Char_Index (Line, '=', 3) + 1 .. Line'Last), B_X, Last);
      I_IO.Get (Line (Char_Index (Line, '=', 4) + 1 .. Line'Last), B_Y, Last);

      if Sensor_Data.Is_Empty then
         X_Min := Min (S_X, B_X);
         X_Max := Max (S_X, B_X);
         Y_Min := Min (S_Y, B_Y);
         Y_Max := Max (S_Y, B_Y);
      else
         X_Min := Min (X_Min, Min (S_X, B_X));
         X_Max := Max (X_Max, Max (S_X, B_X));
         Y_Min := Min (Y_Min, Min (S_Y, B_Y));
         Y_Max := Max (Y_Max, Max (S_Y, B_Y));
      end if;

      Sensor_Data.Append (Data'(S_X, S_Y, B_X, B_Y));
   end Process_Line;

   function Interacts_With_Row (D : Data; Row : Natural) return Boolean is
      Width : constant Natural := abs (D.Sensor_X - D.Beacon_X) + abs (D.Sensor_Y - D.Beacon_Y);
   begin
      --Put_Line (Row'Image & D.Sensor_Y'Image & Width'Image);
      if D.Sensor_Y > Row then
         return D.Sensor_Y - Width <= Row;
      else
         return D.Sensor_Y + Width >= Row;
      end if;
   end Interacts_With_Row;

   function Get_X_Min (D : Data; Row : Natural) return Integer is
      Width : constant Natural := abs (D.Sensor_X - D.Beacon_X) + abs (D.Sensor_Y - D.Beacon_Y);
      Gap : constant Natural := abs (D.Sensor_Y - Row);
   begin
      --Put_Line (D.Sensor_X'Image & Width'Image & Gap'Image);
      return D.Sensor_X - (Width - Gap); --(Width - Gap) * 2 + 1;
   end Get_X_Min;

   function Get_X_Max (D : Data; Row : Natural) return Integer is
      Width : constant Natural := abs (D.Sensor_X - D.Beacon_X) + abs (D.Sensor_Y - D.Beacon_Y);
      Gap : constant Natural := abs (D.Sensor_Y - Row);
   begin
      --Put_Line (D.Sensor_X'Image & Width'Image & Gap'Image);
      return D.Sensor_X + (Width - Gap); --(Width - Gap) * 2 + 1;
   end Get_X_Max;

Acc : Natural := 0;

   procedure Process_Row is
      --type Row_Type is array (Integer range X_Min .. X_Max) of Character;

      --R : Row_Type := (others => '.');
      Mimin : Integer := X_Min;--Get_X_Min (Sensor_Data (1), Row);
      Mamax : Integer := X_Min;--Get_X_Min (Sensor_Data (1), Row);
   begin
      for D in Sensor_Data.First_Index .. Sensor_Data.Last_Index loop
         if Interacts_With_Row (Sensor_Data (D), Row) then
            --Put_Line ("Interacts:" & Get_X_Min (Sensor_Data (D), Row)'Image & Get_X_Max (Sensor_Data (D), Row)'Image);
            Mimin := Min (Mimin, Get_X_Min (Sensor_Data (D), Row));
            Mamax := Max (Mamax, Get_X_Max (Sensor_Data (D), Row));
         end if;
      end loop;

      --Put_Line (Mimin'Image & Mamax'Image);

      Acc := Mamax - Mimin;

   end Process_Row;

   procedure Solve (Input : String) is
   begin
      Solve_Puzzle (Input, Process_Line'Access);

      --Put_Line (X_Min'Image & X_Max'Image);
      Process_Row;

      Put_Line ("Day 15.1:" & Acc'Image);
   end Solve;

end AoC.Beacon_Exclusion_Zone;
