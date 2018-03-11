with QueueArray;
use QueueArray;
with Tipus;
use Tipus;
with Ada.Real_Time;
use Ada.Real_Time;

package body ElementsSistema is
   -- Pinta el vehicle en funció del tipus de motor gràfic escollit
   procedure PintarVehicle(id: in integer; tipus: in Ttipusvehicle; C: in TCoordenada; D: in PDibuixant; Q: in Pqueue; it : in Item; TMG: Tipusmotorgrafic) is
      Cua: PQueue := Q;
      I: Item :=it;
   begin
      case TMG is
         when Metode_Directe => D.Actualitzarimatgevehicle(id, C, tipus);
         when Metode_Buffering =>
              I.Coor:=C;
              Enqueue(I,Cua);
      end case;   
   end PintarVehicle;

   -- Obté les distàncies mitjanes de vida útil en funció del tipus de vehicle
   function ObtenirDistancia(tipus: in Ttipusvehicle) return Integer is
      dist: Integer;
   begin
      case tipus is
         when Cotxe => dist:=distancies.cotxe;
         when Ciclomotor => dist:=distancies.ciclomotor;
         when Camio => dist:=distancies.camio;
         when Bicicleta => dist:=distancies.bicicleta;
         when others => dist:=0;
      end case;
      return dist;
   end ObtenirDistancia;

   -- Obté les desviacions de les distàncies mitjanes de vida útil en funció del tipus de vehicle
   function ObtenirDesviacio(tipus: in Ttipusvehicle) return Integer is
      desv: Integer;
   begin
      case tipus is
         when Cotxe => desv:=desviacions.cotxe;
         when Ciclomotor => desv:=desviacions.ciclomotor;
         when Camio => desv:=desviacions.camio;
         when Bicicleta => desv:=desviacions.bicicleta;
         when others => desv:=0;
      end case;
      return desv;
   end ObtenirDesviacio;

   -- Obté la desició que ha de prendre la grua quan arriba al final d'un tram
   function ObtenirDesicioGrua(tipustramg: in TtipusTram; posiciogrua: in TCoordenada; tipustramv: in TtipusTram; posiciovehicle: in TCoordenada) return TDesicio is
      opcio: TDesicio;
   begin
      if ((tipustramg=VERTICAL) and (tipustramv=VERTICAL) and (posiciogrua.x /= posiciovehicle.x)) then opcio:=GIRAR;
      elsif ((tipustramg=VERTICAL) and (tipustramv=VERTICAL) and (posiciogrua.x = posiciovehicle.x)) then opcio:=RECTE;
      elsif ((tipustramg=HORITZONTAL) and (tipustramv=HORITZONTAL) and (posiciogrua.y /= posiciovehicle.y)) then opcio:=GIRAR;
      elsif ((tipustramg=HORITZONTAL) and (tipustramv=HORITZONTAL) and (posiciogrua.y = posiciovehicle.y)) then opcio:=RECTE;
      elsif (((tipustramg=HORITZONTAL) and (tipustramv=VERTICAL) and (abs(posiciogrua.x-posiciovehicle.x) = 1)) or ((tipustramg=VERTICAL) and (tipustramv=HORITZONTAL) and (abs(posiciogrua.y-posiciovehicle.y) = 1))) then opcio:=GIRAR;
      else opcio:= RECTE;
      end if;
      return opcio;
   end;
   -- Depenent el tipus de vehicle i del UTS retorna el temps d'espera (velocitat del vehicle)
   function ObtenirDelayVehicle(uts :in Integer; tipus: in Ttipusvehicle) return duration is
      a,b,c: Duration;
      vel: Integer;
   begin
      case Tipus is
         when Cotxe => Vel:=velocitats.cotxe;
         when Ciclomotor => Vel:=velocitats.ciclomotor;
         when Camio => Vel:=velocitats.camio;
         when Bicicleta => Vel:=velocitats.bicicleta;
         when Camio_Escombraries => Vel:=velocitats.camio_escombraries;
         when Camio_Grua => Vel:=velocitats.camio_grua;
      end case;
      a:= to_duration(Milliseconds(vel*1000)) / BaseTemps;
      b:= 1.0 / a;
      c:= b / to_duration(Milliseconds(uts*1000));
      return c;
   end ObtenirDelayVehicle;

   -- Calcula la ruta del camió escombraries, forçant per a què passi per tots els carrers
   function Obtenirrutadelcamioescombraries (
         M : in     Integer; 
         N : in     Integer; 
         L : in     Integer  ) 
     return Ptruta is 
      Ruta : Ptruta;  
      I    : Integer := 0;  
   begin
      Ruta:= new Truta(0..(L-1));
      for A in 1..M-1 loop
         for B in 1..N-1 loop
            Ruta(I):=Recte;
            I:=I+1;
         end loop;
         for C in 1..2 loop
            Ruta(I):=Girar;
            I:=I+1;
         end loop;
      end loop;

      for D in 1..N-1 loop
         Ruta(I):=Recte;
         I:=I+1;
      end loop;
      Ruta(I):=Girar;
      I:=I+1;

      for A in 1..N-1 loop
         for B in 1..M-1 loop
            Ruta(I):=Recte;
            I:=I+1;
         end loop;
         for C in 1..2 loop
            Ruta(I):=Girar;
            I:=I+1;
         end loop;
      end loop;

      for D in 1..M-1 loop
         Ruta(I):=Recte;
         I:=I+1;
      end loop;
      Ruta(I):=Girar;
      I:=I+1;

      return Ruta;
   end Obtenirrutadelcamioescombraries;

   -- Temporitzador del semàfor, canvía en un període definit per l'usuari
   task body Timerparellsemafor is
      Period                : constant Time_Span := Milliseconds ((Tsem /2) / uts);  
      Next_Time,  
      Now                   :          Time;  
      Control_Transit_Actiu :          Boolean   := False;  
   begin
      Next_Time := Clock + Period;
      loop

         Now := Clock;
         delay(0.005);
         if Now - Next_Time > Period then
            Next_Time := Now + Period;
            S.Canviartorn;
         end if;
      end loop;
   end Timerparellsemafor;

   task body Grua is
      Ve                       : Pvehicle;  
      Vehicle_Espatllat_trobat : Boolean       := false;
      vehicle_portat_al_taller : Boolean       := false;
      Tipus_Vehicle_Espatllat  : Ttipusvehicle;  
      Controltransit           : Pcontrol;  
      Tram_Vehicle_Espatllat   : Ptram;  
      Carril_Vehicle_Espatllat : Ttipuscarril;
      Tipus_Tram_Vehicle_Espatllat : TtipusTram;
      Id_Vehicle_Espatllat,  
      Pos_Vehicle_Espatllat,  
      Maxd,  
      Desv                     : Integer;  
      Posiciogrua, Posiciovehicle              : Tcoordenada;  

      Pos       : Integer        := 0;  
      Carril    : Ttipuscarril   := Esquerra;
      Tram      : PTram:=T;
      Vel       : Duration;  
      Sem       : Pparellsemafor;  
      Tipustram : Ttipustram;  
      Migtram,  
      Fitram    : Boolean        := False;  
      C         : Tcoordenada;  
      Opcio     : Tdesicio;  
      I         : Item;  
      Tipus           : Ttipusvehicle  := Camio_grua;
      Cua: Pqueue:=Q;
   begin
      I.Object := True;
      I.Id:= Id;
      I.Tipus:= tipus;
      vel:= ObtenirDelayVehicle(uts, tipus);
      -- Rep el Control de Trànsit associat
      accept Indicar_Control_Transit (Control_Transit : Pcontrol) do 
         Controltransit:=Control_Transit;
      end Indicar_Control_Transit;

      loop
         -- Rep el cotxe que ha d'anar a recollir
         accept Anar_A_Buscar_Cotxe_Espatllat (
               Id        : Integer;       
               Tipus     : Ttipusvehicle; 
               T         : Ptram;         
               Pos       : Integer;       
               Carril    : Ttipuscarril;
               TipusTram : TtipusTram        ) do 
            Id_Vehicle_Espatllat:=Id;
            Tipus_Vehicle_Espatllat:=Tipus;
            Tram_Vehicle_Espatllat:=T;
            Pos_Vehicle_Espatllat:=Pos;
            Carril_Vehicle_Espatllat:=Carril;
            Tipus_Tram_Vehicle_Espatllat:=TipusTram;
            Maxd:=ObtenirDistancia(Tipus_Vehicle_Espatllat);
            Desv:=ObtenirDesviacio(Tipus_Vehicle_Espatllat);
            Loger.Avis_Grua_Busca_Vehicle;
         end Anar_A_Buscar_Cotxe_Espatllat;

         Posiciogrua:=Tram.Obteniradreça;
         Posiciovehicle:=Tram_Vehicle_Espatllat.Obteniradreça;
         -- recorrer els carrers fins que troba el vehicle i el porta al taller -> Grua ocupada
         while ((not vehicle_espatllat_trobat) or (not vehicle_portat_al_taller)) loop
            Tram.Obtenirseguentposicio (Pos, Carril, C, Fitram, Migtram, Sem, Tipustram);
            if (Fitram) then
                  Opcio:= ObtenirDesicioGrua(TipusTram, posiciogrua, Tipus_Tram_Vehicle_Espatllat, posiciovehicle);
                  if Tipustram=Horitzontal then Sem.Demanarpashoritzontal(Opcio, Tram);
                  else Sem.Demanarpasvertical(Opcio, Tram); end if;
                  Posiciogrua:=Tram.Obteniradreça;
                  Fitram:=False;
            else PintarVehicle(Id, Tipus, C, D, Cua, I, TMG); end if;

            if ((not vehicle_espatllat_trobat) and (Tram=Tram_vehicle_espatllat) and (Pos=Pos_vehicle_espatllat)) then
               
                  PintarVehicle(Id, Tipus_vehicle_espatllat, (0-metre,0-metre), D, Cua, I, TMG);
                  Tram_vehicle_espatllat:=Tramshoritzontals(0,0);
                  Tipus_Tram_Vehicle_Espatllat:=HORITZONTAL;
                  Posiciovehicle:=Tram_Vehicle_Espatllat.Obteniradreça;
                  vehicle_espatllat_trobat:=true;
               
            elsif ((vehicle_espatllat_trobat) and (not vehicle_portat_al_taller) and (Tram=Tramshoritzontals(0,0)) and (Pos=1)) then
                  Tram.Alliberarposicio(Pos, Carril);
                  Pos:=0;
                  vehicle_portat_al_taller:=true;
            end if;

            delay(vel);
         end loop;
         Loger.Avis_Grua_Troba_Vehicle;
         Vehicle_Espatllat_trobat:=False;
         Vehicle_Portat_al_taller:=false;
         -- un cop el vehicle espatllat arriva al taller, es crea un nou vehicle del mateix tipus que surt del mateix taller
         ve := new Vehicle(Id_Vehicle_Espatllat, D, Tramshoritzontals(0,0),
            Tipus_Vehicle_Espatllat, Cua, Tmg, p,Controltransit,
            Loger,uts);
         Loger.Avis_Grua_Deixa_Vehicle_Taller;
         Controltransit.Avis_Grua_Disponible;
      end loop;
   end Grua;

   task body Camioescombraries is
      Tram            : Ptram          := T;  
      Pos             : Integer        := 0;  
      L               : Integer        := (M - 1) * ((N - 1) + 2) + ((N -
        1) + 1) + (N - 1) * ((M - 1) + 2) + ((M - 1) + 1);  
      Index           : Integer        := 0;  
      Carril          : Ttipuscarril   := Esquerra;  
      Vel             : Duration;  
      Sem             : Pparellsemafor;  
      Tipustram       : Ttipustram;  
      Fitram          : Boolean        := False;  
      Quedin_Carrers,  
      Ruta_Completada,  
      Migtram         : Boolean        := False;  
      C               : Tcoordenada;  
      Opcio           : Tdesicio;  
      I               : Item;  
      Cua             : Pqueue         := Q;  
      Tipus           : Ttipusvehicle  := Camio_Escombraries;  
      Ruta            : Ptruta;  
      Period          : Time_Span      := Milliseconds (Tce/uts);
      Next_Time,  
      Limit           : Time;  
      Temps_Aturat    : Duration       := To_Duration (Milliseconds (Xce/uts));
   begin
      -- Obté a priori la ruta que ha de fer el camió d'escombreries en funció de la mida de la ciutat
      Ruta := Obtenirrutadelcamioescombraries(M, N, L);
      I.Object := True;
      I.Id:= Id;
      I.Tipus:= Tipus;
      vel:= ObtenirDelayVehicle(uts, tipus);
      Next_Time:= Clock;

      loop
         -- S'espera fins que arrivi el deadline(període)
         delay until Next_Time;
         Limit := Clock + Period;
         Ruta_Completada:=False;
         Loger.Avis_Recorregut_Escombriaire_Iniciat;
         select
         
            delay until Limit;
            Tram.Alliberarposicio(Pos, Carril);
            if not Ruta_Completada then
               Loger.Avis_Recorregut_Escombriaire_No_Completat;
            end if;
         then
            abort
         -- Mentre quedi temps, recorre la ruta 
            Tram.Alliberarposicio(Pos, Carril);
            Tram:=T;
            Pos:=0;
            Carril:=Esquerra;
            Index:=0;
            Quedin_Carrers :=True;
            Migtram:=false;
            Fitram:=false;
            while Quedin_Carrers loop
               if Migtram then
                  
                     if Carril=Esquerra then
                        
                           PintarVehicle(Id, Tipus, C, D, Cua, I, Motorgrafic);
                           delay(Temps_Aturat);
                           Migtram:=False;
                        
                     else
                        Tram.Demanarsituarsealcarrilesquerra(Pos,C,Carril);
                     end if;
                  
               else
                  
                     Tram.Obtenirseguentposicio (Pos, Carril, C, Fitram,
                        Migtram, Sem, Tipustram);
                     if Fitram then
                        
                           Opcio:=Ruta(Index);
                           Index:=Index+1;
                           if Index=L then
                              Index:=0;
                              Quedin_Carrers :=False;
                           end if;

                           if Tipustram=Horitzontal then
                              Sem.Demanarpashoritzontal(Opcio, Tram);
                           else
                              Sem.Demanarpasvertical(Opcio, Tram);
                           end if;

                           Fitram:=False;
                        
                     else PintarVehicle(Id, Tipus, C, D, Cua, I, Motorgrafic); end if;
                  
               end if;
               delay(Vel);
            end loop;

            Ruta_Completada:=True;
            Tram.Alliberarposicio(Pos, Carril);
            Loger.Avis_Recorregut_Escombriaire_Completat;
         end select;
         Tram.Alliberarposicio(Pos, Carril);
         Next_Time:= Next_Time + Period;
      end loop;
   end Camioescombraries;

   task body Vehicle is
      Tram      : Ptram          := T;  
      Pos       : Integer        := 0;  
      Carril    : Ttipuscarril   := Esquerra;  
      Vel       : Duration;  
      Sem       : Pparellsemafor;  
      Tipustram : Ttipustram;  
      Migtram,  
      Fitram    : Boolean        := False;  
      C         : Tcoordenada;  
      Opcio     : Tdesicio;  
      I         : Item;  
      Cua       : Pqueue         := Q;  
      Max       : Integer;
      Desviacio : Integer:=ObtenirDesviacio(tipus);
      Maxdist   : Integer:=ObtenirDistancia(tipus);
   begin
      Max := Maxdist - Desviacio + (2*Desviacio*Paquetdesviacio.Random_Value / 100);
      I.Object := True;
      I.Id:= Id;
      I.Tipus:= Tipus;
      vel:= ObtenirDelayVehicle(uts, tipus);
      Tram.Alliberarposicio(Pos, Carril);
      -- Cada iteració s'avança un metre
      for E in 0..Max-1 loop
         -- Obté la següent posició dins del Tram on està situat
         Tram.Obtenirseguentposicio (Pos, Carril, C, Fitram, Migtram, Sem, Tipustram);
         if (Fitram) then
               -- Quan s'arriva al final del Tram es decideix girar o no
               if Presadesicio.Random_Value <= probabilitat then opcio:=RECTE;
               else opcio:=GIRAR; end if;
               
               -- S'encua al semàfor que li correspon
               if Tipustram=Horitzontal then Sem.Demanarpashoritzontal(Opcio, Tram);
               else Sem.Demanarpasvertical(Opcio, Tram); end if;
               TipusTram:=Tram.ObtenirTipusTram;
               Tram.Obtenirseguentposicio (Pos, Carril, C, Fitram, Migtram, Sem, Tipustram);
               Fitram:=False;
            
         end if;

         PintarVehicle(Id, Tipus, C, D, Cua, I, Motorgrafic);
         delay(Vel);
      end loop;
      Tram.Alliberarposicio(Pos, Carril);
      TipusTram:=Tram.ObtenirTipusTram;
      Loger.Avis_Vehicle_Espatllat(Tipus);
      -- S'ha superat la distància de vida útil del vehicle i se li fa saber al Control de trànsit
      Control_Transit.Despatxar_Vehicle_Espatllat(Id,Tipus,Tram,Pos,Carril,TipusTram);
   end Vehicle;

   protected body Tram is
      -- Inicialitza el Tram
      procedure Inicialitzar (
            T    : in     Ttipustram;     
            S    : in     Ttipussentit;   
            Sem  : in     Pparellsemafor; 
            Long : in     Natural;        
            C    : in     Tcoordenada;    
            A    : in     Tcoordenada     ) is 
      begin
         Tipus:=T;
         Sentit:=S;
         Semafor:=Sem;
         Longitud:=Long;
         Posicio:=C;
         Adreça:=A;
         Carrildret:= new Tcarril(0..Longitud-1);
         Carrilesquerra:= new Tcarril(0..Longitud-1);
         for I in 0..Longitud-1 loop
            Carrildret(I):=False;
            Carrilesquerra(I):=False;
         end loop;
      end Inicialitzar;
      -- Quan un vehicle s'espatlla, usa aquest procediment per indicar que la posició està lliure
      procedure Alliberarposicio (
            Pos    : in     Integer;     
            Carril : in     Ttipuscarril ) is 
      begin
         case Carril is
            when Esquerra =>
               Carrilesquerra(Pos):=False;
            when Dret =>
               Carrildret(Pos):=False;
         end case;
      end Alliberarposicio;
      -- Retorna la posició gràfica del Tram dins de la ciutat
      function Obteniradreça return Tcoordenada is 
      begin
         return Adreça;
      end Obteniradreça;
      -- Retorna el tipus de Tram (Horitzontal o Vertical)
      function ObtenirTipusTram return TtipusTram is
      begin
         return Tipus;
      end ObtenirTipusTram;
      -- Retorna la posició gràfica del vehicle
      function Obtenircoordenadavehicle (
            Pos    : in     Integer;     
            Carril : in     Ttipuscarril ) 
        return Tcoordenada is 
         C : Tcoordenada;  
      begin
         if Tipus=Horitzontal then
            
               case Carril is
                  when Esquerra =>
                     C.Y := Posicio.Y;
                  when Dret =>
                     C.Y := Posicio.Y + Metre;
               end case;
               case Sentit is
                  when Est_Oest =>
                     C.X := Posicio.X + Longitud*Metre - Pos*Metre;
                  when Oest_Est =>
                     C.X := Posicio.X + Pos*Metre;
                  when others =>
                     null;
               end case;
            
         elsif Tipus=Vertical then
            
               case Carril is
                  when Esquerra =>
                     C.X := Posicio.X + Metre;
                  when Dret =>
                     C.X := Posicio.X;
               end case;
               case Sentit is
                  when Nord_Sud =>
                     C.Y := Posicio.Y + Pos*Metre;
                  when Sud_Nord =>
                     C.Y := Posicio.Y + Longitud*Metre - Pos*Metre;
                  when others =>
                     null;
               end case;
            
         end if;
         return C;
      end Obtenircoordenadavehicle;
      -- Obté la següent posició del vehicle dins del Tram 
      procedure Obtenirseguentposicio (
            Pos       : in out Integer;        
            Carril    : in out Ttipuscarril;   
            C         :    out Tcoordenada;    
            Fitram    : in out Boolean;        
            Migtram   :    out Boolean;        
            Sem       :    out Pparellsemafor; 
            Tipustram :    out Ttipustram      ) is 
      begin
         -- Cas: vehicle arriva al final del Tram
         if Pos >=Longitud-1 then
            
               if Carril=Esquerra then
                  Carrilesquerra(Pos):=False;
               else
                  Carrildret(Pos):=False;
               end if;
               Pos:=0;
               Carril:=Esquerra;
               Fitram:=True;
               Tipustram:=Tipus;
               Sem:=Semafor;
            
         -- Cas: vehicle està al carril esquerra
            -- Subcasos: 
            -- Cas 1: El vehicle està essent adelantat per un altre
            -- Cas 2: Quan la següent del carril esquerra està lliure
            -- Cas 3: Es posiciona al carril dret degut a que la posició del davant està ocupada   
         elsif Carril=Esquerra then
              
               if Carrildret(Pos) or Carrildret(Pos+1) then
                  
                     --Si s'entra aquí dins és degut a que algú vol abançar el vehicle,
                     --com que els conductors tenen un comportament tolerant aleshores
                     --deixem que ens abanci i ens oblidem de fer "curses".
              
                     null;
                  
               elsif not Carrilesquerra(Pos+1) then
                  
                     Carrilesquerra(Pos):=False;
                     Pos:=Pos+1;
                     Carrilesquerra(Pos):=True;
                  
               elsif not Carrildret(Pos+1) then
                  
                     Carrilesquerra(Pos):=False;
                     Carril:=Dret;
                     Pos:=Pos+1;
                     Carrildret(Pos):=True;
                  
               end if;
         -- Cas: El vehicle està al carril dret
            -- Subcasos:
            -- Cas 1: El vehicle adelantador es torna a situar a l'esquerra
            -- Cas 2: El vehicle adelantador continúa adelantant
         else  
               if ((not Carrilesquerra(Pos)) and (not Carrilesquerra(Pos+1))) then
                  
                     Carrildret(Pos):=False;
                     Carril:=Esquerra;
                     Pos:=Pos+1;
                     Carrilesquerra(Pos):=True;
                  
               elsif not Carrildret(Pos+1) then
                  
                     Carrildret(Pos):=False;
                     Pos:=Pos+1;
                     Carrildret(Pos):=True;
                  
               end if;
            
         end if;
         -- Comprova si està al mig del Tram (només ho utilitza el camió d'escombreries)
         Migtram:= (Pos=Longitud/2);
         C:= Obtenircoordenadavehicle(Pos, Carril);
      end Obtenirseguentposicio;
      -- Demana situar-se al carril esquerra
      procedure Demanarsituarsealcarrilesquerra (
            Pos    : in out Integer;     
            C      :    out Tcoordenada; 
            Carril : in out Ttipuscarril ) is 
      begin
         if Carril=Esquerra then
            null; --Si ja està a l'esquerra, doncs no cal fer res...
         else
            
               if not Carrilesquerra(Pos+1) then
                  
                     Carrildret(Pos):=False;
                     Pos:=Pos+1;
                     Carrilesquerra(Pos):=True;
                     Carril:=Esquerra;
                  
               end if;
            
         end if;
         C:= Obtenircoordenadavehicle(Pos, Carril);
      end Demanarsituarsealcarrilesquerra;
   end Tram;

   protected body Parellsemafor is
      -- S'encuen els vehicles que volen demanar pas vertical
      entry Demanarpasvertical (
            Des : in     Tdesicio; 
            T :    out Ptram     ) when ((Torn and not Mode_Fluidesa) or 
                                         (Torn and (Demanarpasvertical'Count > 0) and Mode_Fluidesa) or
                                         (Torn and (Demanarpasvertical'Count = 0) and (Demanarpashoritzontal'Count = 0) and Mode_Fluidesa) or
                                         (not Torn and (Demanarpasvertical'Count > 0)and (Demanarpashoritzontal'Count = 0) and (Mode_Fluidesa))) is 
         I : Item;
      begin
         case Motorgrafic is
            when Metode_Directe =>
               D.Actualitzarimatgesemafor(Id, true);
            when Metode_Buffering =>
               I.Object:=False;
               I.Id:=Id;
               I.Pas:=true;
               Enqueue(I,C);
         end case;

         case Des is
            when Recte =>
               T:=Tramvertical;
            when Girar =>
               T:=Tramhoritzontal;
         end case;
      end Demanarpasvertical;
      -- S'encuen els vehicles que volen demanar pas horitzontal
      entry Demanarpashoritzontal (
            Des : in     Tdesicio; 
            T :    out Ptram     ) when ((not Torn and not Mode_Fluidesa) or 
                                         (not Torn and (Demanarpashoritzontal'Count > 0) and Mode_Fluidesa) or
                                         (not Torn and (Demanarpashoritzontal'Count = 0) and (Demanarpasvertical'Count = 0) and Mode_Fluidesa) or
                                         (Torn and (Demanarpashoritzontal'Count > 0) and (Demanarpasvertical'Count = 0) and (Mode_Fluidesa))) is 
         I : Item;
      begin

         case Motorgrafic is
            when Metode_Directe =>
               D.Actualitzarimatgesemafor(Id, false);
            when Metode_Buffering =>
               I.Object:=False;
               I.Id:=Id;
               I.Pas:=false;
               Enqueue(I,C);
         end case;

         case Des is
            when Recte =>
               T:=Tramhoritzontal;
            when Girar =>
               T:=Tramvertical;
         end case;
      end Demanarpashoritzontal;
      -- Retorna el número de vehicles en espera vertical i horitzontal
      procedure Obtenirnumerovehiclesenespera (
            H :    out Integer; 
            V :    out Integer  ) is 
      begin
         H:= Demanarpashoritzontal'Count;
         V:= Demanarpasvertical'Count;
      end Obtenirnumerovehiclesenespera;
      -- Inicialitza el semàfor
      procedure Inicialitzar (
            Ident : in     Integer;         
            Tv    : in     Ptram;           
            Th    : in     Ptram;           
            Dib   : in     Pdibuixant;      
            Cua   : in     Pqueue;          
            Tmg   :        Tipusmotorgrafic ) is 
      begin
         Mode_Fluidesa:= False;
         Torn:=True;
         Id:=Ident;
         Tramvertical:=Tv;
         Tramhoritzontal:=Th;
         D:=Dib;
         C:=Cua;
         Motorgrafic:=Tmg;
      end Inicialitzar;
      -- Activa el mode de fluïdesa
      procedure Activarmodefluidesa is 
      begin
         Mode_Fluidesa := True;
      end Activarmodefluidesa;
      -- Desactiva el mode fluïdesa
      procedure Desactivarmodefluidesa is 
      begin
         Mode_Fluidesa := False;
      end Desactivarmodefluidesa;
      -- Intercanvía el torn del semàfor (vertical -> horitzontal, horitzontal -> vertical)
      procedure Canviartorn is 
         I : Item;  
      begin
         Torn := not Torn;

            case Motorgrafic is
               when Metode_Directe =>
                  D.Actualitzarimatgesemafor(Id, Torn);
               when Metode_Buffering =>
                  I.Object:=False;
                  I.Id:=Id;
                  I.Pas:=Torn;
                  Enqueue(I,C);
            end case;
      end Canviartorn;
   end Parellsemafor;

   task body Control is
      Grua_Ocupada    : Boolean := False;  
      Control_Activat : Boolean := False;  
   begin
      loop
         select
            -- Rep l'avís que la grua està disponible (missatge que només envia la Grua)
            accept Avis_Grua_Disponible do 
               Grua_Ocupada:=False;
            end Avis_Grua_Disponible;
         or  
            -- Despatxa el següent vehicle espatllat si el control de trànsit està activat i la Grua està lliure
            when Control_Activat and not Grua_Ocupada =>
            accept Despatxar_Vehicle_Espatllat (
                  Id        : Integer;       
                  Tipus     : Ttipusvehicle; 
                  T         : Ptram;         
                  Pos       : Integer;       
                  Carril    : Ttipuscarril;
                  TipusTram : TtipusTram ) do 
               Vehicle_Grua.Anar_A_Buscar_Cotxe_Espatllat(Id,Tipus,T,Pos,Carril,TipusTram);
               Grua_Ocupada:=True;
            end Despatxar_Vehicle_Espatllat;
         or
            -- Activa el control de trànsit i el mode de fluïdesa per cada semàfor
            accept Activar_Control do 
               for X in 0..M-1 loop
                  for Y in 0..N-1 loop
                     Semafors(X,Y).Activarmodefluidesa;
                  end loop;
               end loop;
               Control_Activat:=True;
               Loger.Avis_Estat_Control_Transit(Control_Activat);
            end Activar_Control;
         or
            -- Desactiva el control de trànsit i el mode de fluïdesa per cada semàfor
            accept Desactivar_Control do 
               for X in 0..M-1 loop
                  for Y in 0..N-1 loop
                     Semafors(X,Y).Desactivarmodefluidesa;
                  end loop;
               end loop;
               Control_Activat:=False;
               Loger.Avis_Estat_Control_Transit(Control_Activat);
            end Desactivar_Control;
         or
            -- Obté el nombre de vehicles espatllats
            accept ObtenirNumeroVehiclesEspatllats(NumVehicles: out Integer) do
               NumVehicles:=Despatxar_Vehicle_Espatllat'Count;
            end ObtenirNumeroVehiclesEspatllats;
         end select;
      end loop;

   end Control;

end ElementsSistema;