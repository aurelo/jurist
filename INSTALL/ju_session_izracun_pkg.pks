prompt
prompt Creating package JU_SESSION_IZRACUN_PKG
prompt =======================================
prompt
create or replace package ju_session_izracun_pkg
as
  function ZATEZNE_IZRACUN    return  varchar2;
  function GLAVNICE           return  varchar2;
  function UPLATE             return  varchar2;
  function ZATEZNE_REZULTAT   return  varchar2;

  procedure stvori_kolekciju_izracuna;
  
  procedure izbrisi_kolekciju_izracuna;
  
  procedure stvori_kolekciju_glavnica;
  
  procedure izbrisi_kolekciju_glavnica;
  
  procedure stvori_kolekciju_uplata;
  
  procedure izbrisi_kolekciju_uplata;
  
  procedure stvori_kolekciju_rezultata;
  
  procedure izbrisi_kolekciju_rezultata;
  
  procedure inicijalno_stvaranje_kolekcija;
  
  procedure clear_session_kolekcije;

  
  function novi_izracun(
      p_tip_izracuna_id     in     ju_tipovi_izracuna.id%type
     ,p_datum_izracuna      in     date
     ,p_opis                in     ju_izracun_zatezne.opis%type default null
  )
  return apex_collections.seq_id%type
  ;
  
  function nova_glavnica(
     p_iznos_glavnice       in      number
    ,p_datum_glavnice       in      date 
  )
  return number;
  
  procedure obrisi_glavnicu(
    p_seq_id                in      apex_collections.seq_id%type
  );
  
  procedure azuriraj_glavnicu(
    p_seq_id                in      apex_collections.seq_id%type
   ,p_iznos_glavnice        in      number
   ,p_datum_izracuna        in      date
   );
  
  function nova_uplata(
    p_iznos_uplate          in      number
   ,p_datum_uplate          in      date
  )
  return number;
  
  procedure obrisi_uplatu(
    p_seq_id                in      apex_collections.seq_id%type
  );
  
  procedure azuriraj_uplatu(
    p_seq_id                in      apex_collections.seq_id%type    
   ,p_iznos_uplate          in      number
   ,p_datum_uplate          in      date
  )
  ;
  
  function novi_rezultat_izracuna(
    p_izracun_rec           in      ju_session_rezultat_izracuna_v%rowtype
  )
  return number;
  
  function mogu_obaviti_izracun(
    p_tip_izracuna          in      number
   ,p_datum_izracuna        in      date
  )
  return boolean;
  
  function mogu_obaviti_izracun_YN(
    p_tip_izracuna          in      number
   ,p_datum_izracuna        in      date
  )
  return varchar2;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
  procedure izracun_session_zatezne;
-------------------------------------------------------------------------------
-- sprema session izracun u perzistentne izracune za korisnika
-------------------------------------------------------------------------------
  procedure save_session_izracun(
    p_user_id         in    ju_users.id%type
   ,p_vjerovnik_id    in    number
   ,p_duznik_id       in    number
  );

  procedure saved_izracun_to_session(
    p_izracun_id      in    ju_izracun_zatezne.id%type
  )
  ;

end;
/