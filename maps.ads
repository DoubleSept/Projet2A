with Ada.Text_IO, Ada.Integer_Text_IO, Epreuves, Types, Ada.Strings.Unbounded, Affichage;
use Ada.Text_IO, Ada.Integer_Text_IO, Epreuves, Types, Ada.Strings.Unbounded, Affichage;

package Maps is
   Niveau_Inexistant : exception;
   Niveau_Inaccessible : exception;
   Niveaux : Pointeur_L_Epr;
   Ecran_Niveaux : Tab_Ecran := (others => (others=>' '));
   
   procedure Charger_Niveaux(Path : String);
   
   function Get_Niveau(Pos : Position) return Pointeur_Epr;
   
   procedure Finir_Niveau(Id : Integer);
   procedure Finir_Niveau(P_Epr : Pointeur_Epr);
   
   procedure Afficher_Carte;
   function Choix_Niveaux return Pointeur_Epr;
end Maps;
