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
   
end Types;
