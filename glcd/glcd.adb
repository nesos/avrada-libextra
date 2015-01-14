with Interfaces; use Interfaces;

with AVR; use AVR;
with AVR.Wait;
with AVR.Interrupts;

with GLCD.Config; use GLCD.Config;

package body GLCD is

   procedure Initialize is
   begin
      DD_DI := DD_Output;
      DD_RW := DD_Output;
      DD_Enable := DD_Output;
      DD_CS1 := DD_Output;
      DD_CS2 := DD_Output;
      DD_Reset := DD_Output;

      CS1 := Low;
      CS2 := Low;
      Enable := Low;
      DI := Low;
      RW := Low;

      --Enable the display and run a reset cycle
      Reset  := Low;
      Wait.Wait_4_Cycles (4);
      Reset := High;
      Wait.Wait_4_Cycles (4);

      WriteCommand(Left,16#C0#);
      WriteCommand(Left,16#3F#);
      WriteCommand(Right,16#C0#);
      WriteCommand(Right,16#3F#);
   end Initialize;

   procedure SelectController(Controller:ChipSelect) is
   begin
      if(Controller = Left) then
         CS1 := High;
         CS2 := Low;
      else
         CS1 := Low;
         CS2 := High;
      end if;
   end SelectController;

   procedure WaitForChip(Controller:ChipSelect) is
   begin
      Interrupts.Disable_Interrupts;
      SelectController(Controller);
      DI := Low;
      DDR_Data := 16#00#;
      PORT_Data := 16#FF#;
      RW := High;
      Enable := High;
      Wait.Wait_4_Cycles (4);
      while PIN_Data >= 16#80# loop
         Enable := Low;
         Wait.Wait_4_Cycles (4);
         Enable := High;
         Wait.Wait_4_Cycles (4);
      end loop;
      Enable := Low;
      RW := Low;
      DDR_Data := 16#FF#;
      Interrupts.Enable_Interrupts;
   end WaitForChip;

   procedure WriteCommand(Controller:ChipSelect; Command:Nat8) is
   begin
      Interrupts.Disable_Interrupts;
      WaitForChip(Controller);
      DI := Low;
      RW := Low;
      Enable := High;
      DDR_Data := 16#FF#;
      PORT_Data := Command;
      Wait.Wait_4_Cycles (4);
      Enable := Low;
      Interrupts.Disable_Interrupts;
   end WriteCommand;

   procedure WriteData(Controller:ChipSelect; Data:Nat8) is
   begin
      Interrupts.Disable_Interrupts;
      WaitForChip(Controller);
      DI := High;
      RW := Low;
      Enable := High;
      DDR_Data := 16#FF#;
      PORT_Data := Data;
      Wait.Wait_4_Cycles (4);
      Enable := Low;
      Interrupts.Disable_Interrupts;
   end WriteData;

   function ReadData(Controller:ChipSelect) return Nat8 is
      ReadData: Nat8 := 0;
   begin
      Interrupts.Disable_Interrupts;
      WaitForChip(Controller);
      DDR_Data := 16#00#;
      DI := High;
      RW := High;
      Enable := High;
      Wait.Wait_4_Cycles (4);
      ReadData := PIN_Data;
      Enable := Low;
      Interrupts.Disable_Interrupts;
      return ReadData;
   end ReadData;

   procedure SelectPage(Controller:ChipSelect; Column:SingleChipX; Page:PageAddress) is
      Page_Select_Cmd : Nat8 := 2#10111000#;
      Col_Select_Cmd : Nat8 :=  2#01000000#;
   begin
      Col_Select_Cmd := Col_Select_Cmd + Column;
      Page_Select_Cmd := Page_Select_Cmd + Page;
      WriteCommand(Controller, Col_Select_Cmd);
      WriteCommand(Controller, Page_Select_Cmd);
   end SelectPage;

   procedure SetPixel(X: CoordX; Y: CoordY; Value: Boolean) is
      Controller     : ChipSelect;
      Page           : PageAddress;
      CurrentPageData: Nat8;
      LocalX         : SingleChipX;
      PageDataBits   : Bits_In_Byte;
      for PageDataBits'Address use CurrentPageData'Address;
   begin
      if X<64 then
         Controller := Left;
      else
         Controller := Right;
      end if;
      Page := Y/8;
      LocalX := X mod 64;
      SelectPage(Controller,X mod 64,Page);
      CurrentPageData := ReadData(Controller);
      CurrentPageData := ReadData(Controller);
      PageDataBits(Bit_Number(Y mod 8)) := Value;
      SelectPage(Controller,LocalX,Page);
      WriteData(Controller,CurrentPageData);
   end SetPixel;

   procedure ClearScreen is
   begin
      for Page in PageAddress loop
         for X in SingleChipX loop
            SelectPage(Left,X,Page);
            WriteData(Left,16#00#);
            SelectPage(Right,X,Page);
            WriteData(Right,16#00#);
         end loop;
      end loop;
   end ClearScreen;

end GLCD;
