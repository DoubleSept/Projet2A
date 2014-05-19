with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

generic
   type Element is private;
   with function To_String(E : in Element) return String;

package Listes_G is

   type Liste is limited private;
   
   Liste_Vide : exception;
   Element_Non_Present : exception;
   Element_Deja_Present : exception;
   
   function Est_Vide(L : in Liste) return Boolean;
   procedure Initialiser(L : in out Liste);
   procedure Vider(L : in out Liste);
   procedure Inserer(E : in Element; L : in out Liste);
   function Cardinal(L : in Liste) return Natural;
   function To_String(L : in Liste) return String;

private
   
   type Cellule;
   type Lien is access Cellule;
   type Cellule is record
      Info : Element;
      Suiv : Lien;
   end record;
   
   type Liste is record
      Debut : Lien;
      Cardinal : Natural;
   end record;

end Listes_G;

