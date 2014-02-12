package Types is
   LARGEUR_ECRAN : constant Integer := 66;
   HAUTEUR_ECRAN : constant Integer := 20;
   EPAISSEUR_BORDURE : constant Integer := 2;
   HAUTEUR_BORDURE : constant Integer := 1;
   type Tab_Ecran is array(1..LARGEUR_ECRAN, 1..HAUTEUR_ECRAN) of Character;
   
   type Position is record
      X : Natural;
      Y : Natural;
   end record;
end Types;
