-- PAQUET MAPEIG ENTORN --

With ElementsSistema; use ElementsSistema;
With PaquetGrafic; use PaquetGrafic;

package body MapeigEntorn is
   -- Inicialitza els semàfors i assigna coordenades als diferents objectes de la ciutat
   Procedure Inicialitzar_Trams_i_Semafors(M: in Integer; N: in Integer; llarg: in Integer; d: in PDibuixant; Cua: in Pqueue; MotorGrafic: in TipusMotorGrafic) is
      SentitHoritzontal: TTipusSentit;
      SentitVertical: TTipusSentit:=NORD_SUD;
      xHoritzontal, yHoritzontal, xVertical, yVertical, id: Integer;
   begin
         id:=0;
         for x in 0..M-1 loop
            SentitHoritzontal:=OEST_EST;
            for y in 0..N-1 loop
               xHoritzontal:=x*(llarg*Metre + 2*Metre);
               yHoritzontal:=(y+1)*(llarg*Metre) + (y*2*Metre) + 1;
               xVertical:=(x+1)*(llarg*Metre) + (x*2*Metre) + 1;
               yVertical:=y*(llarg*Metre + 2*Metre);

               if SentitVertical=NORD_SUD and SentitHoritzontal=OEST_EST then
                  
                     TramsHoritzontals(x,y).Inicialitzar(HORITZONTAL, OEST_EST, Semafors(x,y), llarg, (xHoritzontal,yHoritzontal), (x*2, y*2 + 1));
                     TramsVerticals(x,y).Inicialitzar(VERTICAL, NORD_SUD, Semafors(x,y), llarg, (xVertical,yVertical), (x*2 + 1, y*2));
                     Semafors(x,y).Inicialitzar(id,TramsVerticals(x,(y+1) mod N), TramsHoritzontals((x+1) mod M,y), d, Cua, MotorGrafic);
                     SentitHoritzontal:=EST_OEST;
                  
               elsif SentitVertical=NORD_SUD and SentitHoritzontal=EST_OEST then
                  
                     TramsHoritzontals(x,y).Inicialitzar(HORITZONTAL, EST_OEST, Semafors((x-1+M) mod M,y), llarg, (xHoritzontal,yHoritzontal), (x*2, y*2 + 1));
                     TramsVerticals(x,y).Inicialitzar(VERTICAL, NORD_SUD, Semafors(x,y), llarg, (xVertical,yVertical), (x*2 + 1, y*2));
                     Semafors(x,y).Inicialitzar(id,TramsVerticals(x,(y+1) mod N), TramsHoritzontals(x,y),d,Cua, MotorGrafic);
                     SentitHoritzontal:=OEST_EST;
                  
               elsif SentitVertical=SUD_NORD and SentitHoritzontal=OEST_EST then
                  
                     TramsHoritzontals(x,y).Inicialitzar(HORITZONTAL, OEST_EST, Semafors(x,y), llarg, (xHoritzontal,yHoritzontal), (x*2, y*2 + 1));
                     TramsVerticals(x,y).Inicialitzar(VERTICAL, SUD_NORD, Semafors(x,(y-1+N) mod N), llarg, (xVertical,yVertical), (x*2 + 1, y*2));
                     Semafors(x,y).Inicialitzar(id,TramsVerticals(x,y), TramsHoritzontals((x+1) mod M,y),d,Cua, MotorGrafic);
                     SentitHoritzontal:=EST_OEST;
                  
               elsif SentitVertical=SUD_NORD and SentitHoritzontal=EST_OEST then
                  
                     TramsHoritzontals(x,y).Inicialitzar(HORITZONTAL, EST_OEST, Semafors((x-1+M) mod M,y), llarg, (xHoritzontal,yHoritzontal), (x*2, y*2 + 1));
                     TramsVerticals(x,y).Inicialitzar(VERTICAL, SUD_NORD, Semafors(x,(y-1+N) mod N), llarg, (xVertical,yVertical), (x*2 + 1, y*2));
                     Semafors(x,y).Inicialitzar(id,TramsVerticals(x,y), TramsHoritzontals(x,y),d,Cua, MotorGrafic);
                     SentitHoritzontal:=OEST_EST;
                  
               end if;
               d.InserirSemafor(id,((x+1)*(llarg*Metre) + x*2*Metre + 1, (y+1)*(llarg*Metre) + y*2*Metre + 1));
               id:=id+1;
            end loop;

            if SentitVertical=NORD_SUD then SentitVertical:=SUD_NORD;
            else SentitVertical:=NORD_SUD; end if;            
         end loop;
   end Inicialitzar_Trams_I_Semafors;
   
   -- Crea les tasques Timer associades a cada semàfor
   Procedure CrearSemafors(M: in Integer; N: in Integer; Cua: in Pqueue; Tsem: in Integer; uts: in Integer) is
      timer: PTimerParellSemafor;
   begin
         Semafors:= new TMatriuParellSemafors(0..M-1,0..N-1);
         for x in 0..M-1 loop
            for y in 0..N-1 loop
               Semafors(x,y):= new ParellSemafor;
               timer := new TimerParellSemafor(Semafors(x,y), Tsem, uts);
            end loop;
         end loop;
   end CrearSemafors;
   -- Crea els Trams Horitzontals i Verticals
   procedure CrearTrams(M: in Integer; N: in Integer) is
   begin
         TramsHoritzontals:= new TMatriuTrams(0..M,0..N);
         for y in 0..N loop
            for x in 0..M loop
               TramsHoritzontals(x,y):= new Tram;
            end loop;
         end loop;

         TramsVerticals:= new TMatriuTrams(0..M,0..N);
         for x in 0..M loop
            for y in 0..N loop
               TramsVerticals(x,y):= new Tram;
            end loop;
         end loop;
   end CrearTrams;

end MapeigEntorn;

