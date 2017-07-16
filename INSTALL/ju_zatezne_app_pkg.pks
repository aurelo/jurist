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
    )
    return   ju_izracun_zatezne.id%type
    ;
-------------------------------------------------------------------------------
    function get_obracun_data(
      p_obracun_id        in     ju_izracun_zatezne.id%type
    )
    return ju_izracun_zatezne%rowtype;
-------------------------------------------------------------------------------
    procedure clear_tables;
-------------------------------------------------------------------------------
    procedure izracun_zatezne(
      p_obracun_id        in     ju_izracun_zatezne.id%type
    );
-------------------------------------------------------------------------------
   function broj_glavnica_za_izracun(
      p_obracun_id        in     ju_izracun_zatezne.id%type
   )
   return number;
-------------------------------------------------------------------------------
   function broj_dijelova_izracuna(
      p_obracun_id        in     ju_izracun_zatezne.id%type
   )
   return number;
end;
/
