with Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO, affichage;
use Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO, Affichage;

package body combats is
   
   procedure Combat(Heros : in out Personnage; BadG : in out Personnage; Message_TS_Pere : out Unbounded_String) is
      Message_TS : Unbounded_String;
      Reponse : String(1..50);
      Last : Natural;
      Temp_Char : Character;
      Continuer : Boolean := True;
      Temp_Int : Integer;
      Temp_S1, Temp_S2 : P_String;
   begin
      while Continuer loop
	 Afficher_Ecran((others => (others =>' '))); --L'écran de combat
	 
	 --Affichage des noms
	 Put(Nom(Heros));
	 Temp_Int := (LARGEUR_ECRAN+2) - (Nom(Heros)'Length + Nom(BadG)'Length);
	 for N in 1..Temp_Int loop
	    Put(' ');
	 end loop;
	 Put(Nom(BadG));
	 New_Line;
	 
	 --Affichage des vies
	 FreeStr(Temp_S1);
	 FreeStr(Temp_S2);
	 Temp_S1 := new String'("Vie :"&Integer'Image(Vie(Heros))&" /"&Integer'Image(VieMax(Heros)));
	 Temp_S2 := new String'("Vie :"&Integer'Image(Vie(BadG))&" /"&Integer'Image(VieMax(BadG)));
	 Temp_Int := (LARGEUR_ECRAN+2) - (Temp_S1'Length + Temp_S2'Length);
	 
	 Put(Temp_S1.all);
	 for N in 1..Temp_Int loop
	    Put(' ');
	 end loop;
	 Put(Temp_S2.all);
	 New_Line;
	 
	 --Affichage de l'endurance
	 FreeStr(Temp_S1);
	 FreeStr(Temp_S2);
	 Temp_S1 := new String'("Endurance :"&Integer'Image(Endurance(Heros))&" /"&Integer'Image(EnduMax(Heros)));
	 Temp_S2 := new String'("Endurance :"&Integer'Image(Endurance(BadG))&" /"&Integer'Image(EnduMax(BadG)));
	 Temp_Int := (LARGEUR_ECRAN+2) - (Temp_S1'Length + Temp_S2'Length);
	 
	 Put(Temp_S1.all);
	 for N in 1..Temp_Int loop
	    Put(' ');
	 end loop;
	 Put(Temp_S2.all);
	 New_Line;
	 
	 --Affichage des messages
	 New_Line;
	 Put_Line(To_String(Message_TS));
	 Message_TS := To_Unbounded_String("");
	 Put_Line("[Q]uitter");
	 Get(Temp_Char);
	 --On regarde le type de déplacement choisi
	 begin
	    case Temp_Char is
	       --Position
	       when 'Q' | 'q' =>
		  Continuer := False;
	       when others => Append(Message_TS, "Commande inconnue");
	    end case;
	 exception
	    when others => Append(Message_TS, "Il y a une erreur !!!!!!");
	 end;
      end loop;
      Message_TS_Pere := Message_TS;
   end Combat;   
   
end combats;
