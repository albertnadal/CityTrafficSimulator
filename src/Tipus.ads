package Tipus is

   type Tipusmotorgrafic is 
         (Metode_Directe,  
          Metode_Buffering); 
   type Ttipusvehicle is 
         (Cotxe,              
          Ciclomotor,         
          Camio,              
          Bicicleta,          
          Camio_Escombraries, 
          Camio_Grua); 
   type Ttipustram is 
         (Horitzontal, 
          Vertical); 
   type Tdesicio is 
         (Recte, 
          Girar); 
   type Ttipussentit is 
         (Est_Oest, 
          Oest_Est, 
          Nord_Sud, 
          Sud_Nord); 
   type Ttipuscarril is 
         (Esquerra, 
          Dret); 

   type Tcoordenada is 
      record 
         X : Integer;  
         Y : Integer;  
      end record; 

   type TVelocitats is 
      record 
         cotxe : Integer;
         ciclomotor : Integer;
         camio : Integer;
         bicicleta : Integer;
         camio_escombraries : Integer;
         camio_grua : Integer;
      end record; 

   type TDistancia is
      record
         cotxe : Integer;
         ciclomotor : Integer;
         camio : Integer;
         bicicleta : Integer;
      end record;

   type TDesviacio is
      record
         cotxe : Integer;
         ciclomotor : Integer;
         camio : Integer;
         bicicleta : Integer;
      end record;
   -- El tipus Item s'utilitza per a inserir elements a la cua
   type Item is 
      record 
         Object : Boolean;       -- True -> VEHICLE ; False -> SEMAFOR 
         Id     : Integer;       
         -- Identificador dins la taula de VEHICLES i de SEMAFORS 
         Tipus  : Ttipusvehicle; 
         -- En el cas de s�r un vehicle indica de quin tipus �s. 
         Pas    : Boolean;       
         -- En el cas de ser un sem�for Pas indicar� (True -> un sentit, False -> l'altre) 
         Coor   : Tcoordenada;   
         -- coordenada nova on ha d'anar l'objecte 
      end record;

   Metre : Integer := 5; -- Un metre -> 5 p�xels 
   BaseTemps: Duration := 1.0;  -- 20Km/h -> 1 segon de delay
   Velocitats: TVelocitats; -- Velocitats dels diferents tipus de vehicles
   Distancies: TDistancia;  -- Dist�ncies en metres ke delimiten el temps de vida mitg dels vehicles
   Desviacions: TDesviacio; -- Desviacions m�ximes en metres de les dist�ncies

end Tipus;