with Tipus; use Tipus;

package TascaHistoric is

   task type Historial is
      entry Avis_Estat_Control_Transit(estat: boolean);
      entry Avis_Insersio_Vehicle(Tipus: Ttipusvehicle; quantitat: Integer);
      entry Avis_Vehicle_Espatllat(Tipus: Ttipusvehicle);
      entry Avis_Recorregut_Escombriaire_Iniciat;
      entry Avis_Recorregut_Escombriaire_Completat;
      entry Avis_Recorregut_Escombriaire_No_Completat;
      entry Avis_Grua_Busca_Vehicle;
      entry Avis_Grua_Troba_Vehicle;
      entry Avis_Grua_Deixa_Vehicle_Taller;
   end Historial;
   type PHistorial is access Historial;

end TascaHistoric;

