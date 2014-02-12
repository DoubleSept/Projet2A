with Epreuve;
use Epreuve;

package Carte is
   --Type Carte
   type Carte is private;
   
   --Fonctions
   function Initialiser(Chemin_Fichier : String) return Carte; --Charge les épreuves et la carte depuis le fichier indiqué
   function Recuperer_Carte(S_Carte : Carte) return Tab_Ecran;
   procedure MaJ_Epreuves(S_Carte : in out Carte); --Vérifie les épreuves valider
   
private
   --Définitions du type carte
   type Carte is record
      Ecran_Carte : Tab_Ecran;
      Epreuves : Liste_Epr;
      Pos_Joueur : Position;
   end record;  
   
end Carte;
