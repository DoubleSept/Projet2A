with Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO, affichage;
use Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO, Affichage;

package body personnages is
   procedure Init_Perso(Perso : in out Personnage;Nom : P_String) is
   begin
      FreeStr(Perso.Nom);
      Perso.Nom := Nom;
      Perso.Niv := 0;
      Perso.Exp := 0;
      Perso.ExpSuivant := 5000;
      Perso.VieMax := 100;
      Perso.Vie := Perso.VieMax;
      Perso.EnduMax := 100;
      Perso.Endurance := Perso.EnduMax;
      Perso.Force := 100;
      Perso.Defense := 0;
      Perso.PointsNiveaux:=0;
      Perso.Arc:=False; --Si pas d'arc, c'est du CaC
   end Init_Perso;
      
   
   --Fonctions de Niveaux
   procedure GagnerExp(PersoVict : in out Personnage; PersoDefait : in out Personnage) is
   begin
      --On rajoute l'exp
      GagnerExp(PersoVict, PersoDefait.VieMax*PersoVict.Vie + PersoVict.Endurance*PersoVict.EnduMax);
   end GagnerExp;
   
   procedure GagnerExp(Perso : in out Personnage; Exp : Integer) is
   begin
      Perso.Exp := Perso.Exp + Exp;
      while Perso.Exp > Perso.ExpSuivant loop
	 MonterNiveaux(Perso);
      end loop;
   end GagnerExp;
   
   procedure MonterNiveaux(Perso : in out Personnage) is
   begin
      Perso.Niv := Perso.Niv+1;
      --Les rajouts par défaut
      Perso.PointsNiveaux := Perso.PointsNiveaux+1;
      
      --Calcul de l'exp du niveau suivant
      Perso.ExpSuivant := Perso.ExpSuivant + PallierExp + (PallierExp*Perso.Niv)/10;
      
      --On redonne la vie et l'endu
      Perso.Vie := Perso.VieMax;
      Perso.Endurance := Perso.EnduMax;
   end MonterNiveaux;
   
   --Fonctions d'accès
   function Nom(P : in Personnage) return String is
   begin
      return P.Nom.all;
   end Nom;
   
   function Vie(P : in Personnage) return Natural is
   begin
      return P.Vie;
   end Vie;
   
   function VieMax(P : in Personnage) return Natural is
   begin
      return P.VieMax;
   end VieMax;
   
   function Endurance(P : in Personnage) return Natural is
   begin
      return P.Endurance;
   end Endurance;
   
   function EnduMax(P : in Personnage) return Natural is
   begin
      return P.EnduMax;
   end EnduMax;

   ------------
   --FONCTIONS DE COMBATS
   
   procedure SubirDegats(Receveur : in out Personnage; PtsDegats : in Natural; Mort : out Boolean) is
   begin
      Receveur.Vie := Receveur.Vie - PtsDegats*(100-Receveur.Defense)/100;
      
      --On regarde si on est mort
      if Receveur.Vie <= 0 then
	 Receveur.Vie := 0;
	 Mort := True;
      end if;
   end SubirDegats;
   
   ----------------
   --FONCTIONS AFFICHAGE
   -----
   --Afficher l'inventaire
   function AfficherInventaire(Perso : in Personnage) return Tab_Ecran is
      T : Tab_Ecran := (others => (others => ' '));
      Pos_Temp : Position;
      S : P_String;
      X_Droite : Integer; --Emplacement du début de la colonne de droite
   begin
      --Le nom
      Pos_Temp.X := 2;
      Pos_Temp.Y := 2;
      S := new String'("Nom : ");
      Ecrire(Pos_Temp, S.all & Perso.Nom.all, T);
      
      --Traits
      X_Droite := (S.all'Length)+LONGUEUR_MAX_NOM+4; -- pour l'espace a gauche, un pour celui a droite, un pour le trait
      TraitVertical(X_Droite-1, T);
      TraitHorizontal(4, T, 1, X_Droite-1);
      
      --Les caracs
      
      FreeStr(S);
      S := new String'("Vie :");
      Pos_Temp.X := X_Droite;
      Pos_Temp.Y := Pos_Temp.Y+2;
      Ecrire(Pos_Temp, S.all, T);
      FreeStr(S);
      S := new String'(Integer'Image(Perso.Vie)&" /"&Integer'Image(Perso.VieMax));
      Pos_Temp.X := T'Last(1)-(S.all'Length);
      Ecrire(Pos_Temp, S.all, T);
      
      FreeStr(S);
      S := new String'("Endurance :");
      Pos_Temp.X := X_Droite;
      Pos_Temp.Y := Pos_Temp.Y+2;
      Ecrire(Pos_Temp, S.all, T);
      FreeStr(S);
      S := new String'(Integer'Image(Perso.Endurance)&" /"&Integer'Image(Perso.EnduMax));
      Pos_Temp.X := T'Last(1)-(S.all'Length);
      Ecrire(Pos_Temp, S.all, T);
      
      FreeStr(S);
      S := new String'("Force :");
      Pos_Temp.X := X_Droite;
      Pos_Temp.Y := Pos_Temp.Y+2;
      Ecrire(Pos_Temp, S.all, T);
      FreeStr(S);
      S := new String'(Integer'Image(Perso.Force));
      Pos_Temp.X := T'Last(1)-(S.all'Length);
      Ecrire(Pos_Temp, S.all, T);
      
      FreeStr(S);
      S := new String'("Defense :");
      Pos_Temp.X := X_Droite;
      Pos_Temp.Y := Pos_Temp.Y+2;
      Ecrire(Pos_Temp, S.all, T);
      FreeStr(S);
      S := new String'(Integer'Image(Perso.Defense));
      Pos_Temp.X := T'Last(1)-(S.all'Length);
      Ecrire(Pos_Temp, S.all, T);
		       
      --Les points restants
      Pos_Temp.Y := T'Last(2)-1;
      FreeStr(S);
      S := new String'("Vous avez" & Integer'Image(Perso.PointsNiveaux) & " points a depenser");
      Pos_Temp.X := T'Last(1)-(S.all'Length);
      Ecrire(Pos_Temp, S.all, T);
      
      --Les points d'experiences
      FreeStr(S);
      S := new String'("Niveau"&Integer'Image(Perso.Niv)&" :");
      Pos_Temp.X := X_Droite;
      Pos_Temp.Y := Pos_Temp.Y-2;
      Ecrire(Pos_Temp, S.all, T);
      FreeStr(S);
      S := new String'(Integer'Image(Perso.Exp)&" /"&Integer'Image(Perso.ExpSuivant));
      Pos_Temp.X := T'Last(1)-(S.all'Length);
      Ecrire(Pos_Temp, S.all, T);
      return T;
   end AfficherInventaire;
   
   procedure MenuInventaire(P : in out Personnage; Message_TS_Pere : out Unbounded_String) is
      Message_TS : Unbounded_String;
      Reponse : String(1..50);
      Last : Natural;
      Temp_Char : Character;
      Continuer : Boolean := True;
      Temp_Int : Integer;
   begin
      while Continuer loop
	 Afficher_Ecran(AfficherInventaire(P));
	 Put_Line(To_String(Message_TS));
	 Message_TS := To_Unbounded_String("");
	 Put_Line("[D]epenser vos points ou [Q]uitter");
	 Get(Temp_Char);
	 --On regarde le type de déplacement choisi
	 begin
	    case Temp_Char is
	       --Position
	       when 'Q' | 'q' =>
		  Continuer := False;
	       when '/' =>	
		  Get(Temp_Int);
		  GagnerExp(P, Temp_Int);
	       when 'D' | 'd' =>
		  if(P.PointsNiveaux > 0) then
		     MenuDepenserPoints(P, Message_TS);
		  else
		     Append(Message_TS, "Désolé, vous n'avez rien à dépenser");
		  end if;
	       when others => Append(Message_TS, "Commande inconnue");
	    end case;
	 exception
	    when others => Append(Message_TS, "Il y a une erreur !!!!!!");
	 end;
      end loop;
      Message_TS_Pere := Message_TS;
   end MenuInventaire;   
   
   procedure MenuDepenserPoints(P : in out Personnage; Message_TS_Pere : out Unbounded_String) is
      Message_TS : Unbounded_String;
      Reponse : String(1..50);
      Last : Natural;
      Temp_Char : Character;
      Continuer : Boolean := True;
      Temp_Int : Integer;
      PointDepense : Boolean;
   begin
      Message_TS := To_Unbounded_String("La joie du capitalisme");
      while Continuer and P.PointsNiveaux > 0 loop
	 Afficher_Ecran(AfficherInventaire(P));
	 Put_Line(To_String(Message_TS));
	 Message_TS := To_Unbounded_String("");
	 Put_Line("[V]ie, [E]ndurance, [F]orce, [D]efense, [R]ien ou [Q]uitter");
	 Get(Temp_Char);
	 --On regarde le type de déplacement choisi
	 begin
	    PointDepense := True; --Par defaut on compte le point
	    case Temp_Char is
	       --Position
	       when 'Q' | 'q' =>
		  Continuer := False;
		  PointDepense := False;
		  Append(Message_TS, "Voyons, il vous reste des points a dépenser !"); 
	       when 'D'|'d' =>
		  if(P.Defense < 75) then
		     P.Defense := P.Defense+5;
		     Append(Message_TS, "Et hop, plus de défense qu'un éléphant"); 
		  else
		     Append(Message_TS, "Tu es déjà bien assez costaud !");
		     PointDepense:=False;
		  end if;
	       when 'V' | 'v' =>
		  P.VieMax := P.VieMax + 5*P.Vie/100;
		  Append(Message_TS, "Vous respirez la vitalité");
	       when 'E' | 'e' =>
		  P.EnduMax := P.EnduMax + 10;
		  Append(Message_TS, "Vous voilà habillé pour l'hiver ! (Ce message est complètement hors contexte)");
	       when 'F' | 'f' =>
		  P.Force := P.Force + 10*P.Force/100;
		  Append(Message_TS, "Mmmm... que du muscle !");
	       when 'R' | 'r' =>
		  Append(Message_TS, "Joli moyen de perdre un point !");	  
	       when others => 
		  PointDepense := False;
		  Append(Message_TS, "... ?");
	    end case;
	    
	    if(PointDepense = True) then
	       P.PointsNiveaux := P.PointsNiveaux-1;
	    end if;
	 exception
	    when others => Append(Message_TS, "Il y a une erreur !!!!!!");
	 end;
      end loop;
      Message_TS_Pere := Message_TS;
   end MenuDepenserPoints;   
   
end personnages;
