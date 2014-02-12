package body Carte is
   
   --Fonction d'initialisation
   function Initialiser(Chemin_Fichier : String) return Carte is
      R_Carte : Carte;
      Temp_Pos : Position;
      Temp_Id : Integer;
      Temp_List_Epr : List_Epr;
   begin
      --Rajout d'une première épreuve
      Temp_Pos.X := 2;
      Temp_Pos.Y := 4;
      Temp_Id := 1;
      Ajouter_Epreuve(R_Carte.Liste_Epr, Temp_Pos, Temp_Id, Temp_List_Epr);
      Rendre_Accessible(Temp_Id);
      
      --Position départ
      R_Carte.Pos_Joueur := Temp_Pos;
      
      --Seconde Epreuve
      Temp_Id := Temp_Id + 1;
      Temp_Pos.X := 10;
      Temp_Pos.Y := 8;
      Ajouter_Epreuve(R_Carte.Liste_Epr, Temp_Pos, Temp_Id, Temp_List_Epr);
   end Initialiser;
   
   --Fonction renvoyant le tableau d'écran
   function Recuperer_Carte(S_Carte : Carte) return Tab_Ecran is
      R_Ecran : Tab_Ecran;
      L_Epr : Liste_Epr;
      Temp_Bool : Boolean;
      Temp_Pos : Position;
      Temp_Character : Character;
   begin
      --Le fond de carte (...Hatier LOL !)
      for X in Tableau'Range(1) loop
	 for Y in Tableau'Range(2) loop
	    R_Ecran(X, Y) := S_Carte.Ecran_Carte(X, Y);
	 end loop;
      end loop;
      
      --On réécrit les épreuves
      L_Epr := S_Carte.Epreuves;
      
      --Placement Des Cases épreuves
      while (L_Epr /= null) loop
	 --On modifie la case du tableau pour correspondre à l'état de la case
	 Temp_Pos := Get_Position(L_Epreuve.all.Epreuve);
	 if (Temp_Bool = Get_Accessible(L_Epreuve.all.Epreuve)) then
	    Temp_Character := 'o';
	 else
	    Temp_Character := 'X';
	 end if;
	 --On regarde si le joueur est la
	 if (Temp_Pos.X = S_Carte.Pos_Joueur.X and Temp_Pos.Y = S_Carte.Pos_Joueur.Y) then
	    Temp_Character := '#';
	 end if;
	      
	 --On remplace la case par sa valeur
	 R_Ecran(Temp_Pos.X, Temp_Pos.Y) := Temp_Character;
	 L_Epr := L_Epr.Suivant;	 
      end loop;
      
      return R_Ecran;
   end Recuperer_Carte;
   
