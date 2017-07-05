prompt
prompt Creating package body JU_ADAPTER_PKG
prompt ====================================
prompt
create or replace package body ju_adapter_pkg
is
   function glavnice_iz(
     p_obracun_id       in    ju_session_izracun_zatezne.id%type
--    ,p_session          in    varchar2
   )
   return   ju_tipovi_pkg.glavnice
   is
     cursor cur_session_glavnice
     is
     select    jsg.id
     ,         jsg.iznos
     ,         jsg.datum_dospijeca datum
     from      ju_session_glavnice jsg
     where     jsg.sie_id = p_obracun_id
--     and       jsg.session_context = p_session
     ;
     
     v_session_glavnice_tab      ju_tipovi_pkg.glavnice;
   begin
     open cur_session_glavnice;
     
     fetch cur_session_glavnice
     bulk collect into v_session_glavnice_tab;
     
     close cur_session_glavnice;
     
     return v_session_glavnice_tab;
     
   end;
-------------------------------------------------------------------------------
   function uplate_iz(
     p_obracun_id       in    ju_session_izracun_zatezne.id%type
--    ,p_session          in    varchar2
   )
   return   ju_tipovi_pkg.uplate
   is
   cursor cur_session_uplate
   is
   select    jsu.id
   ,         jsu.iznos
   ,         jsu.datum_uplate datum
   from      ju_session_uplate jsu
   where     jsu.sie_id = p_obracun_id
--   and       jsu.session_context = p_session
   ;
   
   v_session_uplate_tab         ju_tipovi_pkg.uplate;
   begin
     open cur_session_uplate;
     
     fetch cur_session_uplate
     bulk collect into v_session_uplate_tab;
     
     close cur_session_uplate;
     
     return v_session_uplate_tab;
   end;

-------------------------------------------------------------------------------
   procedure obracun_u_session(
     p_obracun_id               in    ju_session_izracun_zatezne.id%type
    ,p_obracun_zateznih_tab     in    ju_tipovi_pkg.izracun_kamate_tab_type
   )
   is
     v_obracun_header          ju_session_izracun_zatezne%rowtype;
     v_session_obracun_rec     ju_session_rezultat_izracuna%rowtype;
     -------------------
     -- helper functions
     -------------------
     function row_obracuna_u_session_rec(
       p_obracun_header          in    ju_session_izracun_zatezne%rowtype
      ,p_izracun_kamate_rec      in    ju_tipovi_pkg.izracun_kamate_rec
     )
     return ju_session_rezultat_izracuna%rowtype
     is
        v_session_rec    ju_session_rezultat_izracuna%rowtype;
     begin
        v_session_rec.id              := ju_zatezne_app_pkg.new_session_id;
        v_session_rec.session_context := p_obracun_header.session_context;
        v_session_rec.sie_id          := p_obracun_id;
        v_session_rec.glavnica_id     := p_izracun_kamate_rec.glavnica_id;
        v_session_rec.uplata_id       := p_izracun_kamate_rec.uplata_id;
        v_session_rec.kamata_id       := p_izracun_kamate_rec.kamatna_stopa_id;
        v_session_rec.kamatna_stopa   := p_izracun_kamate_rec.kamatna_stopa;
        v_session_rec.datum_od        := p_izracun_kamate_rec.datum_od;
        v_session_rec.datum_do        := p_izracun_kamate_rec.datum_do;
        v_session_rec.broj_dana       := p_izracun_kamate_rec.broj_dana;
        v_session_rec.nacin_izracuna_kamate         := p_izracun_kamate_rec.nacin_izracuna_kamate;
        v_session_rec.osnovica                      := p_izracun_kamate_rec.osnovica;
        v_session_rec.kamata_prethodnog_razdoblja   := p_izracun_kamate_rec.kamata_prethodnog_razdoblja;
        v_session_rec.umanjenje_zbog_uplate         := p_izracun_kamate_rec.umanjenje_zbog_uplate;
        v_session_rec.osnovica_izracuna_po_glavnici := p_izracun_kamate_rec.osnovica_izracuna_po_glavnici;
        v_session_rec.osnovica_izracuna_po_kamati   := p_izracun_kamate_rec.osnovica_izracuna_po_kamati;
        v_session_rec.zatezna_kamata                := p_izracun_kamate_rec.zatezna_kamata;
        v_session_rec.ukupna_zatezna_kamata         := p_izracun_kamate_rec.ukupna_zatezna_kamata;
        
        return v_session_rec;
     end;
   begin
     if p_obracun_zateznih_tab.count = 0
     then
       return;
     end if;
     
     v_obracun_header := ju_zatezne_app_pkg.get_obracun_data(p_obracun_id);
     
     for i in 1..p_obracun_zateznih_tab.count
     loop
         v_session_obracun_rec := row_obracuna_u_session_rec(v_obracun_header, p_obracun_zateznih_tab(i));
         insert into ju_session_rezultat_izracuna values v_session_obracun_rec;
     end loop;
   end;
end ju_adapter_pkg;
/
