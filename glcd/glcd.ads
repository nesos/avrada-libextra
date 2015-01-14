
with AVR; use AVR;

package GLCD is
   pragma Preelaborate;

   -- Types for External use
   subtype CoordX is Nat8 range 0 .. 127;
   subtype CoordY is Nat8 range 0 .. 63;

   --Initialize the display.
   --Always call this before calling any other method
   procedure Initialize;

   --Set one pixel at the display.
   --The parameter value map False to an cleared pixel and True to a Black pixel
   procedure SetPixel(X: CoordX; Y: CoordY; Value: Boolean);

   --Clear all Pixels of the Screen
   procedure ClearScreen;

private

   type ChipSelect is (Left,Right);
   subtype PageAddress is Nat8 range 0..7;
   subtype SingleChipX is Nat8 range 0 .. 63;

   procedure WriteCommand(Controller:ChipSelect; Command:Nat8);
   procedure WriteData(Controller:ChipSelect; Data:Nat8);
   function ReadData(Controller:ChipSelect) return Nat8;

end GLCD;
