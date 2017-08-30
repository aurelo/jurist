prompt
prompt Creating package JU_MODEL_PKG
prompt =============================
prompt
CREATE OR REPLACE PACKAGE ju_model_pkg
as
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
   function get_vrsta_transakcije_id(
     p_naziv          in    ju_vrste_transakcija.naziv%type
   )
   return   ju_vrste_transakcija.id%type
   ;
-------------------------------------------------------------------------------
   function kamatne_stope_za_tip_izracuna(
     p_tip_izracuna_id       in   ju_tipovi_izracuna.id%type
   )
   return ju_tipovi_pkg.kamatne_stope_tab_type;
-------------------------------------------------------------------------------
   function kamatne_stope_za_fizicke
   return ju_tipovi_pkg.kamatne_stope_tab_type;
-----------------------------------------------
   function kamatne_stope_za_pravne
   return ju_tipovi_pkg.kamatne_stope_tab_type;
-----------------------------------------------
   function kamatne_stope_za_predstecajne
   return ju_tipovi_pkg.kamatne_stope_tab_type;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
    function nacin_obracuna_kamate
    return ju_tipovi_pkg.nacin_obracuna_tab_type;
end;
/
