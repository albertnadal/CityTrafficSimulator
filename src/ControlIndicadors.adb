-- PAQUET CONTROL INDICADORS --

with Jewl.Simple_Windows; use  Jewl.Simple_Windows;

package body ControlIndicadors is

task body TascaControlIndicadors is
   MatriuEtiquetesSemaforsVerticals: PTMatriuEtiquetes;
   MatriuEtiquetesSemaforsHoritzontals: PTMatriuEtiquetes;
   Etiqueta, Etiqueta2: Label_Type;
   EtiquetaMaxim, EtiquetaEspatllats: Label_Type;
   F   : Frame_Type;
   EnEsperaVertical: Integer:=0;
   EnEsperaHoritzontal: Integer:=0;
   TotalVehiclesEnEspera: Integer:=0;
   TotalVehiclesEspatllats: Integer:=0;
begin
   F:= Frame (M*35 + 25, N*15 + 95, "Indicadors", 'Q', Font ("Arial", 8, Bold => False));
   Set_Origin(F,(345,5));
   Etiqueta:= Label (F, (5, N*15 + 20), 120, 15, "Vehicles en espera:", Center);
   EtiquetaMaxim:= Label (F, (120, N*15 + 20), 20, 15, "0", Center);
   Etiqueta2:= Label (F, (5, N*15 + 40), 120, 15, "Vehicles espatllats:", Center);
   EtiquetaEspatllats:= Label (F, (120, N*15 + 40), 20, 15, "0", Center);
   MatriuEtiquetesSemaforsVerticals:= new TMatriuEtiquetes(0..M-1,0..N-1);
   Matriuetiquetessemaforshoritzontals:= new Tmatriuetiquetes(0..M-1,0..N-1);
   
   -- Inicialitza el valor inicial de les etiquetes que es mostren per pantalla   
   for x in 0..M-1 loop
      for y in 0..N-1 loop
         MatriuEtiquetesSemaforsHoritzontals(x,y):= Label (F, (x*15 + 10, y*15 + 10), 15, 15, "0", Center);
         MatriuEtiquetesSemaforsVerticals(x,y):= Label (F, (x*15 + 25 + M*15, y*15 + 10), 15, 15, "0", Center);
      end loop;
   end loop;
   
   loop
      Totalvehiclesenespera:=0;
      -- Recorrem tots els semàfors de la ciutat i obtenim el nombre de vehicles en espera de cadascun
      for x in 0..M-1 loop
         for y in 0..N-1 loop
            Semafors(x,y).ObtenirNumeroVehiclesEnEspera(EnEsperaHoritzontal, EnEsperaVertical);
            Set_Text (MatriuEtiquetesSemaforsVerticals(x,y), Integer'Image(EnEsperaVertical));
            Set_Text (Matriuetiquetessemaforshoritzontals(X,Y), Integer'Image(Enesperahoritzontal));
            -- suma total de vehicles en espera
            TotalVehiclesEnEspera:=TotalVehiclesEnEspera + EnEsperaVertical + EnEsperaHoritzontal;
            Set_Text (EtiquetaMaxim, Integer'Image(TotalVehiclesEnEspera));
            control_transit.ObtenirNumeroVehiclesEspatllats(TotalVehiclesEspatllats);
            Set_Text (EtiquetaEspatllats, Integer'Image(TotalVehiclesEspatllats));
         end loop;
      end loop;
      delay(0.05);
   end loop;
   
end TascaControlIndicadors;
   
end ControlIndicadors;
