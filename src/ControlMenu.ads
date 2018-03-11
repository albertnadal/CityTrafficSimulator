with Tipus; use Tipus;
with ElementsSistema; use ElementsSistema;
with PaquetGrafic; use PaquetGrafic;
with QueueArray; use QueueArray;
with TascaHistoric; use TascaHistoric;

package ControlMenu is

   task type TascaControlMenu(Ident: Integer; D: Pdibuixant; Q: Pqueue; T: Ptram; p: integer; TMG: TipusMotorGrafic; Control_Transit: Pcontrol; loger: PHistorial; uts: integer);
   type PTascaControlMenu is access TascaControlMenu; 

end ControlMenu;

