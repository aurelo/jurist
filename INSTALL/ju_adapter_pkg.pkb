prompt
prompt Creating package body JU_ADAPTER_PKG
prompt ====================================
prompt
create or replace package body ju_adapter_pkg
is
   function glavnice_iz(
     p_apex_session     in    varchar2  
   )
   return   ju_tipovi_pkg.glavnica
   is
   begin
     null;
   end;

   function uplate_iz(
     p_apex_session     in    varchar2  
   )
   return   ju_tipovi_pkg.uplate
   is
   begin
     null;
   end;
   

   procedure obracun_u_session(
     p_obracun_zateznih_tab     in    ju_tipovi_pkg.izracun_kamate_tab_type
   )
   is
   begin
     null;
   end;
end ju_adapter_pkg;
/
