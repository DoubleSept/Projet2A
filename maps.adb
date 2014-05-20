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
   
   function Get_Niveau(Pos : Position) return Pointeur_Epr is
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
      return Renvoi;
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
   
   procedure Finir_Niveau(Id : Integer) is
   begin
      if Get_Accessible(Trouver_Par_Id(Id, Niveaux)) then
	 Epreuve_Finie(Trouver_Par_Id(Id, Niveaux), Niveaux);
      else
	 raise Niveau_Inaccessible;
      end if;
   end Finir_Niveau;
   
   procedure Finir_Niveau(P_Epr : Pointeur_Epr) is
   begin
      Finir_Niveau(Get_Id(P_Epr));
   end Finir_Niveau;
   
   --FONCTIONS D'AFFICHAGE
   
   procedure Afficher_Carte is
   begin
      Afficher_Ecran((L_Epr_To_Tab_Ecran(Niveaux)+Ecran_Niveaux));
   end Afficher_Carte;
   
   function Choix_Niveaux return Pointeur_Epr is
      P_Epr : Pointeur_Epr := null;
      Choisi : Boolean := False;
      Message_TS : Unbounded_String;
      Reponse : String(1..50);
      Last : Natural;
      Temp_Int_1, Temp_Int_2 : Integer;
      Temp_Pos : Position;
      Temp_Char : Character;
   begin
      while not Choisi loop
	 Afficher_Carte;
	 Put_Line(To_String(Message_TS));
	 Message_TS := To_Unbounded_String("");
	 Put_Line("Choisir un niveau par [N]om, [P]osition ou Nu[M]éro ?");
	 Get(Temp_Char);
	 --On regarde le type de déplacement choisi
	 begin
	 case Temp_Char is
	    --Position
	    when 'P'|'p' =>
	       Get(Temp_Int_1);
	       Get(Temp_Int_2);
	       Temp_Pos.X := Temp_Int_1;
	       Temp_Pos.Y := Temp_Int_2;
	       P_Epr := Get_Niveau(Temp_Pos);
	       Choisi := True;
	    --Id
	    when 'M'|'m' =>
	       Get(Temp_Int_1);
	       P_Epr := Trouver_Par_Id(Temp_Int_1, Niveaux);
	       Choisi := True;
	    --Par Nom
	    when 'N'|'n' =>
	       Get_Line(Reponse, Last);
	       --On enlève eventurellement les espaces du debut
	       Temp_Int_1 := Reponse'First;
	       while Reponse(Temp_Int_1) = ' ' loop
		  Temp_Int_1 := Temp_Int_1+1;
	       end loop;
	       Append(Message_TS, Reponse(Temp_Int_1..Last) & " : ");
	       P_Epr := Trouver_Par_Nom(Reponse(Temp_Int_1..Last), Niveaux);
	       Choisi := True;
	    when 'Q'|'q' =>
	       Choisi := True;
	    when others => Put_Line("Inconnu");
	 end case;
	 if(P_Epr /= null and then Get_Accessible(P_Epr) = False) then
	    P_Epr := null;
	    Choisi := False;
	    raise Niveau_Inaccessible;
	 end if;
	 --TRAITEMENT DES EXCEPTIONS (Communes a toutes les demandes)
	 exception
	    when Niveau_Inexistant => Append(Message_TS, "Les coordonnées saisies ne correspondent à rien !");
	    when Niveau_Inaccessible => Append(Message_TS, "Ne sois pas si impatient ! (Niveau demandé inaccessible)");
	    when Id_Inexistant => Append(Message_TS, "Le niveau demandé n'existait même pas !");
	    when others => 
	       Get_Line(Reponse, Last);
	       Put_Line("Je sais pas pourquoi, mais ça me plait pas !");
	 end;
      end loop;
      return P_Epr;
   end Choix_Niveaux;
   
begin
   null;
   --Charger_Niveaux("test");
   --Affichage_Arbre(Niveaux, "   ");
   --New_Line;
   --Afficher_Ecran(L_Epr_To_Tab_Ecran(Niveaux), 2);
   --New_Line;
   --Put_Line("On rend la première épreuve accessible");
   --Set_Accessible(True, Niveaux.all.Info.all);
   --Afficher_Ecran(L_Epr_To_Tab_Ecran(Niveaux), 2);
   --Put_Line("On termine la première");
   --Epreuve_Finie(Niveaux.all.Info, Niveaux);
   --Afficher_Ecran(L_Epr_To_Tab_Ecran(Niveaux), 2);
end Maps;
