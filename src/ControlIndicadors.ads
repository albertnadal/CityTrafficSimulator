with Jewl.Simple_Windows; use  Jewl.Simple_Windows;
with ElementsSistema; use ElementsSistema;

package ControlIndicadors is

   type TMatriuEtiquetes is array(Integer  range <>, Integer  range <>) of Label_Type;
   type PTMatriuEtiquetes is access TMatriuEtiquetes;
   
   task type TascaControlIndicadors(Semafors: PTMatriuParellSemafors; M: Integer; N: Integer; control_transit: Pcontrol);
   type PTascaControlIndicadors is access TascaControlIndicadors; 

end ControlIndicadors;