-- PAQUET CONTROL MENÚ --

-- podem inserir vehicles durant l'execució del programa mitjançant un menú

with Jewl.Simple_Windows; use  Jewl.Simple_Windows;
with TascaHistoric; use TascaHistoric;
package body ControlMenu is

task body TascaControlMenu is
   F   : Frame_Type   := Frame (335, 86, "Menú de Control", 'Q', Font ("Arial", 8, Bold => False));
   B1   : Button_Type := Button (F, (5, 5), 75, 20, "Inserir Cotxe", 'A');
   B2   : Button_Type := Button (F, (85, 5), 75, 20, "Inserir Camio", 'B');
   B3   : Button_Type := Button (F, (165, 5), 75, 20, "Inserir Moto", 'C');
   B4   : Button_Type := Button (F, (245, 5), 75, 20, "Inserir Bici", 'D');
   B5   : Button_Type := Button (F, (5, 30), 140, 20, "Activar control de trànsit", 'E');

   Id: Integer:=Ident;
   C: PVehicle;
   control_activat: boolean:=false;
begin
   Set_Origin(F, (5, 5));
   -- comprova la opció escollida i la porta a terme
   loop
      case Next_Command is
         when 'A' => D.Inserirvehicle(Id, COTXE);
                     C := new Vehicle(Id, D, T, COTXE, Q, TMG, p, Control_transit,loger,uts);
                     loger.Avis_Insersio_Vehicle(COTXE, 1);
                     Id:=Id+1;
         when 'B' => D.Inserirvehicle(Id, CAMIO);
                     C := new Vehicle(Id, D, T, CAMIO, Q, TMG, p, Control_transit,loger,uts);
                     loger.Avis_Insersio_Vehicle(CAMIO, 1);
                     Id:=Id+1;
         when 'C' => D.Inserirvehicle(Id, CICLOMOTOR);
                     C := new Vehicle(Id, D, T, CICLOMOTOR, Q, TMG, p, Control_transit,loger,uts);
                     loger.Avis_Insersio_Vehicle(CICLOMOTOR, 1);
                     Id:=Id+1;
         when 'D' => D.Inserirvehicle(Id, BICICLETA);
                     C := new Vehicle(Id, D, T, BICICLETA, Q, TMG, p, Control_transit,loger,uts);
                     loger.Avis_Insersio_Vehicle(BICICLETA, 1);
                     Id:=Id+1;
         when 'E' => if not control_activat then
                        begin
                           Control_transit.Activar_Control;
                           control_activat:=true;
                           Set_Text(B5, "Desactivar control de trànsit");
                        end;
                     else
                        begin
                           Control_transit.Desactivar_Control;
                           control_activat:=false;
                           Set_Text(B5, "Activar control de trànsit");
                        end;
                     end if;
         when others => null;
      end case;      

   end loop;
   
end TascaControlMenu;
   
end ControlMenu;