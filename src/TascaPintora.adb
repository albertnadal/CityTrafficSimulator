-- PAQUET TASCA PINTORA --
-- Només s'utilitza quan el tipus de motor gràfic que s'escolleix és amb el que està basat amb Sistema de Buffering
-- És una tasca autoadaptada que regula la seva freqüència de lectura en funció de la quantitat d'elements que hi ha a la cua
with Tipus; use Tipus;

package body TascaPintora is
   -- Llegeix de la cua els esdeveniments que s'han de pintar
   task body Pintor is
      Cua: Pqueue := Q;
      I: Item;
      Buit: Boolean;
      EnEspera: Integer;
   begin
      loop
         Dequeue(I,Buit,EnEspera,Cua);
         If not Buit then 

               case I.Object is
                  when true => D.ActualitzarImatgeVehicle(I.Id, I.Coor, I.Tipus);
                  when false => D.ActualitzarImatgeSemafor(I.Id, I.Pas);
               end case;
               
               if ((EnEspera >= 0) and (EnEspera < 5)) then  Delay (0.005);
               elsif ((EnEspera >= 5) and (EnEspera < 10)) then  Delay (0.00005);
               elsif ((EnEspera >= 10) and (EnEspera < 50)) then  Delay (0.000005);
               elsif EnEspera >= 50 then Delay (0.00000005);
               end if;
            else Delay (0.05); 
         end if;

      end loop;
   end Pintor;

end TascaPintora;

