with Ada.Text_Io, Ada.Integer_Text_IO, Maps , Types, Ada.IO_Exceptions, Epreuves, Ada.Strings.Unbounded, Personnages, combats;
use Ada.Text_Io, Ada.Integer_Text_Io, Maps , Types, Ada.IO_Exceptions, Epreuves, Ada.Strings.Unbounded, Personnages, combats;

procedure Main is
   Message_TS : Unbounded_String;
   Reponse : String(1..50);
   Last : Natural;
   Temp_Char : Character;
   P_Epr : Pointeur_Epr;
   Heros : Personnage;
   S: P_String;
   Continuer : Boolean := True;
   BadG : Personnage;
begin
   Init_Perso(Heros, new String'("Paul Bismuth"));
   Charger_Niveaux("test");
   while Continuer loop
      Afficher_Carte;
      Put_Line(To_String(Message_TS));
      Message_TS := To_Unbounded_String("");
      Put_Line("[C]hoisir un niveau ou afficher l'[I]nventaire ?");
      
      Get(Temp_Char);
      --On regarde le type de déplacement choisi
      begin
	 case Temp_Char is
	    --Position
	    when 'C'|'c' =>
	       P_Epr := Choix_Niveaux;
	       Init_Perso(BadG, new String'("Le vieux monsieur aux bonbons"));
	       if(P_Epr /= null) then
		  Combat(Heros, BadG, Message_TS);
		  Finir_Niveau(P_Epr);
	       end if;
	    when 'I'|'i' =>
	       MenuInventaire(Heros, Message_TS);
	    when 'Q' | 'q' => 
	       New_Line;
	       Put_Line("Vous êtes sûr de quitter ? (o/n)");
	       Get(Temp_Char);
	       case Temp_Char is
		  when 'y'|'Y'|'o'|'O' =>
		     Continuer := False;
		  when others => Append(Message_TS, "Je savais que vous ne partiriez pas !");
	       end case;
	    when others => Append(Message_TS, "Commande inconnue");
	 end case;
      --exception
	 --when others => Append(Message_TS, "Il y a une erreur !!!!!!");
      end;
   end loop;
end Main;
