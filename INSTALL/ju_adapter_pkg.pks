prompt
prompt Creating package JU_ADAPTER_PKG
prompt ===============================
prompt
create or replace package ju_adapter_pkg is


   function glavnice_iz(
     p_obracun_id       in    ju_session_izracun_zatezne.id%type
--    ,p_session          in    varchar2
   )
   return   ju_tipovi_pkg.glavnice;
-------------------------------------------------------------------------------
   function uplate_iz(
     p_obracun_id       in    ju_session_izracun_zatezne.id%type
--    ,p_session          in    varchar2
   )
   return   ju_tipovi_pkg.uplate;
-------------------------------------------------------------------------------
   procedure obracun_u_session(
     p_obracun_id               in    ju_session_izracun_zatezne.id%type
    ,p_obracun_zateznih_tab     in    ju_tipovi_pkg.izracun_kamate_tab_type
   );

end ju_adapter_pkg;
/
