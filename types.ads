with Ada.Unchecked_Deallocation;

package Types is
   LARGEUR_ECRAN : constant Integer := 66;
   HAUTEUR_ECRAN : constant Integer := 20;
   EPAISSEUR_BORDURE : constant Integer := 2;
   HAUTEUR_BORDURE : constant Integer := 1;
   LONGUEUR_MAX_NOM : constant Integer := 20;
   
   type Tableau_Int is array (Integer range<>, Integer range<>) of Integer;
   type Tab_Ecran is array(1..LARGEUR_ECRAN, 1..HAUTEUR_ECRAN) of Character;
   type P_String is access String;
   procedure FreeStr is new Ada.Unchecked_Deallocation(String, P_String);
   
   type Position is record
      X : Natural;
      Y : Natural;
   end record;
   
   function "="(P1 , P2 : Position) return Boolean;
   function "+"(T1, T2 : Tab_Ecran) return Tab_Ecran;
   procedure Ecrire(PDeb : Position; S : String; T : in out Tab_Ecran);
   procedure TraitVertical(X : Integer; T : in out Tab_Ecran);
   procedure TraitHorizontal(Y : Integer; T : in out Tab_Ecran; XDeb : in Integer := 1; XFin : in Integer := LARGEUR_ECRAN);
   
end Types;
