-- PAQUET TASCA HISTÒRIC --

with Jewl.Simple_Windows;
use Jewl.Simple_Windows;
with Tipus;
use Tipus;

package body TascaHistoric is
   -- Transforma de dígit a caràcter
   function Dig_A_Car (
         Digit : in     Integer ) 
     return String is 
   begin
      case Digit is
         when 0 =>
            return "0";
         when 1 =>
            return "1";
         when 2 =>
            return "2";
         when 3 =>
            return "3";
         when 4 =>
            return "4";
         when 5 =>
            return "5";
         when 6 =>
            return "6";
         when 7 =>
            return "7";
         when 8 =>
            return "8";
         when 9 =>
            return "9";
         when others =>
            return "0";
      end case;
   end Dig_A_Car;
   -- Transforma de enter a cadena
   function Enter_A_Cadena (
         Num : in     Integer ) 
     return String is 
      S      : String (1 .. 3);  
      D1,  
      D2,  
      D3     : Integer;  
      Numero : Integer         := Num;  
   begin
      D1:=abs(Numero/100);
      Numero:=Numero - (abs(Numero/100))*100;
      D2:=abs(Numero/10);
      Numero:=Numero - (abs(Numero/10))*10;
      D3:=Numero;
      S:=Dig_A_Car(D1) & Dig_A_Car(D2) & Dig_A_Car(D3);
      return S;
   end Enter_A_Cadena;
   -- Mostra la informació dels diversos esdeveniments que van succeint, mitjançant una finestra.
   task body Historial is
      F : Frame_Type       := Frame (280, 160, "Historial", 'Q', Font ("Arial", 8, Bold => False));  
      M : Memo_Type        := Memo (F, (5, 5), 260, 120);  
      S : String (1 .. 17);  
   begin
      Set_Origin(F, (515,5));
      loop
         select
            -- rep els missatges d'activació/desactivació del control de trànsit
            accept Avis_Estat_Control_Transit (
                  Estat : Boolean ) do 
               case Estat is
                  when True =>
                     Append_Line(M,"Control de trànsit activat");
                  when False =>
                     Append_Line(M,"Control de trànsit desactivat");
               end case;
            end Avis_Estat_Control_Transit;
         or
            -- rep els missatges d'inserció de nous vehicles
            accept Avis_Insersio_Vehicle (
                  Tipus     : Ttipusvehicle; 
                  Quantitat : Integer        ) do 
               S:= "S'ha inserit " & Enter_A_Cadena(Quantitat) & " ";
               case Tipus is
                  when Cotxe =>
                     Append_Line(M, S & "cotxe/s");
                  when Ciclomotor =>
                     Append_Line(M,S & "ciclomotor/s");
                  when Camio =>
                     Append_Line(M,S & "camió/ns");
                  when Bicicleta =>
                     Append_Line(M,S & "bicicleta/es");
                  when Camio_Escombraries =>
                     Append_Line(M,S & "camió/ns d'escombraries");
                  when Camio_Grua =>
                     Append_Line(M,S & "grua/es");
                  when others =>
                     null;
               end case;
            end Avis_Insersio_Vehicle;
            or
            -- rep els missatges de nou vehicle espatllat
            accept Avis_Vehicle_Espatllat (
                  Tipus : Ttipusvehicle ) do 
               S:= "S'ha espatllat un";
               case Tipus is
                  when Cotxe =>
                     Append_Line(M, S & " cotxe");
                  when Ciclomotor =>
                     Append_Line(M,S & " ciclomotor");
                  when Camio =>
                     Append_Line(M,S & " camió");
                  when Bicicleta =>
                     Append_Line(M,S & " bicicleta");
                  when others =>
                     null;
               end case;
            end Avis_Vehicle_Espatllat;
            or
            -- rep el missatge d'escombriaire inicia el recorregut
            accept Avis_Recorregut_Escombriaire_Iniciat do 
               Append_Line(M, "L'escombriaire inicia el recorregut");
            end Avis_Recorregut_Escombriaire_Iniciat;
            or
            -- rep el missatge d'escombriaire que a completat el recorregut   
            accept Avis_Recorregut_Escombriaire_Completat do 
               Append_Line(M, "L'escombriaire ha completat el recorregut");
            end Avis_Recorregut_Escombriaire_Completat;
            or
            -- rep el missatge d'escombriaire que no a pogut completar el recorregut
            accept Avis_Recorregut_Escombriaire_No_Completat do 
               Append_Line(M, "L'escombriaire no ha completat el recorregut");
            end Avis_Recorregut_Escombriaire_No_Completat;
            or
             -- rep el missatge que la grua surt a buscar un vehicle
            accept Avis_Grua_Busca_Vehicle do 
               Append_Line(M, "La grua surt a buscar un vehicle espatllat");
            end Avis_Grua_Busca_Vehicle;
            or
               -- rep el missatge que la grua ha trobat el vehicle
            accept Avis_Grua_Troba_Vehicle do 
               Append_Line(M, "La grua ha trobat el vehicle espatllat");
            end Avis_Grua_Troba_Vehicle;
            or
               -- rep el missatge que la grua ha deixat el vehicle al taller
            accept Avis_Grua_Deixa_Vehicle_Taller do 
               Append_Line(M, "La grua ha deixat el vehicle espatllat al taller");
            end Avis_Grua_Deixa_Vehicle_Taller;
         end select;
      end loop;
   end Historial;

end TascaHistoric;

