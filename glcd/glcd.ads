
with AVR; use AVR;

package GLCD is
   pragma Preelaborate;

   type ChipSelect is (Left,Right);
   subtype PageAddress is Nat8 range 0..7;
   subtype SingleChipX is Nat8 range 0 .. 63;

   -- Types for External use
   subtype CoordX is Nat8 range 0 .. 127;
   subtype CoordY is Nat8 range 0 .. 63;

   procedure Initialize;
   procedure SetPixel(X: CoordX; Y: CoordY; Value: Boolean);
   procedure ClearScreen;

private
   procedure WriteCommand(Controller:ChipSelect; Command:Nat8);
   procedure WriteData(Controller:ChipSelect; Data:Nat8);
   function ReadData(Controller:ChipSelect) return Nat8;

end GLCD;
