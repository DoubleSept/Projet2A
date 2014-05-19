with Ada.Unchecked_Deallocation, Ada.Text_IO;
use Ada.Text_IO;

package body Listes_G is
   
   procedure Free is new Ada.Unchecked_Deallocation(Cellule, Lien);
   
   procedure Initialiser(L : in out Liste) is
   begin
      if(L.Debut /= null) then
	 Vider(L);
      end if;
      L.Cardinal := 0;
   end Initialiser;
   
   procedure Vider(L : in out Liste) is
      L_Actu, L_Prec : Lien;
   begin
      L_Actu := L.Debut;
      while (L_Actu /= null) loop
	 L_Prec := L_Actu;
	 L_Actu := L_Actu.all.Suiv;
	 Free(L_Prec);
	 L.Cardinal := L.Cardinal - 1;
      end loop;
   end Vider;
	 
   procedure Inserer(E : in Element; L : in out Liste) is
      L_Actu : Lien := L.Debut;
   begin
      L_Actu := L.Debut;
      for N in 0..L.Cardinal loop
	 L_Actu := L_Actu.all.Suiv;
      end loop;
      L_Actu.all.Suiv := new Cellule'(E, null);
      L.Cardinal := L.Cardinal+1;
   end Inserer; 
   
   function Cardinal(L : in Liste) return Natural is
   begin
      return L.Cardinal;
   end Cardinal;
   
   function Est_Vide(L : in Liste) return Boolean is
   begin
      return L.Cardinal = 0;
   end Est_Vide;
   
   function To_String(L : in Liste) return String is
      Temp_Unbound : Unbounded_String;
      L_Actu : Lien := L.Debut;
      Num_Elmt : Natural := 0;
   begin
      while(L_Actu /= null) loop
	 Append(Temp_Unbound, ("Element n" & Integer'Image(Num_Elmt) & " : "));
	 Append(Temp_Unbound, To_String(L_Actu.all.Info));
	 Append(Temp_Unbound, "\n");
	 L_Actu := L_Actu.all.Suiv;
	 Num_Elmt := Num_Elmt+1;
      end loop;
      return  To_String(Temp_Unbound); 
   end To_String;
   
end Listes_G;
