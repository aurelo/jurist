prompt
prompt Creating package JU_ZATEZNE_APP_PKG
prompt ===================================
prompt
create or replace package ju_zatezne_app_pkg
as
    function new_id
    return number
    ;

    function get_izracun_id(
      p_user_id           in     ju_users.id%type
     ,p_tip_izracuna_id   in     ju_tipovi_izracuna.id%type
     ,p_datum_izracuna    in     date
     ,p_opis              in     ju_izracun_zatezne.opis%type
     ,p_vjerovnik_id      in     ju_izracun_zatezne.vjerovnik_id%type
     ,p_duznik_id         in     ju_izracun_zatezne.duznik_id%type
    )
    return   ju_izracun_zatezne.id%type
    ;
-------------------------------------------------------------------------------
    function get_izracun_data(
      p_izracun_id        in     ju_izracun_zatezne.id%type
    )
    return ju_izracun_zatezne%rowtype;
-------------------------------------------------------------------------------
    procedure clear_tables;
-------------------------------------------------------------------------------
    procedure izracun_zatezne(
      p_izracun_id        in     ju_izracun_zatezne.id%type
    );
-------------------------------------------------------------------------------
   function broj_dugova_za_izracun(
      p_izracun_id        in     ju_izracun_zatezne.id%type
   )
   return number;
-------------------------------------------------------------------------------
   function broj_dijelova_izracuna(
      p_izracun_id        in     ju_izracun_zatezne.id%type
   )
   return number;
-------------------------------------------------------------------------------
   procedure obrisi_spremljeni_izracun(
     p_izracun_id         in     ju_izracun_zatezne.id%type
   )
   ;
end;
/
