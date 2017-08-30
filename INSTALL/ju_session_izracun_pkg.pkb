prompt
prompt Creating package body JU_SESSION_IZRACUN_PKG
prompt ============================================
prompt
create or replace package body ju_session_izracun_pkg
as
-------------------------------------------------------------------------------
-- PRIVATE
------------------------------------------------------------------------------- 
  C_ZATEZNE_IZRACUN    constant  varchar2(16)  := 'ZATEZNE_IZRACUN';
  C_DUGOVI             constant  varchar2(16)  := 'DUGOVI';
  C_UPLATE             constant  varchar2(16)  := 'UPLATE';
  C_ZATEZNE_REZULTAT   constant  varchar2(16)  := 'ZATEZNE_REZULTAT';
------------------------------------------------------------------------------- 
  procedure stvori_kolekciju(
     p_collection_name      in    apex_collections.collection_name%type
  )
  is
  begin
      if not apex_collection.collection_exists(p_collection_name) 
      then
             apex_collection.create_collection(p_collection_name);
      end if;
  end;
-------------------------------------------------------------------------------
  procedure  izbrisi_kolekciju(
     p_collection_name      in    apex_collections.collection_name%type    
  )
  is
  begin
      apex_collection.create_or_truncate_collection(p_collection_name);
  end;

-------------------------------------------------------------------------------
  procedure stvori_kolekciju_izracuna
  is
  begin
    stvori_kolekciju(C_ZATEZNE_IZRACUN);
  end;
  
-------------------------------------------------------------------------------
    function load_izracun_header(
      p_izracun_id        in    ju_izracun_zatezne.id%type
    )
    return apex_collections.seq_id%type
    is
        cursor cur_izracun
        is
        select   ize.tia_id
        ,        ize.datum_izracuna
        ,        ize.opis
        from     ju_izracun_zatezne ize
        where    ize.id = p_izracun_id
        ;
        v_izracun_rec    cur_izracun%rowtype;
        
    begin
        open cur_izracun;
        
        fetch cur_izracun
        into  v_izracun_rec;
        
        close cur_izracun;
        
        return novi_izracun(p_tip_izracuna_id => v_izracun_rec.tia_id,
                            p_datum_izracuna  => v_izracun_rec.datum_izracuna,
                            p_opis            => v_izracun_rec.opis
                           );
        
        
    end;
-------------------------------------------------------------------------------
    procedure load_dugove_izracuna(
      p_izracun_id              in     ju_izracun_zatezne.id%type
     ,p_tip_duga_id             in     ju_vrste_transakcija.id%type default null
    )
    is
      cursor cur_dugovi
      is
      select   tist.iznos
      ,        tist.datum datum_dospijeca
      ,        tist.vrsta_transakcije_id
      from     ju_transakcije_izracuna_sort_v tist
      where    tist.izracun_id = p_izracun_id
      and      tist.strana = 'D'
      and      tist.vrsta_transakcije_id = nvl(p_tip_duga_id, tist.vrsta_transakcije_id)
      ;
      v_seq_id number;
    begin
      for r_dugovi in cur_dugovi
      loop
        v_seq_id := novi_dug(p_iznos_duga => r_dugovi.iznos, p_datum_duga => r_dugovi.datum_dospijeca, p_tip_duga_id => r_dugovi.vrsta_transakcije_id); 
      end loop;
    end;
-------------------------------------------------------------------------------
    procedure load_uplate_izracuna(
      p_izracun_id        in    ju_izracun_zatezne.id%type
    )
    is
      cursor cur_uplate
      is
      select   tist.iznos
      ,        tist.datum datum_uplate
      ,        tist.vrsta_transakcije_id
      from     ju_transakcije_izracuna_sort_v tist
      where    tist.izracun_id = p_izracun_id
      and      tist.strana = 'P'
      ;
      v_seq_id    number;
    begin
      for r_uplate in cur_uplate
      loop
          v_seq_id := nova_uplata(p_iznos_uplate => r_uplate.iznos, p_datum_uplate => r_uplate.datum_uplate, p_tip_uplate_id => r_uplate.vrsta_transakcije_id);
      end loop;
    end;
    
    procedure load_rezultat_izracuna(
      p_izracun_id        in    ju_izracun_zatezne.id%type
    )
    is
      cursor cur_rezultati
      is
      select    *
      from      ju_rezultat_izracuna ri
      where     ri.ize_id = p_izracun_id
      order by  ri.id
      ;
      v_seq_id      apex_collections.seq_id%type;
    begin
       for r_rezultati in cur_rezultati
       loop
          v_seq_id := apex_collection.add_member(
                          p_collection_name     => ZATEZNE_REZULTAT
                         ,p_n001                => r_rezultati.dug_id
                         ,p_n002                => r_rezultati.uplata_id
                         ,p_c001                => r_rezultati.uplata_na_zadnji_dan_YN 
                         ,p_n003                => r_rezultati.osnovica
                         ,p_n004                => r_rezultati.kamata_prethodnog_razdoblja
                         ,p_n005                => r_rezultati.umanjenje_zbog_uplate
                         ,p_c006                => 100 * r_rezultati.osnovica_izracuna_po_dugu
                         ,p_c007                => 100 * r_rezultati.osnovica_izracuna_po_kamati
                         ,p_d001                => r_rezultati.datum_od
                         ,p_d002                => r_rezultati.datum_do
                         ,p_c008                => r_rezultati.broj_dana
                         ,p_c009                => r_rezultati.kamata_id
                         ,p_c010                => 100 * r_rezultati.kamatna_stopa
                         ,p_c002                => r_rezultati.nacin_izracuna_kamate
                         ,p_c011                => 100 * r_rezultati.zatezna_kamata                   
                         ,p_c012                => 100 * r_rezultati.ukupna_zatezna_kamata  
                                               );
       end loop;
    end;
-------------------------------------------------------------------------------    
    function insert_header_izracuna(
       p_user_id             in      ju_users.id%type
      ,p_vjerovnik_id        in      number
      ,p_duznik_id           in      number
      ,p_opis                in      varchar2
    )
    return number
    is
       cursor cur_session_header
       is
       select   szi.seq_id
       ,        szi.tip_izracuna_id
       ,        szi.datum_izracuna
       ,        szi.opis_izracuna
       from     ju_session_zatezne_izracun_v szi
       ;
       v_session_header_rec   cur_session_header%rowtype;
    begin
      open cur_session_header;
      
      fetch cur_session_header
      into  v_session_header_rec;
      
      close cur_session_header;
      
      if  v_session_header_rec.tip_izracuna_id is null
      or  v_session_header_rec.datum_izracuna is null
      then
         return null;
      end if;
      
      return ju_zatezne_app_pkg.get_izracun_id(p_user_id         => p_user_id,
                                               p_tip_izracuna_id => v_session_header_rec.tip_izracuna_id,
                                               p_datum_izracuna  => v_session_header_rec.datum_izracuna,
                                               p_opis            => nvl(p_opis, v_session_header_rec.opis_izracuna),
                                               p_vjerovnik_id    => p_vjerovnik_id,
                                               p_duznik_id       => p_duznik_id);
    end;
-------------------------------------------------------------------------------
    procedure  save_glavnice_za_izracun(
       p_izracun_id          in      ju_izracun_zatezne.id%type
    )
    is
    begin
      insert into ju_transakcije (
        id
       ,ize_id
       ,iznos
       ,datum
       ,vta_id
      )
      (
       select   ju_zatezne_app_pkg.new_id
       ,        p_izracun_id
       ,        sd.iznos
       ,        sd.datum_dospijeca
       ,        sd.vrsta_duga_id
       from     ju_session_dugovi_v sd
      )
      ;
    end;
-------------------------------------------------------------------------------
    procedure  save_uplate_za_izracun(
       p_izracun_id          in      ju_izracun_zatezne.id%type
    )
    is
    begin
      insert into ju_transakcije (
        id
       ,ize_id
       ,iznos
       ,datum
       ,vta_id
      )
       (
       select   ju_zatezne_app_pkg.new_id
       ,        p_izracun_id
       ,        su.iznos
       ,        su.datum_uplate
       ,        su.vrsta_transakcije_id
       from     ju_session_uplate_v su
       );
    end;
-------------------------------------------------------------------------------
    procedure  save_rezultat_za_izracun(
       p_izracun_id          in      ju_izracun_zatezne.id%type
    )
    is
    begin
      insert into ju_rezultat_izracuna (
         id
        ,ize_id
        ,dug_id
        ,uplata_id
        ,kamata_id
        ,kamatna_stopa
        ,datum_od
        ,datum_do
        ,broj_dana
        ,nacin_izracuna_kamate
        ,osnovica
        ,kamata_prethodnog_razdoblja
        ,umanjenje_zbog_uplate
        ,osnovica_izracuna_po_dugu
        ,osnovica_izracuna_po_kamati
        ,zatezna_kamata
        ,ukupna_zatezna_kamata
        ,uplata_na_zadnji_dan_yn
       )
       (
       select   ju_zatezne_app_pkg.new_id
       ,        p_izracun_id
       ,        sri.dug_id
       ,        sri.uplata_id
       ,        sri.kamatna_stopa_id
       ,        sri.kamatna_stopa
       ,        sri.datum_od
       ,        sri.datum_do
       ,        sri.broj_dana
       ,        sri.nacin_izracuna_kamate
       ,        sri.osnovica
       ,        sri.kamata_prethodnog_razdoblja
       ,        sri.umanjenje_zbog_uplate
       ,        sri.osnovica_izracuna_po_dugu
       ,        sri.osnovica_izracuna_po_kamati
       ,        sri.zatezna_kamata
       ,        sri.ukupna_zatezna_kamata
       ,        sri.uplata_na_zadnji_dan_YN
       from     ju_session_rezultat_izracuna_v sri
       );
    end;
-------------------------------------------------------------------------------
-- PUBLIC
-------------------------------------------------------------------------------  
  function ZATEZNE_IZRACUN    return  varchar2 deterministic
  is 
  begin 
     return C_ZATEZNE_IZRACUN;
  end;
  
  function DUGOVI             return  varchar2 deterministic
  is
  begin
    return C_DUGOVI;
  end; 

  function UPLATE             return  varchar2 deterministic
  is 
  begin 
     return C_UPLATE;
  end;
  
  function ZATEZNE_REZULTAT   return  varchar2 deterministic
  is 
  begin 
     return C_ZATEZNE_REZULTAT;
  end;


  procedure izbrisi_kolekciju_izracuna
  is
  begin
      izbrisi_kolekciju(ZATEZNE_IZRACUN);
  end;

-------------------------------------------------------------------------------
  procedure stvori_kolekciju_dugova
  is
  begin
    stvori_kolekciju(DUGOVI);
  end;
-------------------------------------------------------------------------------
  procedure izbrisi_kolekciju_dugova
  is
  begin
      izbrisi_kolekciju(DUGOVI);
  end;
-------------------------------------------------------------------------------
  procedure stvori_kolekciju_uplata
  is
  begin
      stvori_kolekciju(UPLATE);  
  end;
-------------------------------------------------------------------------------
  procedure izbrisi_kolekciju_uplata
  is
  begin
      izbrisi_kolekciju(UPLATE);
  end;
-------------------------------------------------------------------------------
  procedure stvori_kolekciju_rezultata
  is
  begin
      stvori_kolekciju(ZATEZNE_REZULTAT);  
  end;
-------------------------------------------------------------------------------
  procedure izbrisi_kolekciju_rezultata
  is
  begin
      izbrisi_kolekciju(ZATEZNE_REZULTAT);
  end;
-------------------------------------------------------------------------------  
  procedure inicijalno_stvaranje_kolekcija
  is
  begin
        stvori_kolekciju_izracuna; 
        stvori_kolekciju_dugova;
--        stvori_kolekciju_glavnica;
        stvori_kolekciju_uplata;
        stvori_kolekciju_rezultata;
  end;
-------------------------------------------------------------------------------  
  procedure clear_session_kolekcije
  is
  begin
        izbrisi_kolekciju_rezultata;
        izbrisi_kolekciju_uplata;
  --      izbrisi_kolekciju_glavnica;
        izbrisi_kolekciju_dugova;
        izbrisi_kolekciju_izracuna;
        commit;
  end;
-------------------------------------------------------------------------------
  function novi_izracun(
      p_tip_izracuna_id     in     ju_tipovi_izracuna.id%type
     ,p_datum_izracuna      in     date
     ,p_opis                in     ju_izracun_zatezne.opis%type default null
  )
  return apex_collections.seq_id%type
  is
    begin
        izbrisi_kolekciju_izracuna;    
    
        return  apex_collection.add_member(p_collection_name => C_ZATEZNE_IZRACUN,
                                           p_n001            => p_tip_izracuna_id,
                                           p_d001            => p_datum_izracuna,
                                           p_c001            => p_opis
                                  );
    end;
-------------------------------------------------------------------------------
  function novi_dug(
     p_iznos_duga           in      number
    ,p_datum_duga           in      date
    ,p_tip_duga_id          in      number
  )
  return number
  is
  begin
    -- stvori ako ne postoji
    stvori_kolekciju_dugova;
    
    return apex_collection.add_member(p_collection_name => DUGOVI,
                                      p_n001            => p_iznos_duga,
                                      p_d001            => p_datum_duga,
                                      p_n002            => p_tip_duga_id
                                     );
  end;
-------------------------------------------------------------------------------
  procedure obrisi_dug(
    p_seq_id                in      apex_collections.seq_id%type
  )
  is
  begin
    apex_collection.delete_member(p_collection_name => DUGOVI, p_seq => p_seq_id);
  end;
-------------------------------------------------------------------------------  
  procedure azuriraj_dug(
    p_seq_id                in      apex_collections.seq_id%type
   ,p_iznos_glavnice        in      number
   ,p_datum_izracuna        in      date
   ,p_tip_duga_id           in      number
  )
  is
  begin
    apex_collection.update_member_attribute(p_collection_name => DUGOVI,
                                            p_seq             => p_seq_id,
                                            p_attr_number     => 1,
                                            p_number_value    => p_iznos_glavnice);
                                            
    apex_collection.update_member_attribute(p_collection_name => DUGOVI,
                                            p_seq             => p_seq_id,
                                            p_attr_number     => 1,
                                            p_date_value      => p_datum_izracuna);
                                            
    apex_collection.update_member_attribute(p_collection_name => DUGOVI,
                                            p_seq             => p_seq_id,
                                            p_attr_number     => 2,
                                            p_number_value    => p_tip_duga_id);

  end;
-------------------------------------------------------------------------------
  function nova_uplata(
    p_iznos_uplate          in      number
   ,p_datum_uplate          in      date
   ,p_tip_uplate_id         in      number
  )
  return number
  is
  begin
    stvori_kolekciju_uplata;
    
    return apex_collection.add_member(p_collection_name => UPLATE,
                                      p_n001            => p_iznos_uplate,
                                      p_d001            => p_datum_uplate,
                                      p_n002            => p_tip_uplate_id
                                     );
  end;
-------------------------------------------------------------------------------  
  procedure obrisi_uplatu(
    p_seq_id                in      apex_collections.seq_id%type
  )
  is
  begin
    apex_collection.delete_member(p_collection_name => UPLATE, p_seq => p_seq_id);
  end;
-------------------------------------------------------------------------------  
  procedure azuriraj_uplatu(
    p_seq_id                in      apex_collections.seq_id%type    
   ,p_iznos_uplate          in      number
   ,p_datum_uplate          in      date
  )
  is
  begin
    apex_collection.update_member_attribute(p_collection_name => UPLATE,
                                            p_seq             => p_seq_id,
                                            p_attr_number     => 1,
                                            p_number_value    => p_iznos_uplate);
                                            
    apex_collection.update_member_attribute(p_collection_name => UPLATE,
                                            p_seq             => p_seq_id,
                                            p_attr_number     => 1,
                                            p_date_value      => p_datum_uplate);
  end;
  
-------------------------------------------------------------------------------
  function novi_rezultat_izracuna(
    p_izracun_rec           in      ju_session_rezultat_izracuna_v%rowtype
  )
  return number
  is
  begin
    return  apex_collection.add_member(p_collection_name => ZATEZNE_REZULTAT,
                                       p_n001            => p_izracun_rec.dug_id,
                                       p_n002            => p_izracun_rec.uplata_id,
                                       p_c001            => p_izracun_rec.uplata_na_zadnji_dan_YN,
                                       p_n003            => p_izracun_rec.osnovica,
                                       p_n004            => p_izracun_rec.kamata_prethodnog_razdoblja,
                                       p_n005            => p_izracun_rec.umanjenje_zbog_uplate,
                                       p_c006            => p_izracun_rec.osnovica_izracuna_po_dugu,
                                       p_c007            => p_izracun_rec.osnovica_izracuna_po_kamati,
                                       p_d001            => p_izracun_rec.datum_od,
                                       p_d002            => p_izracun_rec.datum_do,
                                       p_c008            => p_izracun_rec.broj_dana,
                                       p_c009            => p_izracun_rec.kamatna_stopa_id,
                                       p_c010            => p_izracun_rec.kamatna_stopa,
                                       p_c002            => p_izracun_rec.nacin_izracuna_kamate,
                                       p_c011            => p_izracun_rec.zatezna_kamata,
                                       p_c012            => p_izracun_rec.ukupna_zatezna_kamata);
  end;

  
-------------------------------------------------------------------------------
  function mogu_obaviti_izracun(
    p_tip_izracuna          in      number
   ,p_datum_izracuna        in      date
  )
  return boolean
  is
       function postoje_glavnice
       return boolean
       is
          v_cnt   number;
       begin
          select   count(*)
          into     v_cnt
          from     ju_session_dugovi_v
          ;
          
          return v_cnt > 0;
       end;
  begin
    return p_tip_izracuna is not null
    and    p_datum_izracuna is not null
    and    postoje_glavnice;
  end;
-------------------------------------------------------------------------------
  function mogu_obaviti_izracun_YN(
    p_tip_izracuna          in      number
   ,p_datum_izracuna        in      date
  )
  return varchar2
  is
  begin
    return case when mogu_obaviti_izracun(p_tip_izracuna, p_datum_izracuna) then 'Y' else 'N' end;
  end;
-------------------------------------------------------------------------------
-------------
-- HELPERS 
------------
    function get_session_izracun_data
    return ju_session_zatezne_izracun_v%rowtype
    is
      v_obracun_rec  ju_session_zatezne_izracun_v%rowtype;
      cursor cur_obracun
      is
      select    *
      from      ju_session_zatezne_izracun_v
      ;
    begin
      open cur_obracun;

      fetch cur_obracun
      into  v_obracun_rec;

      close cur_obracun;

      return v_obracun_rec;
    end;
    
-------------------------------------------------------------------------------
   function dugovi_iz_sessiona
   return   ju_tipovi_pkg.dugovi
   is
     cursor cur_dugovi
     is
     select    jsg.seq_id id
     ,         jsg.iznos
     ,         jsg.datum_dospijeca datum
     from      ju_session_dugovi_v jsg
     order by  jsg.datum_dospijeca
     ,         jsg.seq_id
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
   function uplate_iz_sessiona
   return   ju_tipovi_pkg.uplate
   is
   cursor cur_uplate
   is
   select    jsu.seq_id id
   ,         jsu.iznos
   ,         jsu.datum_uplate datum
   from      ju_session_uplate_v jsu
   order by  jsu.datum_uplate
   ,         jsu.seq_id
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
      p_obracun_zateznih_tab        in   ju_tipovi_pkg.izracun_kamate_tab_type
      )
    is
     v_obracun_rec             ju_session_rezultat_izracuna_v%rowtype;
     -------------------
     -- helper functions
     -------------------
     function row_obracuna_u_rec(
       p_izracun_kamate_rec      in    ju_tipovi_pkg.izracun_kamate_rec
     )
     return ju_session_rezultat_izracuna_v%rowtype
     is
        v_rec    ju_session_rezultat_izracuna_v%rowtype;
     begin
        v_rec.dug_id                        := p_izracun_kamate_rec.dug_id;
        v_rec.uplata_id                     := p_izracun_kamate_rec.uplata_id;
        v_rec.uplata_na_zadnji_dan_YN       := p_izracun_kamate_rec.uplata_na_zadnji_dan_YN;
        v_rec.kamatna_stopa_id              := p_izracun_kamate_rec.kamatna_stopa_id;
        v_rec.kamatna_stopa                 := p_izracun_kamate_rec.kamatna_stopa * 100;
        v_rec.datum_od                      := p_izracun_kamate_rec.datum_od;
        v_rec.datum_do                      := p_izracun_kamate_rec.datum_do;
        v_rec.broj_dana                     := p_izracun_kamate_rec.broj_dana;
        v_rec.nacin_izracuna_kamate         := p_izracun_kamate_rec.nacin_izracuna_kamate;
        v_rec.osnovica                      := p_izracun_kamate_rec.osnovica;
        v_rec.kamata_prethodnog_razdoblja   := p_izracun_kamate_rec.kamata_prethodnog_razdoblja;
        v_rec.umanjenje_zbog_uplate         := p_izracun_kamate_rec.umanjenje_zbog_uplate;
        v_rec.osnovica_izracuna_po_dugu     := p_izracun_kamate_rec.osnovica_izracuna_po_dugu * 100;
        v_rec.osnovica_izracuna_po_kamati   := p_izracun_kamate_rec.osnovica_izracuna_po_kamati * 100;
        v_rec.zatezna_kamata                := p_izracun_kamate_rec.zatezna_kamata * 100;
        v_rec.ukupna_zatezna_kamata         := p_izracun_kamate_rec.ukupna_zatezna_kamata * 100;

        return v_rec;
     end;
   begin
     if p_obracun_zateznih_tab.count = 0
     then
       return;
     end if;

     for i in 1..p_obracun_zateznih_tab.count
     loop
         v_obracun_rec := row_obracuna_u_rec(p_obracun_zateznih_tab(i));
         v_obracun_rec.seq_id := novi_rezultat_izracuna(v_obracun_rec);
     end loop;
    end;

-------------
    procedure izracun_session_zatezne
    is
      v_dugovi_tab            ju_tipovi_pkg.dugovi;
      v_uplate_tab            ju_tipovi_pkg.uplate;

      v_obracun_header        ju_session_zatezne_izracun_v%rowtype;

      v_obracun_tab           ju_tipovi_pkg.izracun_kamate_tab_type;
    begin
      v_obracun_header := get_session_izracun_data;

      if not mogu_obaviti_izracun(p_tip_izracuna => v_obracun_header.tip_izracuna_id, p_datum_izracuna => v_obracun_header.datum_izracuna)
      then
         return;
      end if;

      v_dugovi_tab    := dugovi_iz_sessiona;
      v_uplate_tab    := uplate_iz_sessiona;

      if v_dugovi_tab.count = 0
      then
         return;
      end if;

      v_obracun_tab := ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_tip_izracuna(p_tip_izracuna_id => v_obracun_header.tip_izracuna_id),
                                                               p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                               p_dugovi_tab         => v_dugovi_tab,
                                                               p_uplate_tab         => v_uplate_tab,
                                                               p_datum_obracuna     => v_obracun_header.datum_izracuna);


      izbrisi_kolekciju_rezultata;
      
      obracun_u_session(v_obracun_tab);

      commit;
    end;
-------------------------------------------------------------------------------
-- sprema session izracun u perzistentne izracune za korisnika
-------------------------------------------------------------------------------
    procedure save_session_izracun(
    p_user_id         in    ju_users.id%type
   ,p_vjerovnik_id    in    number
   ,p_duznik_id       in    number
   ,p_opis            in    varchar2
    )
    is
      v_izracun_id          ju_izracun_zatezne.id%type;
    begin
      v_izracun_id := insert_header_izracuna(p_user_id, p_vjerovnik_id, p_duznik_id, p_opis);
      
      if v_izracun_id is null
      then
        return;
      end if;
      
      save_glavnice_za_izracun(v_izracun_id);
      save_uplate_za_izracun(v_izracun_id);
      
      save_rezultat_za_izracun(v_izracun_id);
      commit;
    exception when others
    then
        rollback;
    end;    
-------------------------------------------------------------------------------
    procedure saved_izracun_to_session(
        p_izracun_id      in    ju_izracun_zatezne.id%type
    )
    is 
        v_izracun_header_id     number;
    begin
        clear_session_kolekcije;  
    
        v_izracun_header_id := load_izracun_header(p_izracun_id);
        
        --load_glavnice_izracuna(p_izracun_id);
        load_dugove_izracuna(p_izracun_id);
        load_uplate_izracuna(p_izracun_id);
        load_rezultat_izracuna(p_izracun_id);
        
    end;
end;
/
