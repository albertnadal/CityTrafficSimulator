with QueueArray; use QueueArray;
With PaquetGrafic; use PaquetGrafic;
with Tipus; use Tipus;

Package MapeigEntorn is

   type TCoordenada is record
      x : Integer;
      y : Integer;
   end record;
   
   Procedure CrearTrams(M: in Integer; N: in Integer);
   Procedure CrearSemafors(M: in Integer; N: in Integer; Cua: in Pqueue; Tsem: in Integer; uts: in Integer);
   Procedure Inicialitzar_Trams_i_Semafors(M: in Integer; N: in Integer; llarg: in Integer; d: in PDibuixant; Cua: in Pqueue; MotorGrafic: in TipusMotorGrafic);

End MapeigEntorn;
