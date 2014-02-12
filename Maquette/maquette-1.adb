with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure maquette is
   Continuer : Boolean := True;
   Vie_Max : Integer := 100;
   Vie_Actuelle : Integer := Vie_Max;
   Saisie : Character;
begin
   while(Continuer) loop
      --On fait le dessin--
      New_Line;
      Put_line("//////////////////////////////////////////////////////////////////////");
      Put_line("//               |||                                                //");
      Put_line("//              |. .|                                               //");
      Put_line("//               \>/                                           \|/  //");
      Put_line("//               _|_                                           -O-  //");
      Put_line("//        ***   /   \                                          /|\  //");
      Put_line("//        *\\  //| |\\                                              //");
      Put_line("//        * \\// | |//                                              //");
      Put_line("//           \\  /_\/              \\\\\\                           //");
      Put_line("//              // \\             <(°    \                          //");
      Put_line("//             //   \\             (      )  {°)_                   //");
      Put_line("//            //     \\             (    )    \>_\                  //");
      Put_line("//////////////////////////////////////////////////////////////////////");
      Put("               PV : ");
      Put(Vie_Actuelle, 1);
      Put("/");
      Put(Vie_Max, 0); --Le deuxième paramètre = Nbr de 0 à gauche
      New_Line;
      Put_line(" [F]ight | [E]scape | [L]oose | [P]rout ||[Sq] Save and Quit ");
      
      --Le processus de saisie
      Get(Saisie);
      if (Saisie = 'E') then
	 Continuer := False;
      elsif (Saisie = 'L') then
	 Vie_Actuelle := Vie_Actuelle - 10;
      end if;
      
      --Conditions de fin
      
      --FIN DE LA BOUCLE
   end loop;
   
end maquette;
