prompt
prompt Creating package body JU_MODEL_PKG
prompt ==================================
prompt
CREATE OR REPLACE PACKAGE BODY ju_model_pkg
as
-------------------------------------------------------------------------------
   function id_za_sifru_izracuna(
     p_sifra_izracuna      in      ju_tipovi_izracuna.sifra%type  
   )
   return ju_tipovi_izracuna.id%type
   is
     cursor cur_id
     is
     select   id
     from     ju_tipovi_izracuna tia
     where    tia.sifra = p_sifra_izracuna
     ;
     
     v_id     ju_tipovi_izracuna.id%type;
   begin
     open cur_id;
     
     fetch cur_id
     into  v_id
     ;
     
     close cur_id;
     
     return v_id;
   end;
-------------------------------------------------------------------------------
   function kamatne_stope_za_tip_izracuna(
     p_tip_izracuna_id       in   ju_tipovi_izracuna.id%type
   )
   return ju_tipovi_pkg.kamatne_stope_tab_type
   is
      cursor cur_ks
      is
      select   *
      from     ju_vrijedece_kamatne_stope_v ksi
      where    ksi.id_tipa_izracuna = p_tip_izracuna_id
      order by ksi.ks_datum_od
      ,        decode(nvl(ksi.primaran, 'N'), 'D', 0, 1)
      ;
     
      v_kamatne_stope_rec             ju_tipovi_pkg.kamatne_stope_rec; 
      v_kamatne_stope_tab             ju_tipovi_pkg.kamatne_stope_tab_type;
       
   begin
      for r_ks in cur_ks
      loop

             v_kamatne_stope_rec.id        := r_ks.ks_id;
             v_kamatne_stope_rec.stopa     := r_ks.ks_stopa;
             v_kamatne_stope_rec.datum_od  := r_ks.ks_datum_od;
             v_kamatne_stope_rec.datum_do  := r_ks.ks_datum_do;
             
             v_kamatne_stope_tab(v_kamatne_stope_tab.count + 1) := v_kamatne_stope_rec;
           
      end loop;

      
      return v_kamatne_stope_tab;
   end;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
   function kamatne_stope_za_fizicke
   return ju_tipovi_pkg.kamatne_stope_tab_type
   is
   begin
     return kamatne_stope_za_tip_izracuna(id_za_sifru_izracuna('FZ'));
   end;
-------------------------------------------------------------------------------
   function kamatne_stope_za_pravne
   return ju_tipovi_pkg.kamatne_stope_tab_type
   is
   begin
     return kamatne_stope_za_tip_izracuna(id_za_sifru_izracuna('MB-ZOO'));
   end;
-------------------------------------------------------------------------------
   function kamatne_stope_za_predstecajne
   return ju_tipovi_pkg.kamatne_stope_tab_type
   is
   begin
     return kamatne_stope_za_tip_izracuna(id_za_sifru_izracuna('MB-ZFPPN'));
   end;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
   function nacin_obracuna_kamate
   return ju_tipovi_pkg.nacin_obracuna_tab_type
   is
      v_nacin_obracuna_kamate_tab    ju_tipovi_pkg.nacin_obracuna_tab_type;
      v_nacin_obracuna_rec           ju_tipovi_pkg.nacin_obracuna_rec;
   begin
      for r_obr in (
         select    *
         from      ju_nacini_obracuna jna
      )
      loop
        v_nacin_obracuna_rec.metoda_izracuna_kamate := r_obr.metoda_obracuna;
        v_nacin_obracuna_rec.datum_od               := r_obr.datum_od;
        v_nacin_obracuna_rec.datum_do               := r_obr.datum_do;
        v_nacin_obracuna_rec.uz_razdoblje_obracuna  := r_obr.duljina_razdoblja;
        
        v_nacin_obracuna_kamate_tab(v_nacin_obracuna_kamate_tab.count + 1) := v_nacin_obracuna_rec;
      end loop;
      
      return v_nacin_obracuna_kamate_tab;
   end;   
end;
/
