with AVR;   use AVR;
with AVR.MCU;

--This is the configuration for the driver
private package GLCD.Config is
   pragma Preelaborate;

   --One 8-bit Port of the MCU for reading and writing data
   PORT_Data: Nat8 renames MCU.PORTA;
   PIN_Data:Nat8 renames MCU.PINA;
   DDR_Data: Nat8 renames MCU.DDRA;

   -- Control Pins
   --Data/Instruction Control Pin
   DI : Boolean renames MCU.PORTD_Bits (0);
   DD_DI: Boolean renames MCU.DDRD_Bits(0);

   --Read/Write Control Pin
   RW : Boolean renames MCU.PORTD_Bits (1);
   DD_RW: Boolean renames MCU.DDRD_Bits(1);

   --Enable Pin
   Enable : Boolean renames MCU.PORTD_Bits (4);
   DD_Enable: Boolean renames MCU.DDRD_Bits(4);

   --Chip 1 (Left) Select Pin
   CS1 : Boolean renames MCU.PORTD_Bits (5);
   DD_CS1: Boolean renames MCU.DDRD_Bits(5);

   --Chip 2 (Right) Select Pin
   CS2 : Boolean renames MCU.PORTD_Bits (6);
   DD_CS2: Boolean renames MCU.DDRD_Bits(6);

   --Hardware Reset Pin
   Reset : Boolean renames MCU.PORTD_Bits (7);
   DD_Reset: Boolean renames MCU.DDRD_Bits(7);

end GLCD.Config;
