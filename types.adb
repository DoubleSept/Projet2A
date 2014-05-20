with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

package body Types is
   
   function "="(P1 , P2 : Position) return Boolean is
   begin
      return P1.X = P2.X and P1.Y = P2.Y;
   end "=";
   
   function "+"(T1 , T2 : Tab_Ecran) return Tab_Ecran is
      Renvoi : Tab_Ecran;
   begin
      for Y in T1'Range(2) loop
	 for X in T1'Range(1) loop
	    if (T1(X,Y) = ' ') then
	       Renvoi(X,Y) := T2(X,Y);
	    else
	       Renvoi(X,Y) := T1(X,Y);
	    end if;
	 end loop;
      end loop;
      return Renvoi;
   end "+";
   
   procedure Ecrire(PDeb : Position; S : String; T : in out Tab_Ecran)is
      PDebCorrige : Position;
   begin
      if PDeb.X /= 0 then
	 PDebCorrige.X := PDeb.X -1;--Car N commence a 1 et pas a 0
      end if;
      for N in S'Range loop
	 if(PDebCorrige.X+N)>LARGEUR_ECRAN or PDeb.Y>HAUTEUR_ECRAN then
	    exit;
	 end if;
	 T(PDebCorrige.X+N, PDeb.Y):=S(N);
      end loop;
   end Ecrire;
   
   procedure TraitVertical(X : Integer; T : in out Tab_Ecran) is 
   begin
      for Y in T'Range(2) loop
	 if (T(X, Y) = Character'Val(196) or T(X, Y)=Character'Val(197)) then
	    T(X, Y):=Character'Val(197);
	 else
	    T(X, Y):=Character'Val(179);
	 end if;
      end loop;
   end TraitVertical;
   
   procedure TraitHorizontal(Y : Integer; T : in out Tab_Ecran; XDeb : in Integer := 1; XFin : in Integer := LARGEUR_ECRAN) is 
   begin
      for X in XDeb..XFin loop
	 if (T(X, Y) = Character'Val(179) or T(X, Y)=Character'Val(197)) then
	    T(X, Y):=Character'Val(197);
	 else
	    T(X, Y):=Character'Val(196);
	 end if;
      end loop;
   end TraitHorizontal;
   
end Types;
