with Types;
use Types;

package Epreuve is
   --Type Epreuve
   type Epreuve is private;
   type Liste_Epr is private;
   type Pointeur_Liste_Epr is access Liste_Epr;
   type Pointeur_Epr is access Epreuve;
   type Liste_Epr is record --Liste d'epreuves
      Epreuve : Pointeur_Epr;
      Suiv : Pointeur_Liste_Epr;
   end record;
   
   -------------
   --Fonctions sur les listes d'épreuves
   
   -------------
   --Fonctions sur les épreuves
   Function Chercher_Epreuve(Id_Recherche : Integer) return Pointeur_Epr;
   Procedure Valider_Epreuve(Epr : Epreuve); --Active les niveaux, sauve le score ...
   procedure Rendre_Accessible(Epr : Epreuve);
   
private
   ------------
   --Définitions
   type Caracteristiques is private; -- Les informations sur le niveau
      
   type Epreuve is record -- Une epreuve
      Caracs : Caracteristiques;
      Position : Position;
      Suivants : Liste_Epr;
   end record;
   
   type Caracteristiques is record --Les  caractéristiques propres à l'épreuves
      Id : Integer;
      Difficulte : Integer;
      Fini : Boolean;
      Accessible : Boolean;
   end record;
   
end Epreuve;
