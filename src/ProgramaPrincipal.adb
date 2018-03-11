with Jewl.Simple_Windows;
use  Jewl.Simple_Windows;
with ElementsSistema;
use ElementsSistema;
with PaquetGrafic;
use PaquetGrafic;
with MapeigEntorn;
use MapeigEntorn;
with QueueArray;
use QueueArray;
with Tipus;
use Tipus;
with Tascapintora;
use Tascapintora;
with Controlmenu;
use Controlmenu;
with Controlindicadors;
use Controlindicadors;
with TascaHistoric;
use TascaHistoric;

procedure Prova is 
   -- Menú inicial
   procedure Menuinici (
         Ncotxes  :    out Integer;          
         Nmotos   :    out Integer;          
         Ncamions :    out Integer;          
         Nbicis   :    out Integer;          
         M        :    out Integer;          
         N        :    out Integer;          
         Llarg    :    out Integer;          
         P        :    out Integer;          
         Tmg      :    out Tipusmotorgrafic; 
         Xce      :    out Integer;          
         Tce      :    out Integer;
         Tsem     :    out Integer;
         uts      :    out Integer) is 
      F   : Frame_Type   := Frame (640, 500, "Configuració", 'Q', Font ("Arial", 9, Bold => True));  
      L1  : Label_Type   := Label (F, (10, 12), 0, 20, "Nombre de carrers verticals:", Left);  
      Eb1 : Editbox_Type := Editbox (F, (180, 10), 30, 20, "4");  

      L2  : Label_Type   := Label (F, (10, 37), 0, 20, "Nombre de carrers horitzontals:", Left);  
      Eb2 : Editbox_Type := Editbox (F, (200, 35), 30, 20, "4");  

      L3  : Label_Type   := Label (F, (10, 62), 0, 20, "Distància entre cruïlla i cruïlla(en metres):", Left);  
      Eb3 : Editbox_Type := Editbox (F, (257, 60), 30, 20, "10");  

      P1  : Panel_Type   := Panel (F, (10, 92), 300, 120, "Dades dels cotxes", Font ("Arial", 11, Bold => True));  
      L4  : Label_Type   := Label (F, (25, 112), 130, 13, "Nombre de cotxes:", Left);  
      Eb4 : Editbox_Type := Editbox (F, (150, 110), 40, 20, "5");  
      L5  : Label_Type   := Label (F, (25, 137), 130, 13, "Velocitat(Km/h):", Left);  
      Eb5 : Editbox_Type := Editbox (F, (150, 135), 40, 20, "15");
      L20  : Label_Type   := Label (F, (25, 162), 225, 20, "Distància mitjana de vida útil(m):", Left);  
      Eb20 : Editbox_Type := Editbox (F, (240, 160), 55, 20, "1000");  
      L21  : Label_Type   := Label (F, (25, 187), 225, 20, "Desviació màxima de la mitjana(m):", Left);  
      Eb21 : Editbox_Type := Editbox (F, (240, 185), 55, 20, "200");  

      P2  : Panel_Type   := Panel (F, (10, 220), 300, 120, "Dades dels camions", Font ("Arial", 11, Bold => True));  
      L6  : Label_Type   := Label (F, (25, 240), 130, 13, "Nombre de camions:", Left);  
      Eb6 : Editbox_Type := Editbox (F, (150, 238), 40, 20, "5");  
      L7  : Label_Type   := Label (F, (25, 265), 130, 13, "Velocitat(Km/h):", Left);  
      Eb7 : Editbox_Type := Editbox (F, (150, 263), 40, 20, "10");
      L24  : Label_Type   := Label (F, (25, 290), 225, 20, "Distància mitjana de vida útil(m):", Left);  
      Eb24 : Editbox_Type := Editbox (F, (240, 288), 55, 20, "1000");  
      L25  : Label_Type   := Label (F, (25, 315), 225, 20, "Desviació màxima de la mitjana(m):", Left);  
      Eb25 : Editbox_Type := Editbox (F, (240, 313), 55, 20, "200");  

      P3  : Panel_Type   := Panel (F, (320, 92), 300, 120, "Dades dels ciclomotors", Font ("Arial", 11, Bold => True));  
      L8  : Label_Type   := Label (F, (335, 112), 140, 13, "Nombre de ciclomotors:", Left);  
      Eb8 : Editbox_Type := Editbox (F, (485, 110), 40, 20, "5");  
      L9  : Label_Type   := Label (F, (335, 137), 130, 13, "Velocitat(Km/h):", Left);  
      Eb9 : Editbox_Type := Editbox (F, (485, 135), 40, 20, "20");
      L22  : Label_Type   := Label (F, (335, 162), 225, 20, "Distància mitjana de vida útil(m):", Left);  
      Eb22 : Editbox_Type := Editbox (F, (555, 160), 55, 20, "1000");  
      L23  : Label_Type   := Label (F, (335, 187), 225, 20, "Desviació màxima de la mitjana(m):", Left);  
      Eb23 : Editbox_Type := Editbox (F, (555, 185), 55, 20, "200"); 

      P4   : Panel_Type   := Panel (F, (320, 220), 300, 120, "Dades de les bicicletes", Font ("Arial", 11, Bold => True));  
      L10  : Label_Type   := Label (F, (335, 240), 140, 13, "Nombre de bicicletes:", Left);  
      Eb10 : Editbox_Type := Editbox (F, (470, 238), 40, 20, "5");  
      L11  : Label_Type   := Label (F, (335, 265), 130, 13, "Velocitat(Km/h):", Left);  
      Eb11 : Editbox_Type := Editbox (F, (470, 263), 40, 20, "5");
      L26  : Label_Type   := Label (F, (335, 290), 225, 20, "Distància mitjana de vida útil(m):", Left);  
      Eb26 : Editbox_Type := Editbox (F, (555, 288), 55, 20, "1000");  
      L27  : Label_Type   := Label (F, (335, 315), 225, 20, "Desviació màxima de la mitjana(m):", Left);  
      Eb27 : Editbox_Type := Editbox (F, (555, 313), 55, 20, "200"); 

      L12  : Label_Type   := Label (F, (320, 12), 0, 20, "Unitats de temps per segon(UTS):", Left);  
      Eb12 : Editbox_Type := Editbox (F, (520, 10), 40, 20, "1");  

      L13  : Label_Type   := Label (F, (320, 37), 0, 20, "Probabilitat de seguir recte en una cruïlla(%):", Left);  
      Eb13 : Editbox_Type := Editbox (F, (580, 35), 40, 20, "50");

      L16  : Label_Type   := Label (F, (320, 62), 0, 20, "Píxels per metre:", Left);  
      Eb16 : Editbox_Type := Editbox (F, (430, 60), 30, 20, "5");   

      P5  : Panel_Type       := Panel (F, (320, 350), 247, 75, "Motor de l'entorn gràfic", Font ("Arial", 11, Bold => True));  
      Rb1 : Radiobutton_Type := Radiobutton (F, (325, 370), 220, 20, "Esdeveniments pintats al moment", True, Font ("Arial", 9, Bold => True));  
      Rb2 : Radiobutton_Type := Radiobutton (F, (325, 395), 200, 20, "Basat en el sistema de buffering", False, Font ("Arial", 9, Bold => True));  

      L17  : Label_Type   := Label (F, (10, 350), 300, 20, "Periode del camió d'escombraries(ms):", Left);  
      Eb17 : Editbox_Type := Editbox (F, (248, 348), 60, 20, "60000");

      L18  : Label_Type   := Label (F, (10, 380), 300, 20, "Temps aturat camió d'escombraries(ms):", Left);  
      Eb18 : Editbox_Type := Editbox (F, (248, 378), 50, 20, "2000");

      L19  : Label_Type   := Label (F, (10, 410), 300, 20, "Periode dels semàfors(ms):", Left);  
      Eb19 : Editbox_Type := Editbox (F, (175, 408), 50, 20, "4000");

      A : Button_Type := Button (F, (450, 440), 80, 25, "Sobre...", 'A');
      B : Button_Type := Button (F, (540, 440), 80, 25, "Iniciar", 'X');

   begin
      Set_Origin(F,(5,5));

      loop
         case Next_Command is
            when 'A' => Show_Message ("Autors:  Albert Nadal G.  &  Xavier Estellé L.   [ Maig de 2004 ]", "Sobre..."); 
            when 'X' =>
               exit;
            when others =>
               null;
         end case;
      end loop;

      M := Integer'Value(Get_Text(Eb1));
      N := Integer'Value(Get_Text(Eb2));
      Llarg := Integer'Value(Get_Text(Eb3));
      P := Integer'Value(Get_Text(Eb13));
      Ncotxes := Integer'Value(Get_Text(Eb4));
      Nmotos := Integer'Value(Get_Text(Eb8));
      Ncamions := Integer'Value(Get_Text(Eb6));
      Nbicis := Integer'Value(Get_Text(Eb10));
      Tce := Integer'Value(Get_Text(Eb17));
      Xce := Integer'Value(Get_Text(Eb18));
      Tsem := Integer'Value(Get_Text(Eb19));
      uts := Integer'Value(Get_Text(Eb12));
      metre := Integer'Value(Get_Text(Eb16));
      velocitats.cotxe := Integer'Value(Get_Text(Eb5));
      velocitats.camio := Integer'Value(Get_Text(Eb7));
      velocitats.ciclomotor := Integer'Value(Get_Text(Eb9));
      velocitats.bicicleta := Integer'Value(Get_Text(Eb11));
      velocitats.camio_escombraries := velocitats.camio;
      velocitats.camio_grua := velocitats.camio;
      Distancies.cotxe:= Integer'Value(Get_Text(Eb20));
      Desviacions.cotxe:= Integer'Value(Get_Text(Eb21));
      Distancies.camio:= Integer'Value(Get_Text(Eb24));
      Desviacions.camio:= Integer'Value(Get_Text(Eb25));
      Distancies.ciclomotor:= Integer'Value(Get_Text(Eb22));
      Desviacions.ciclomotor:= Integer'Value(Get_Text(Eb23));
      Distancies.bicicleta:= Integer'Value(Get_Text(Eb26));
      Desviacions.bicicleta:= Integer'Value(Get_Text(Eb27));

      if Get_State(Rb1) then
         Tmg:=Metode_Directe;
      else
         Tmg:=Metode_Buffering;
      end if;

   end Menuinici;

   C               : Pvehicle;  
   D               : Pdibuixant;  
   Paint           : Ppintor;  
   Cua             : Pqueue;  
   Tmg             : Tipusmotorgrafic;  
   Cmenu           : Ptascacontrolmenu;  
   Cindica         : Ptascacontrolindicadors;  
   Ncotxes,  
   Nmotos,  
   Ncamions,  
   Nbicis,  
   M,  
   N,  
   Llarg,  
   P,  
   Id              : Integer:=0;  
   Escombriaire    : Pcamioescombraries; 
   G               : Pgrua;
   Control_Transit : Pcontrol;  
   Xce             : Integer;  
   Tce             : Integer;  
   Tsem            : Integer;
   uts             : Integer;
   loger           : PHistorial;
begin
   -- En primer lloc demanem les dades de configuració 
   Menuinici (Ncotxes,Nmotos,Ncamions,Nbicis,M,N,Llarg,P,Tmg,Xce,Tce, Tsem, Uts);
   -- Crea una cua de elements per pintar
   Cua:= new Queue;
   -- Crea els Trams
   Creartrams(M, N);
   -- Crea els Semàfors
   Crearsemafors(M, N, Cua, Tsem, Uts);
   -- Crea l'objecte Dibuixant que pinta esdeveniments
   D:= new Dibuixant;
   -- Crea la finestra de simulació
   D.Inicialitzar("Simulació", 200, Llarg, N, M, 100);
   -- Inicialitza els Trams i els Semàfors
   Inicialitzar_Trams_I_Semafors(M, N, Llarg, D, Cua, Tmg);
   -- Fa d'intermediari entre la cua i el Dibuixant
   Paint:= new Pintor(D, Cua);
   -- Crea la tasca que mostra el historial mitjançant una finestra
   Loger := new Historial;
   -- Reserva un Canvas per a la Grua
   D.Inserirvehicle(Id, Camio_Grua);
   -- Crea la tasca Grua
   G := new Grua(Id, D, Tramshoritzontals(0,0), Cua, Tmg, P,M, N,Loger,Uts);
   -- Crea la tasca Control de Trànsit
   Control_Transit := new Control(Semafors,M,N,G,Loger);
   -- Indica a la Grua el Control de Trànsit que té associat
   G.Indicar_Control_Transit(Control_Transit);
   -- Crea la tasca dels Indicadors de fluïdessa
   Cindica := new Tascacontrolindicadors(Semafors, M, N, control_transit);

   -- incrementem l'indentificador del vehicle
   Id:=Id+1;
   -- Reserva un Canvas per al Camió d'escombreries
   D.Inserirvehicle(Id, Camio_Escombraries);
   -- Crea el Camió d'escombreries
   Escombriaire := new Camioescombraries(Id, D, Tramsverticals(0,0), Cua, Tmg, M, N, Tce, Xce,loger,uts);
   Id:=Id+1;
   -- Crea els vehicles de tipus cotxe 1 a 1
   for I in 1..Ncotxes loop
      D.Inserirvehicle(Id, Cotxe);
      C := new Vehicle(Id, D, Tramshoritzontals(0,0), Cotxe, Cua, Tmg, p, Control_Transit,loger,uts);
      Id:=Id+1;
      delay(0.5/uts); -- Fem una espera per a que no surtin tots alhora
   end loop;
   -- Avisar a la tasca Historial la insersió dels vehicles
   loger.Avis_Insersio_Vehicle(Cotxe, Ncotxes);
   -- Crea els vehicles de tipus ciclomotor 1 a 1
   for I in 1..Nmotos loop
      D.Inserirvehicle(Id, ciclomotor);
      C := new Vehicle(Id, D, Tramshoritzontals(0,0), ciclomotor, Cua, Tmg, p, Control_Transit,loger,uts);
      Id:=Id+1;
      delay(0.5/uts);
   end loop;
   -- Avisar a la tasca Historial la insersió dels vehicles
   loger.Avis_Insersio_Vehicle(ciclomotor, Nmotos);
   -- Crea els vehicles de tipus camió 1 a 1
   for I in 1..Ncamions loop
      D.Inserirvehicle(Id, camio);
      C := new Vehicle(Id, D, Tramshoritzontals(0,0), camio, Cua, Tmg, p, Control_Transit,loger,uts);
      Id:=Id+1;
      delay(0.5/uts);
   end loop;
   -- Avisar a la tasca Historial la insersió dels vehicles
   Loger.Avis_Insersio_Vehicle(Camio, Ncamions);
   -- Crea els vehicles de tipus bicicleta 1 a 1
   for I in 1..Nbicis loop
      D.Inserirvehicle(Id, bicicleta);
      C := new Vehicle(Id, D, Tramshoritzontals(0,0), bicicleta, Cua, Tmg, p, Control_Transit,loger,uts);
      Id:=Id+1;
      delay(0.5/uts);
   end loop;
   -- Avisar a la tasca Historial la insersió dels vehicles
   loger.Avis_Insersio_Vehicle(bicicleta, Nbicis);
   -- Crea la tasca de Control Menú
   Cmenu := new Tascacontrolmenu(Id, D, Cua, Tramshoritzontals(0,0), p,Tmg, Control_Transit,loger,uts);
end Prova;