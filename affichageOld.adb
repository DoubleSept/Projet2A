with Ada.Text_IO, Types;
use Ada.Text_IO, Types;

package body Affichage is
   procedure Afficher_Ecran(T : Tab_Ecran; Bord : Integer) is
   begin
      Put(ASCII.ESC & "[H" & ASCII.ESC & "[J");
      --Ligne de départ
      for Y in 1..Bord loop
	 for X in 1..T'Length(1) + 2*Bord loop
	    Put('/');
	 end loop;
	 New_Line;
      end loop;
      
      --Corps
      for Y in T'Range(2) loop
	 for X in 1..Bord loop
	    Put('/');
	 end loop;
	 for X in T'Range(1) loop
	    Put(T(X, Y));
	 end loop;
	 for X in 1..Bord loop
	    Put('/');
	 end loop;
	 New_Line;
      end loop;
      
      --Lignes finales
      for Y in 1..Bord loop
	 for X in 1..T'Length(1) + 2*Bord loop
	    Put('/');
	 end loop;
	 New_Line;
      end loop;
   end Afficher_Ecran;
   
end Affichage;
