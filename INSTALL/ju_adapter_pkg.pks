prompt
prompt Creating package JU_ADAPTER_PKG
prompt ===============================
prompt
create or replace package ju_adapter_pkg is

   function dugovi_iz(
     p_izracun_id       in    ju_izracun_zatezne.id%type
   )
   return   ju_tipovi_pkg.dugovi;
-------------------------------------------------------------------------------
   function uplate_iz(
     p_izracun_id       in    ju_izracun_zatezne.id%type
   )
   return   ju_tipovi_pkg.uplate;
-------------------------------------------------------------------------------
   procedure obracun_u_session(
     p_izracun_id               in    ju_izracun_zatezne.id%type
    ,p_izracun_zateznih_tab     in    ju_tipovi_pkg.izracun_kamate_tab_type
   );

end ju_adapter_pkg;
/
