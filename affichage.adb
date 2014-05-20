with Ada.Text_IO, Types;
use Ada.Text_IO, Types;

package body Affichage is
   procedure Afficher_Ecran(T : Tab_Ecran) is
   begin
      Put(ASCII.ESC & "[H" & ASCII.ESC & "[J");
      --Ligne de départ
      Put("╔");
      for X in 1..T'Length(1) loop
	    Put("═");
      end loop;
      Put("╗");
      New_Line;
      
      --Corps
      for Y in T'Range(2) loop
	 Put("║");
	 for X in T'Range(1) loop
	    case T(X,Y) is
	       when Character'Val(197)=> Put("┼");
	       when Character'Val(196)=> Put("─");
	       when Character'Val(179)=> Put("│");
	       when Character'Val(167)|Character'Val(248)=>Put("°");
	       when Character'Val(00)..Character'Val(31) | Character'Val(255)=> Put(' ');	  
	       when others=> Put(T(X, Y));
	    end case;
	 end loop;
	 
	 Put("║"); --Carac : ║
	 New_Line;
      end loop;
      
      --Ligne finales
      Put("╚");
      for X in 1..T'Length(1) loop
	    Put("═");
      end loop;
      Put("╝");
      New_Line;
   end Afficher_Ecran;
   
end Affichage;
