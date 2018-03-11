with Random_Generic;
with PaquetGrafic;
use PaquetGrafic;
with QueueArray;
use QueueArray;
with Tipus;
use Tipus;
with TascaHistoric;
use TascaHistoric;

package ElementsSistema is

   type Grua;
   type Control;
   type Tram;
   type Parellsemafor;
   
   type Pgrua is access Grua;
   type Pcontrol is access Control; 
   type Pparellsemafor is access Parellsemafor; 
   type Ptram is access Tram; 

   type Tcarril is array (Integer range <>) of Boolean; 
   type Ptcarril is access Tcarril; 

   type Truta is array (Integer range <>) of Tdesicio; 
   type Ptruta is access Truta; 

   type TMatriuTrams is array(Integer  range <>, Integer  range <>) of PTram;
   type PTMatriuTrams is access TMatriuTrams;
   type TMatriuParellSemafors is array(Integer  range <>, Integer  range <>) of PParellSemafor;
   type PTMatriuParellSemafors is access TMatriuParellSemafors;

   TramsHoritzontals: PTMatriuTrams;
   TramsVerticals: PTMatriuTrams;
   Semafors: PTMatriuParellSemafors;
   
   subtype Trangdesicions is Positive range 1..100;
   package Presadesicio is new Random_Generic (Result_Subtype => Trangdesicions);

   subtype Trangdesviacio is Positive range 1..100;
   package Paquetdesviacio is new Random_Generic (Result_Subtype => Trangdesviacio);

   protected type Tram is
      procedure Inicialitzar (
            T    : in     Ttipustram;     
            S    : in     Ttipussentit;   
            Sem  : in     Pparellsemafor; 
            Long : in     Natural;        
            C    : in     Tcoordenada;
            A    : in     Tcoordenada     );
      procedure AlliberarPosicio(Pos: in Integer; Carril: in Ttipuscarril);
      function ObtenirTipusTram return TtipusTram;
      procedure Obtenirseguentposicio (
            Pos       : in out Integer;        
            Carril    : in out Ttipuscarril;
            C         :    out Tcoordenada;    
            Fitram    : in out Boolean;        
            Migtram   :    out Boolean;        
            Sem       :    out Pparellsemafor; 
            Tipustram :    out Ttipustram      );
      function ObtenirAdreça return TCoordenada;
      procedure Demanarsituarsealcarrilesquerra (
            Pos    : in out Integer;     
            C      :    out Tcoordenada; 
            Carril : in out Ttipuscarril ); 
   private
      Sentit: Ttipussentit;
      Tipus: Ttipustram;
      Longitud: Natural;
      Carrildret: Ptcarril;
      Carrilesquerra: Ptcarril;
      Semafor: Pparellsemafor;
      Posicio: Tcoordenada;
      Adreça:  Tcoordenada;
   end Tram;

   protected type Parellsemafor is
      procedure Activarmodefluidesa; 
      procedure Desactivarmodefluidesa; 
      entry Demanarpasvertical (
            Des : in     Tdesicio; 
            T :    out Ptram     ); 
      entry Demanarpashoritzontal (
            Des : in     Tdesicio; 
            T :    out Ptram     ); 
      procedure Obtenirnumerovehiclesenespera (
            H :    out Integer; 
            V :    out Integer  ); 
      procedure Inicialitzar (
            Ident : in     Integer;         
            Tv    : in     Ptram;           
            Th    : in     Ptram;           
            Dib   : in     Pdibuixant;      
            Cua   : in     Pqueue;          
            Tmg   :        Tipusmotorgrafic ); 
      procedure Canviartorn; 
   private
      C: Pqueue;
      Id: Integer;
      Torn: Boolean;
      Tramvertical: Ptram;
      Tramhoritzontal: Ptram;
      D: Pdibuixant;
      Motorgrafic: Tipusmotorgrafic;
      Mode_Fluidesa: Boolean;
   end Parellsemafor;

   task type Timerparellsemafor(S: Pparellsemafor; Tsem: Integer; uts: Integer);
   type Ptimerparellsemafor is access Timerparellsemafor; 

   task type Vehicle(Id: Integer; D: Pdibuixant; T: Ptram; Tipus: Ttipusvehicle; Q: Pqueue; Motorgrafic: Tipusmotorgrafic; probabilitat: integer; control_transit: Pcontrol; loger: PHistorial; uts: Integer);
   type Pvehicle is access Vehicle; 

   task type Camioescombraries(Id: Integer; D: Pdibuixant; T: Ptram; Q: Pqueue; Motorgrafic: Tipusmotorgrafic; M: Integer;
      N: Integer; Tce: Integer; Xce: Integer;loger: PHistorial;uts: integer);
   type Pcamioescombraries is access Camioescombraries;

   task type Grua (Id: integer; D: Pdibuixant; T: Ptram; Q: Pqueue; tmg: Tipusmotorgrafic; p: Integer; M: integer; N: integer; loger: PHistorial; uts: Integer) is
      entry Indicar_Control_Transit(control_transit: Pcontrol);
      entry Anar_a_Buscar_Cotxe_Espatllat(Id: Integer; Tipus: Ttipusvehicle;  T: Ptram; Pos: Integer; Carril: Ttipuscarril; TipusTram: TtipusTram);
   end Grua;

   task type Control (Semafors: Ptmatriuparellsemafors; M: Integer; N: Integer; vehicle_grua: Pgrua; loger: PHistorial) is
      entry Avis_Grua_Disponible;
      entry Despatxar_Vehicle_Espatllat(Id: Integer; Tipus: Ttipusvehicle;  T: Ptram; Pos: Integer; Carril: Ttipuscarril; TipusTram: TtipusTram);
      entry ObtenirNumeroVehiclesEspatllats(NumVehicles: out Integer);
      entry Activar_Control; 
      entry Desactivar_Control; 
   end Control;

end ElementsSistema;