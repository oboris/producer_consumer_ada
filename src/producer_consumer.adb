with Ada.Text_IO, GNAT.Semaphores;
use Ada.Text_IO, GNAT.Semaphores;

with Ada.Containers.Indefinite_Doubly_Linked_Lists;
use Ada.Containers;

procedure Producer_Consumer is
   package String_Lists is new Indefinite_Doubly_Linked_Lists (String);
   use String_Lists;

   procedure Starter (Storage_Size : in Integer; Item_Numbers : in Integer) is
      Storage : List;

      Access_Storage : Counting_Semaphore (1, Default_Ceiling);
      Full_Storage   : Counting_Semaphore (Storage_Size, Default_Ceiling);
      Empty_Storage  : Counting_Semaphore (0, Default_Ceiling);

      task Producer;

      task Consumer;

      task body Producer is
         --  Item_Numbers : Integer;
      begin
         --  accept Start (Item_Numbers : in Integer) do
         --     Producer.Item_Numbers := Item_Numbers;
         --  end Start;

         for i in 1 .. Item_Numbers loop
            Full_Storage.Seize;
            Access_Storage.Seize;

            Storage.Append ("item " & i'Img);
            Put_Line ("Added item " & i'Img);

            Access_Storage.Release;
            Empty_Storage.Release;
            delay 1.5;
         end loop;

      end Producer;

      task body Consumer is
         --Item_Numbers : Integer;
      begin
         --  accept Start (Item_Numbers : in Integer) do
         --     Consumer.Item_Numbers := Item_Numbers;
         --  end Start;

         for i in 1 .. Item_Numbers loop
            Empty_Storage.Seize;
            Access_Storage.Seize;

            declare
               item : String := First_Element (Storage);
            begin
               Put_Line ("Took " & item);
            end;

            Storage.Delete_First;

            Access_Storage.Release;
            Full_Storage.Release;

            delay 2.0;
         end loop;

      end Consumer;

   begin
      null;
   --     Consumer.Start (Item_Numbers);
   --     Producer.Start (Item_Numbers);
   end Starter;

begin
   Starter (3, 10);
end Producer_Consumer;
