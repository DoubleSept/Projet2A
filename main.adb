with Ada.Text_Io, Ada.Integer_Text_IO, Maps , Types, Ada.IO_Exceptions, Epreuves, Ada.Strings.Unbounded;
use Ada.Text_Io, Ada.Integer_Text_Io, Maps , Types, Ada.IO_Exceptions, Epreuves, Ada.Strings.Unbounded;

procedure Main is
   Message_TS : Unbounded_String;
   Reponse : String(1..50);
   Last : Natural;
   Temp_Int_1, Temp_Int_2 : Integer;
   Temp_Pos : Position;
   Temp_Char : Character;
begin
   Charger_Niveaux("test");
   while not False loop
      Afficher_Carte(2);
      Put_Line(To_String(Message_TS));
      Message_TS := To_Unbounded_String("");
      Put_Line("Choisir un niveau par [N]om, [P]osition ou Nu[M]éro ?");
      Get(Temp_Char);
      --On regarde le type de déplacement choisi
      case Temp_Char is
	 --Position
	 when 'P' => begin
	    Get(Temp_Int_1);
	    Get(Temp_Int_2);
	    Temp_Pos.X := Temp_Int_1;
	    Temp_Pos.Y := Temp_Int_2;
	    Finir_Niveau(Get_Niveau(Temp_Pos));
	 exception
	    when Niveau_Inexistant => Put_Line("Les coordonnées saisies ne correspondent à rien !");
	    when Niveau_Inaccessible => Put_Line("Ne sois pas si impatient ! (Niveau demandé inaccessible)");
	    when others => 
	       Get_Line(Reponse, Last);
	       Put_Line("Je sais pas pourquoi, mais ça me plait pas !");
	    end;
	--Id
	 when 'M' => begin
	    Get(Temp_Int_1);
	    Finir_Niveau(Temp_Int_1);
	 exception
	    when Niveau_Inexistant => Put_Line("Les coordonnées saisies ne correspondent à rien !");
	    when Niveau_Inaccessible => Put_Line("Ne sois pas si impatient ! (Niveau demandé inaccessible)");
	    when others => 
	       Get_Line(Reponse, Last);
	       Put_Line("Je sais pas pourquoi, mais ça me plait pas !");
	 end;
	 --Par Nom
	 when 'N' => begin
	    Get_Line(Reponse, Last);
	    Finir_Niveau(Get_Niveau(Reponse(1..Last)));
	 exception
	    when Niveau_Inexistant => Put_Line("Les coordonnées saisies ne correspondent à rien !");
	    when Niveau_Inaccessible => Put_Line("Ne sois pas si impatient ! (Niveau demandé inaccessible)");
	    when Id_Inexistant => Append(Message_TS, "Le niveau demandé n'existait même pas !");
	    when others => 
	       Get_Line(Reponse, Last);
	       Put_Line("Je sais pas pourquoi, mais ça me plait pas !");
	 end;
	 when others => Put_Line("Inconnu");
      end case;
   end loop;
end Main;
