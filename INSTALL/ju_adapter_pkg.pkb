prompt
prompt Creating package body JU_ADAPTER_PKG
prompt ====================================
prompt
create or replace package body ju_adapter_pkg
is
   function dugovi_iz(
     p_izracun_id       in    ju_izracun_zatezne.id%type
   )
   return   ju_tipovi_pkg.dugovi
   is
     cursor cur_dugovi
     is
       select    tist.transakcija_id id
       ,         tist.iznos
       ,         tist.datum
       from      ju_transakcije_izracuna_sort_v  tist
       where     tist.izracun_id = p_izracun_id
       and       tist.strana = 'D'
     ;

     v_dugovi_tab      ju_tipovi_pkg.dugovi;
   begin
     open cur_dugovi;

     fetch cur_dugovi
     bulk collect into v_dugovi_tab;

     close cur_dugovi;

     return v_dugovi_tab;

   end;
-------------------------------------------------------------------------------
   function uplate_iz(
     p_izracun_id       in    ju_izracun_zatezne.id%type
   )
   return   ju_tipovi_pkg.uplate
   is
   cursor cur_uplate
   is
       select    tist.transakcija_id id
       ,         tist.iznos
       ,         tist.datum
       from      ju_transakcije_izracuna_sort_v  tist
       where     tist.izracun_id = p_izracun_id
       and       tist.strana = 'P'
   ;

   v_uplate_tab         ju_tipovi_pkg.uplate;
   begin
     open cur_uplate;

     fetch cur_uplate
     bulk collect into v_uplate_tab;

     close cur_uplate;

     return v_uplate_tab;
   end;

-------------------------------------------------------------------------------
   procedure obracun_u_session(
     p_izracun_id               in    ju_izracun_zatezne.id%type
    ,p_izracun_zateznih_tab     in    ju_tipovi_pkg.izracun_kamate_tab_type
   )
   is
     v_obracun_rec             ju_rezultat_izracuna%rowtype;
     -------------------
     -- helper functions
     -------------------
     function row_obracuna_u_rec(
       p_izracun_kamate_rec      in    ju_tipovi_pkg.izracun_kamate_rec
     )
     return ju_rezultat_izracuna%rowtype
     is
        v_rec    ju_rezultat_izracuna%rowtype;
     begin
        v_rec.id              := ju_zatezne_app_pkg.new_id;
        v_rec.ize_id          := p_izracun_id;
        v_rec.dug_id          := p_izracun_kamate_rec.dug_id;
        v_rec.uplata_id       := p_izracun_kamate_rec.uplata_id;
        v_rec.kamata_id       := p_izracun_kamate_rec.kamatna_stopa_id;
        v_rec.kamatna_stopa   := p_izracun_kamate_rec.kamatna_stopa;
        v_rec.datum_od        := p_izracun_kamate_rec.datum_od;
        v_rec.datum_do        := p_izracun_kamate_rec.datum_do;
        v_rec.broj_dana       := p_izracun_kamate_rec.broj_dana;
        v_rec.nacin_izracuna_kamate         := p_izracun_kamate_rec.nacin_izracuna_kamate;
        v_rec.osnovica                      := p_izracun_kamate_rec.osnovica;
        v_rec.kamata_prethodnog_razdoblja   := p_izracun_kamate_rec.kamata_prethodnog_razdoblja;
        v_rec.umanjenje_zbog_uplate         := p_izracun_kamate_rec.umanjenje_zbog_uplate;
        v_rec.osnovica_izracuna_po_dugu     := p_izracun_kamate_rec.osnovica_izracuna_po_dugu;
        v_rec.osnovica_izracuna_po_kamati   := p_izracun_kamate_rec.osnovica_izracuna_po_kamati;
        v_rec.zatezna_kamata                := p_izracun_kamate_rec.zatezna_kamata;
        v_rec.ukupna_zatezna_kamata         := p_izracun_kamate_rec.ukupna_zatezna_kamata;

        return v_rec;
     end;
   begin
     if p_izracun_zateznih_tab.count = 0
     then
       return;
     end if;

     for i in 1..p_izracun_zateznih_tab.count
     loop
         v_obracun_rec := row_obracuna_u_rec(p_izracun_zateznih_tab(i));
         insert into ju_rezultat_izracuna values v_obracun_rec;
     end loop;
   end;
end ju_adapter_pkg;
/
