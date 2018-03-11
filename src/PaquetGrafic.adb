-- PAQUET GRÀFIC --

with Jewl.Windows;

package body PaquetGrafic is

   protected body Dibuixant is
      -- Dibuixa els edificis al mapa
      procedure Pintaredificis (
            N     : in     Integer; 
            M     : in     Integer; 
            Ample : in     Integer  ) is 
      begin
         Set_Fill(Superficie, Gray);
         for Y in 0..N-1 loop
            for X in 0..M-1 loop
               Draw_Rectangle(Superficie,(X*((Ample*Metre)+(2*Metre)),Y*((
                           Ample*Metre)+(2*Metre))),Ample*Metre, Ample*
                  Metre,(10,10));
            end loop;
         end loop;
         Set_Fill(Superficie, (255,128,64));
         Draw_Rectangle(Superficie, (0,(Ample*Metre) - (2*Metre)), 3*Metre, 2*metre, (5,5));
      end Pintaredificis;
      -- Actualitza la imatge d'un vehicle a la nova posició
      procedure Actualitzarimatgevehicle (
            Id    : in     Integer;      
            C     : in     Tcoordenada;  
            Tipus : in     Ttipusvehicle ) is 
         Color : Colour_Type;  
      begin
         Set_Origin(Vehicles(Id), (C.X, C.Y));
         case Tipus is
            when Cotxe =>
               Color:=Blue;
            when Ciclomotor =>
               Color:=Yellow;
            when Camio =>
               Color:=Red;
            when Bicicleta =>
               Color:=Green;
            when Camio_Escombraries =>
               Color:=Magenta;
            when Camio_Grua =>
               Color:= Black;
         end case;
         Set_Colour(Vehicles(Id), Color);
      end Actualitzarimatgevehicle;
      -- Actualitza la imatge d'un semàfor al nou estat
      procedure Actualitzarimatgesemafor (
            Id : in     Integer; 
            T  : in     Boolean  ) is 
      begin
         Erase(Semafors(Id));
         if T then
            
               Draw_Line(Semafors(Id),(1,1),(1, 2*Metre - 3));
               Draw_Line(Semafors(Id),(2*Metre - 4,1),(2*Metre - 4, 2*
                     Metre - 3));
            
         else
            
               Draw_Line(Semafors(Id),(1,1),(2*Metre - 3,1));
               Draw_Line(Semafors(Id),(1,2*Metre - 4),(2*Metre - 3, 2*
                     Metre - 4));
            
         end if;
      end Actualitzarimatgesemafor;
      -- Reserva un nou Canvas per al vehicle que s'insertarà
      procedure Inserirvehicle (
            Id    : in     Integer;      
            Tipus : in     Ttipusvehicle ) is 
         Color : Colour_Type;  
      begin
         Vehicles(Id):= Canvas (Finestra, (0,0), Metre, Metre, Pintar);
         case Tipus is
            when Cotxe =>
               Color:=Blue;
            when Ciclomotor =>
               Color:=Yellow;
            when Camio =>
               Color:=Red;
            when Bicicleta =>
               Color:=Green;
            when Camio_Escombraries =>
               Color:=Magenta;
            when Camio_Grua =>
               Color:=Black;
         end case;
         Set_Colour(Vehicles(Id), Color);
         Save(Vehicles(Id));
      end Inserirvehicle;
      -- Reserva un nou Canvas per al nou semàfor
      procedure Inserirsemafor (
            Id : in     Integer;    
            C  : in     Tcoordenada ) is 
      begin
         Semafors(Id):= Canvas (Finestra, (C.X, C.Y), 2*Metre, 2*Metre,
            Pintar);
         Set_Colour(Semafors(Id), (212,208,200));
         Save(Semafors(Id));
         Actualitzarimatgesemafor(Id, True);
      end Inserirsemafor;
      -- Inicialitza els llistats de Canvas i crea la finestra de la simulació
      procedure Inicialitzar (
            T    : in     String;  
            Num  : in     Integer; 
            L    : in     Integer; 
            N    : in     Integer; 
            M    : in     Integer; 
            Nums : in     Integer  ) is 
      begin
         Numvehicles:= Num;
         Vehicles:= new Tllistavehicles(0..Numvehicles-1);
         Numsemafors:= Nums;
         Semafors:= new Tllistasemafors(0..Numsemafors-1);
         Finestra:= Frame (M*((L*Metre)+(2*Metre)) + 5 + (2*Metre), N*((L*
                  Metre)+(2*Metre)) + 25 + (2*Metre), T, Quit);
         Set_Origin(Finestra, (5,100));
         Superficie:= Canvas (Finestra, (0,0), 0, 0, Pintar);
         Set_Colour(Superficie, (212,208,200));
         Pintaredificis(N,M,L);
         Save(Superficie);
      end Inicialitzar;
   end Dibuixant;

end PaquetGrafic;