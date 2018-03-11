with Jewl.Windows;
with Tipus; use Tipus;

Package PaquetGrafic is

   type TComanda is (Quit, Pintar);
   package Sketch_Windows is new JEWL.Windows(TComanda); use Sketch_Windows;

   type TLlistaVehicles is array(Integer  range <>) of Canvas_Type;
   type PTLlistaVehicles is access TLlistaVehicles;
   type TLlistaSemafors is array(Integer  range <>) of Canvas_Type;
   type PTLlistaSemafors is access TLlistaSemafors;

   protected type Dibuixant is   
      Procedure ActualitzarImatgeVehicle(id: in integer; C: in TCoordenada; tipus: in TTipusVehicle);
      Procedure ActualitzarImatgeSemafor(id: in integer; t: in boolean);
      Procedure Inicialitzar(t: in String; num: in Integer; l: in Integer; N: in Integer; M: in Integer; nums: in Integer);
      Procedure PintarEdificis(N: in Integer; M: in Integer; ample: in Integer);
      procedure InserirVehicle(id: in Integer; tipus: in TTipusVehicle);
      Procedure InserirSemafor(id: in Integer; C: in TCoordenada);
   private
      NumVehicles: Integer;
      NumSemafors: Integer;
      Vehicles: PTLlistaVehicles;
      Semafors: PTLlistaSemafors;
      Finestra: Frame_Type;
      Superficie: Canvas_Type;
   end Dibuixant;
   
   Type PDibuixant is access Dibuixant;

End PaquetGrafic;