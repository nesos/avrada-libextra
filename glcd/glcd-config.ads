with AVR;   use AVR;
with AVR.MCU;

private package GLCD.Config is
   pragma Preelaborate;

   PORT_Data: Nat8 renames MCU.PORTA;
   PIN_Data:Nat8 renames MCU.PINA;
   DDR_Data: Nat8 renames MCU.DDRA;

   -- Control Pins
   DI : Boolean renames MCU.PORTD_Bits (0);
   DD_DI: Boolean renames MCU.DDRD_Bits(0);

   RW : Boolean renames MCU.PORTD_Bits (1);
   DD_RW: Boolean renames MCU.DDRD_Bits(1);

   Enable : Boolean renames MCU.PORTD_Bits (4);
   DD_Enable: Boolean renames MCU.DDRD_Bits(4);

   CS1 : Boolean renames MCU.PORTD_Bits (5);
   DD_CS1: Boolean renames MCU.DDRD_Bits(5);

   CS2 : Boolean renames MCU.PORTD_Bits (6);
   DD_CS2: Boolean renames MCU.DDRD_Bits(6);

   Reset : Boolean renames MCU.PORTD_Bits (7);
   DD_Reset: Boolean renames MCU.DDRD_Bits(7);


   DataIn_Bits : Bits_In_Byte;
   for DataIn_Bits'Address use PIN_Data'Address;
   pragma Volatile (DataIn_Bits);

end GLCD.Config;
