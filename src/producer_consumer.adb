with Ada.Text_IO, GNAT.Semaphores;
use Ada.Text_IO, GNAT.Semaphores;

with Ada.Containers.Doubly_Linked_Lists;
use Ada.Containers;

procedure Producer_Consumer is

   package String_Lists is new Doubly_Linked_Lists(Integer);
   use String_Lists;

   Storage : List;

   Access_Storage : Counting_Semaphore(1, Default_Ceiling);
   Full_Storage : Counting_Semaphore(3, Default_Ceiling);
   Empty_Storage : Counting_Semaphore(0, Default_Ceiling);

   task Producer is
      entry Start(Item_Numbers : in Integer);
   end Producer;

   task Consumer is
      entry Start(Item_Numbers : in Integer);
   end Consumer;

   task body Producer is
      Item_Numbers : Integer;
   begin
      accept Start(Item_Numbers : in Integer) do
         Producer.Item_Numbers := Item_Numbers;
      end Start;

      for i in 1 .. Item_Numbers loop
         Full_Storage.Seize;
         Access_Storage.Seize;

         Storage.Append(i);
         Put_Line("Added item " & i'Img);

         Access_Storage.Release;
         Empty_Storage.Release;
      end loop;

   end Producer;

   task body Consumer is
      Item_Numbers : Integer;
      Item : Integer;
   begin
      accept Start(Item_Numbers : in Integer) do
         Consumer.Item_Numbers := Item_Numbers;
      end Start;

      for i in 1 .. Item_Numbers loop
         Empty_Storage.Seize;
         Access_Storage.Seize;

         Item := Storage.First_Element;
         Storage.Delete_First;
         Put_Line("Took item" & Item'Img);

         Access_Storage.Release;
         Full_Storage.Release;
         delay 0.1;
      end loop;

   end Consumer;

   procedure Starter(Storage_Size  : in Integer; Item_Numbers : in Integer) is
   begin

      Consumer.Start(Item_Numbers);
      Producer.Start(Item_Numbers);
   end Starter;

begin
   Starter(3, 10);
end Producer_Consumer;
