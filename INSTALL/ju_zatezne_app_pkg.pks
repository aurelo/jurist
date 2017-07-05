prompt
prompt Creating package JU_ZATEZNE_APP_PKG
prompt ===================================
prompt
create or replace package ju_zatezne_app_pkg
as
    function new_session_id
    return number
    ;
    
    function get_session_izracun_id(
      p_session           in     ju_session_izracun_zatezne.session_context%type
     ,p_tip_izracuna_id   in     ju_tipovi_izracuna.id%type
     ,p_datum_izracuna    in     date
     ,p_opis              in     ju_session_izracun_zatezne.opis%type
    )
    return   ju_session_izracun_zatezne.id%type  
    ;
-------------------------------------------------------------------------------        
    function get_obracun_data(
      p_obracun_id        in     ju_session_izracun_zatezne.id%type
    )
    return ju_session_izracun_zatezne%rowtype; 
-------------------------------------------------------------------------------        
    procedure clear_session_tables;
-------------------------------------------------------------------------------    
    procedure izracun_session_zatezne(
      p_obracun_id        in     ju_session_izracun_zatezne.id%type
    );
-------------------------------------------------------------------------------    
   function broj_glavnica_za_izracun(
      p_obracun_id        in     ju_session_izracun_zatezne.id%type
   )
   return number;
-------------------------------------------------------------------------------
   function broj_dijelova_izracuna(
      p_obracun_id        in     ju_session_izracun_zatezne.id%type
   )
   return number;   
end;
/
