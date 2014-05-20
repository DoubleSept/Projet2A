with Types, Ada.Strings.Unbounded;
use Types, Ada.Strings.Unbounded;

package personnages is
   --Type Personnage
   type Personnage is private;
   PallierExp : Natural := 5000;
     
   --Fonctions Initialisation
   procedure Init_Perso(Perso : in out Personnage;Nom : P_String);
   
   --Fonctions d'accès
   function Nom(P : in Personnage) return String;
   function Vie(P : in Personnage) return Natural;
   function VieMax(P : in Personnage) return Natural;
   function Endurance(P : in Personnage) return Natural;
   function EnduMax(P : in Personnage) return Natural;
   
   --Fonctions de Niveaux
   procedure SubirDegats(Receveur : in out Personnage; PtsDegats : in Natural; Mort : out Boolean);
   procedure GagnerExp(PersoVict : in out Personnage; PersoDefait : in out Personnage);
   procedure GagnerExp(Perso : in out Personnage; Exp : Integer);
   procedure MonterNiveaux(Perso : in out Personnage);
   
   --Fonctions d'affichage
   function AfficherInventaire(Perso : in Personnage) return Tab_Ecran;
   procedure MenuInventaire(P : in out Personnage; Message_TS_Pere : out Unbounded_String);
   procedure MenuDepenserPoints(P : in out Personnage; Message_TS_Pere : out Unbounded_String);
   
private
   type Pers_Position is (Debout, Assis, Saut);
   type Personnage is record
      Nom : P_String;
      Niv, Exp, ExpSuivant : Natural;
      Vie, VieMax : Natural;
      Endurance, EnduMax : Natural;
      Force : Natural;
      Defense : Natural; --En pourcent
      PointsNiveaux : Natural;
      Arc : Boolean; --Si pas d'arc, c'est du CaC
   end record;
end personnages;
