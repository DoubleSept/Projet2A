with Ada.Text_IO, Ada.Integer_Text_IO, Epreuves, Types, Ada.Strings.Unbounded, Affichage;
use Ada.Text_IO, Ada.Integer_Text_IO, Epreuves, Types, Ada.Strings.Unbounded, Affichage;

package body  Maps is
   
   procedure Charger_Niveaux(Path : String) is
      Fichier : File_Type;
      Temp_Pos : Position;
      Temp_Int, Temp_Id : Integer;
      Temp_Liste : Pointeur_L_Epr;
      Temp_Liste_2 : Pointeur_L2_Epr;
      Temp_Epr : Pointeur_Epr;
      Temp_Char : Character;
      Temp_Name : Unbounded_String;
   begin
      Vider_L_Epr(Niveaux);
      
      --Chargement des niveaux
      Open(Fichier, In_File, Path & ".map");
      while not End_Of_File(Fichier) loop
	 Temp_Epr := null;
	 Temp_Liste_2 := null;
	 Get(Fichier, Temp_Id); --Numéro de l'épreuve
	 Skip_Line(Fichier);
	 --Chargement du nom de l'epreuve
	 Temp_Name := To_Unbounded_String(Get_Line(Fichier));
	 --Chargement de la position
	 Get(Fichier, Temp_Pos.X);
	 Get(Fichier, Temp_Pos.Y);
	 Skip_Line(Fichier);
	 while not End_Of_Line(Fichier) loop--On regarde si ce n'est pas une ligne vide;
	    Temp_Liste := null;
	    while not End_Of_Line(Fichier) loop -- On a joute chaque épreuve de la liste
	       Get(Fichier, Temp_Int);
	       Temp_Epr := Trouver_Par_Id(Temp_Int, Niveaux);
	       Ajouter_Epreuve(Temp_Epr, Temp_Liste);
	    end loop;
	    Ajouter_Predecesseurs(Temp_Liste, Temp_Liste_2);
	    if not End_Of_File(Fichier) then
	       Skip_Line(Fichier); -- Passage a la ligne suivante
	    end if;
	 end loop;
	 Ajouter_Epreuve(new Epreuve'(Creer_Epr(Temp_Id, Temp_Name, False, False, Temp_Pos, Temp_Liste_2)), Niveaux);
      end loop;
      Close(Fichier);
      
      --Chargement de l'apparence de la carte
      Open(Fichier, In_File, Path & ".map-apparence");
      Skip_Line(Fichier);
      for Y in Ecran_Niveaux'Range(2) loop
	 --A chaque ligne
	 Get(Fichier, Temp_Char);
	 for X in Ecran_Niveaux'Range(1) loop
	    Get(Fichier, Temp_Char);
	    Ecran_Niveaux(X,Y) := Temp_Char;
	 end loop;
	 Skip_Line(Fichier);
      end loop;
      Close(Fichier);
      
      Set_Accessible(True, Niveaux.all.Info.all); -- On rend la première accessible
   exception
      when Epreuves.Id_Inexistant => Put_Line("INEXISTANT (" & Integer'Image(Temp_Int) &") => " & L_Epr_To_String(Niveaux));
   end Charger_Niveaux;
   
   function Get_Niveau(Pos : Position) return Integer is
      Temp_L : Pointeur_L_Epr := Niveaux;
      Renvoi : Pointeur_Epr := null;
   begin
      while Temp_L /= null loop
	 if(GetPosition(Temp_L.all.Info) = Pos) then
	    Renvoi := Temp_L.all.Info;
	    exit;
	 end if;
	 Temp_L := Temp_L.all.Suiv;
      end loop;
      if(Renvoi = null) then
	raise Niveau_Inexistant;
      end if;
      return Get_Id(Renvoi);
   end Get_Niveau;
   
   function Get_Niveau(Nom : String) return Integer is
      Temp_L : Pointeur_L_Epr := Niveaux;
      Renvoi : Pointeur_Epr := null;
   begin
      Renvoi := Trouver_Par_Nom(Nom, Niveaux);
      if(Renvoi = null) then
	raise Niveau_Inexistant;
      end if;
      return Get_Id(Renvoi);
   end Get_Niveau;
   
   procedure Afficher_Carte(Largeur_Trait : Integer) is
   begin
      Afficher_Ecran((L_Epr_To_Tab_Ecran(Niveaux)+Ecran_Niveaux) , Largeur_Trait);
   end Afficher_Carte;
   
   procedure Finir_Niveau(Id : Integer) is
   begin
      if Get_Accessible(Trouver_Par_Id(Id, Niveaux)) then
	 Epreuve_Finie(Trouver_Par_Id(Id, Niveaux), Niveaux);
      else
	 raise Niveau_Inaccessible;
      end if;
   end Finir_Niveau;
   
begin
   Charger_Niveaux("test");
   Affichage_Arbre(Niveaux, "   ");
   New_Line;
   Afficher_Ecran(L_Epr_To_Tab_Ecran(Niveaux), 2);
   New_Line;
   Put_Line("On rend la première épreuve accessible");
   Set_Accessible(True, Niveaux.all.Info.all);
   Afficher_Ecran(L_Epr_To_Tab_Ecran(Niveaux), 2);
   Put_Line("On termine la première");
   Epreuve_Finie(Niveaux.all.Info, Niveaux);
   Afficher_Ecran(L_Epr_To_Tab_Ecran(Niveaux), 2);
end Maps;
