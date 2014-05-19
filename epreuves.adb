with Types, Listes_G, Ada.Text_IO, Ada.Unchecked_Deallocation, Ada.Strings.Unbounded, Ada.Strings.Fixed, Ada.Strings.Maps, Ada.Strings.Maps.Constants;
use Types, Ada.Text_IO, Ada.Strings.Unbounded;
  
package body Epreuves is
   procedure Free_L2_Epr is new Ada.Unchecked_Deallocation(Liste_Liste_Epr, Pointeur_L2_Epr);
   procedure Free_L_Epr is new Ada.Unchecked_Deallocation(Liste_Epr, Pointeur_L_Epr);
   procedure Free_Epr is new Ada.Unchecked_Deallocation(Epreuve, Pointeur_Epr);
   
   function To_String(E : Epreuve) return String is
   begin
      return("Epreuve n°" & Integer'Image(E.Caracs.Id) & " (" & Boolean'Image(E.Caracs.Accessible) & 
      ")\N###############\N" &
      "Successeurs : \N"); 
      --To_String(E.Predecesseurs));
   end To_String;
   
   -------------
   --Modifier l'épreuve
   procedure Initialiser(E : in out Epreuve) is
      L_Pred, L_Aux : Pointeur_L2_Epr;
   begin
      E.Caracs.Accessible := False;
      L_Pred := E.Predecesseurs;
      while L_Pred /= null loop
	 L_Aux := L_Pred.all.Suiv;
	 Free_L2_Epr(L_Pred);
	 L_Pred := L_Aux;
      end loop;	 
      E.Pos.X := 0;
      E.Pos.Y := 1;
   end Initialiser;
     
   procedure Set_Accessible(B : Boolean; E: in out Epreuve) is
   begin
      E.Caracs.Accessible := B;
   end Set_Accessible;
   
   procedure Placer(Pos : Position; E : in out Epreuve) is
   begin
      E.Pos := Pos;
   end Placer;
   
   ---------------------
   --Fonctions accès
   function GetPosition(E : Pointeur_Epr) return Position is
   begin
      return E.all.Pos;
   end GetPosition;
   
   function Get_Id(E : Pointeur_Epr) return Integer is
   begin
      return E.all.Caracs.Id;
   end Get_Id;
   
   function Get_Accessible(E : Pointeur_Epr) return Boolean is
   begin
      return E.all.Caracs.Accessible;
   end Get_Accessible;
   
   ---------------------
   --Fonctions d'ajout
   procedure Ajouter_Predecesseurs(L : Pointeur_L_Epr; L2 : in out Pointeur_L2_Epr) is
   begin
      if (L2 = null) then
	L2 := new Liste_Liste_Epr'(L, null);
      else
	 Ajouter_Predecesseurs(L, L2.Suiv);
      end if;
   end Ajouter_Predecesseurs;
   
   procedure Ajouter_Epreuve(E : Pointeur_Epr; L : in out Pointeur_L_Epr) is
   begin
      if (L = null) then
	L := new Liste_Epr'(E, null);
      else
	 Ajouter_Epreuve(E, L.all.Suiv);
      end if;
   end Ajouter_Epreuve;
   
   -------------------
   --Fonction d'initialisation
   procedure Vider_L_Epr(L : in out Pointeur_L_Epr) is     
      Suivant : Pointeur_L_Epr;
   begin
      while (L /= null) loop
	 Suivant := L.all.Suiv;
	 Free_Epr(L.all.Info);
	 Free_L_Epr(L);
	 L := Suivant;
      end loop;
   end Vider_L_Epr;
   
   procedure Vider_Epr(E : in out Pointeur_Epr) is
   begin
      Free_Epr(E);
   end Vider_Epr;
   
   function Creer_Epr(Id : Integer; Nom : Unbounded_String; Accessible, Termine : Boolean; Pos : Position; Pred : Pointeur_L2_Epr) return Epreuve is
      Caracs : Caracteristiques;
   begin
      Caracs := (Id, Nom, Accessible, Termine);
      return (Caracs, Pos, Pred);
   end Creer_Epr;
   
   -------------------------
   --Acces aux épreuves
   function Trouver_Par_Id(Id : in Integer; L : Pointeur_L_Epr) return Pointeur_Epr is
      Temp_L : Pointeur_L_Epr;
   begin
      Temp_L := L;
      while Temp_L /= null loop
	 if (Temp_L.all.Info.all.Caracs.Id = Id) then
	    return Temp_L.all.Info;
	 else
	    Temp_L := Temp_L.all.Suiv;
	 end if;
      end loop;
      --Si on n'a rien trouvé il y a un poblème
      raise Id_Inexistant;
   end Trouver_Par_Id;
   
  function Trouver_Par_Nom(Name : in String; L : Pointeur_L_Epr) return Pointeur_Epr is
     Temp_L : Pointeur_L_Epr;
     Temp_Name : String := Ada.Strings.Fixed.Translate(Name, Ada.Strings.Maps.Constants.Lower_Case_Map);
   begin
      Temp_L := L;
      while Temp_L /= null loop
	 if( Ada.Strings.Fixed.Translate(To_String(Temp_L.all.Info.all.Caracs.Nom), Ada.Strings.Maps.Constants.Lower_Case_Map) = Name) then
	    return Temp_L.all.Info;
	 else
	    Temp_L := Temp_L.all.Suiv;
	 end if;
      end loop;
      --Si on n'a rien trouvé il y a un poblème
      raise Id_Inexistant;
   end Trouver_Par_Nom; 
   
   procedure Epreuve_Finie(Checked : Pointeur_Epr; L : Pointeur_L_Epr) is
      Temp_L, Parcours_Serie : Pointeur_L_Epr := L;
      Temp_L2 : Pointeur_L2_Epr;
      
      --Quand on a trouvé une série ou Checked appartient, on veut vérifier qu'elle est complète
      Verif_Serie : Pointeur_L_Epr;
      Valides : Boolean := True;
   begin
      Checked.Caracs.Termine := True;
      while Temp_L /= null loop
	 --Pour chaque niveaux on regarde les listes de liste de prédécesseurs
	 Temp_L2 := Temp_L.all.Info.all.Predecesseurs;
	 while Temp_L2 /= null loop
	    --Pour chaque liste on parcourt les listes de prédecesseurs
	    Parcours_Serie := Temp_L2.all.Info;
	    while Parcours_Serie /= null loop
	       if Parcours_Serie.all.Info = Checked then
		  Valides := True;
		  Verif_Serie := Temp_L2.all.Info;
		  while Verif_Serie /= null and then Valides = True loop
		     Valides := Verif_Serie.all.Info.all.Caracs.Termine;
		     Verif_Serie := Verif_Serie.all.Suiv;
		  end loop;
		  --Si c'est bon, on rend l'épreuve accessible
		  if(Valides = True) then
		     Temp_L.Info.Caracs.Accessible := True;
		     exit; -- On passe à l'épreuve suivante
		  end if;
	       end if;
	       Parcours_Serie := Parcours_Serie.all.Suiv;
	    end loop;
	    Temp_L2 := Temp_L2.all.Suiv;
	 end loop;
	 Temp_L := Temp_L.all.Suiv;
      end loop;
   end Epreuve_Finie;
   
   --Fonctions affichage
   function L_Epr_To_String(L : Pointeur_L_Epr) return String is
      Temp_L : Pointeur_L_Epr;
      U_Str : Unbounded_String;
   begin
      Temp_L := L;
      while Temp_L /= null loop
	 Append(U_Str, "N°" & Integer'Image(Temp_L.all.Info.all.Caracs.Id));
	 Append(U_Str, "(Pos, x=" & Integer'Image(Temp_L.all.Info.all.Pos.X) & " y=" & Integer'Image(Temp_L.all.Info.all.Pos.Y) & ")");
	 Append(U_Str, " ; ");
	 --On passe au suivant
	 Temp_L := Temp_L.all.Suiv;
      end loop;
      return To_String(U_Str);
   end L_Epr_To_String;
   
   function L_Epr_To_Tab_Ecran(L : Pointeur_L_Epr) return Tab_Ecran is
      T_Renvoi : Tab_Ecran := (others => (others => ' '));
      Temp_L : Pointeur_L_Epr;
      C : Character;
   begin
      Temp_L := L;
      while Temp_L /= null loop
	 if(Temp_L.all.Info.all.Caracs.Accessible = True) then
	     if(Temp_L.all.Info.all.Caracs.Termine = True) then
	       C := '#';
	    else
	       C := 'O';
	     end if;
	     
	 else
	    C := 'X';
	 end if;
	 T_Renvoi(Temp_L.all.Info.all.Pos.X, Temp_L.all.Info.all.Pos.Y) := C;
	 --On passe au suivant
	 Temp_L := Temp_L.all.Suiv;
      end loop;
      return T_Renvoi;
   end L_Epr_To_Tab_Ecran;
   
   function P_Epr_To_String(Epr : Pointeur_Epr) return String is
      U_Str : Unbounded_String;
   begin
      Append(U_Str, "N°" & Integer'Image(Epr.all.Caracs.Id) & " - ");
      Append(U_Str, "(Pos, x=" & Integer'Image(Epr.all.Pos.X) & " y=" & Integer'Image(Epr.all.Pos.Y) & ")");
      
      --On regarde si l'épreuve est accessible
      if Epr.all.Caracs.Accessible = True then
	 Append(U_Str, " (Accessible) ");
      else
	 Append(U_Str, " (Non Accessible) ");
      end if;
      
      return To_String(U_Str);
   end P_Epr_To_String;
      
   
   procedure Affichage_Arbre(L : Pointeur_L_Epr; S_Esp : String) is
      Temp_L , Temp2_L: Pointeur_L_Epr;
      Temp_L2 : Pointeur_L2_Epr;
   begin
      Temp_L := L;
      while Temp_L /= null loop
	 Put(P_Epr_To_String(Temp_L.all.Info));
	 New_Line;
	 --Affichage des listes de prédecesseurs
	 Temp_L2 := Temp_L.all.Info.Predecesseurs;
	 while Temp_L2 /= null loop
	    --Affichage d'une liste
	    Temp2_L := Temp_L2.all.Info;
	    while Temp2_L /= null loop
	       Put(S_Esp & P_Epr_To_String(Temp2_L.all.Info));
	       Temp2_L := Temp2_L.all.Suiv;
	       New_Line;
	    end loop;
	    Put(S_Esp & "---");
	    New_Line; --On saute une ligne
	    Temp_L2 := Temp_L2.all.Suiv;
	 end loop;
	 Temp_L := Temp_L.all.Suiv;
      end loop;
   end Affichage_Arbre;
   
   
end Epreuves;
