with Types, Ada.Text_IO, Ada.Unchecked_Deallocation, Ada.Strings.Unbounded;
use Types, Ada.Text_IO;

package Epreuves is
   --Exceptions
   Id_Inexistant : exception;
   
   --Type Epreuve
   type Epreuve is private;
   function To_String(E : Epreuve) return String;
   
   type Liste_Liste_Epr is private;
   type Pointeur_Epr is access Epreuve;
   
   type Liste_Epr;
   type Pointeur_L_Epr is access Liste_Epr;
   type Liste_Epr is record
      Info : Pointeur_Epr;
      Suiv : Pointeur_L_Epr;
   end record;
   type Pointeur_L2_Epr is access Liste_Liste_Epr;
   
   -------------
   --Modifier l'épreuve
   procedure Initialiser(E : in out Epreuve);
   procedure Set_Accessible(B : Boolean; E: in out Epreuve);
   procedure Placer(Pos : Position; E : in out Epreuve);
   
   --Accès
   function GetPosition(E : in Pointeur_Epr) return Position;
   function Get_Id(E : in Pointeur_Epr) return Integer;
   function Get_Accessible(E : in Pointeur_Epr) return Boolean;
   
   --Fonctions d'ajout
   procedure Ajouter_Predecesseurs(L : Pointeur_L_Epr; L2 : in out Pointeur_L2_Epr);
   procedure Ajouter_Epreuve(E : Pointeur_Epr; L : in out Pointeur_L_Epr);
   
   --Fonctions d'initialisations
   procedure Vider_L_Epr(L : in out Pointeur_L_Epr);
   procedure Vider_Epr(E : in out Pointeur_Epr);
   function Creer_Epr(Id : Integer; Nom : Ada.Strings.Unbounded.Unbounded_String; Accessible, Termine : Boolean; Pos : Position; Pred : Pointeur_L2_Epr) return Epreuve;
   
   --Accès aux épreuves
   function Trouver_Par_Id(Id : Integer; L : Pointeur_L_Epr) return Pointeur_Epr;
   function Trouver_Par_Nom(Name : in String; L : Pointeur_L_Epr) return Pointeur_Epr ;
   procedure Epreuve_Finie(Checked : Pointeur_Epr; L : Pointeur_L_Epr);
   
   --Fonctions affichage
   function L_Epr_To_String(L : Pointeur_L_Epr) return String;
   function L_Epr_To_Tab_Ecran(L : Pointeur_L_Epr) return Tab_Ecran;
   function P_Epr_To_String(Epr : Pointeur_Epr) return String;
   procedure Affichage_Arbre(L : Pointeur_L_Epr; S_Esp : String);
   --function L_Epr_To_String_Short(L : Pointeur_L_Epr) return String;
   
private
   ------------
   --Définitions
   type Caracteristiques is record --Les  caractéristiques propres à l'épreuves
      Id : Integer;
      Nom : Ada.Strings.Unbounded.Unbounded_String;
      Accessible : Boolean;
      Termine : Boolean;
   end record;
   
   --La définition des liste d'épreuvres et des listes de listes d'épreuves 
   
   type Liste_Liste_Epr is record
      Info : Pointeur_L_Epr;
      Suiv : Pointeur_L2_Epr;
   end record;
   
   type Epreuve is record -- Une epreuve
      Caracs : Caracteristiques;
      Pos : Position;
      Predecesseurs : Pointeur_L2_Epr;
   end record;
   
end Epreuves;
