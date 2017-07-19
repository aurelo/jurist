prompt
prompt Creating package body JU_ZATEZNE_APP_PKG
prompt ========================================
prompt
create or replace package body ju_zatezne_app_pkg
as
    function new_id
    return number
    is
    begin
       return ju_ize_seq.nextval;
    end;
-------------------------------------------------------------------------------
    function get_obracun_data(
      p_obracun_id        in     ju_izracun_zatezne.id%type
    )
    return ju_izracun_zatezne%rowtype
    is
      v_obracun_rec  ju_izracun_zatezne%rowtype;
      cursor cur_obracun
      is
      select    *
      from      ju_izracun_zatezne
      where     id = p_obracun_id
      ;
    begin
      open cur_obracun;

      fetch cur_obracun
      into  v_obracun_rec;

      close cur_obracun;

      return v_obracun_rec;
    end;

-------------------------------------------------------------------------------
    function get_izracun_id(
      p_user_id           in     ju_users.id%type
     ,p_tip_izracuna_id   in     ju_tipovi_izracuna.id%type
     ,p_datum_izracuna    in     date
     ,p_opis              in     ju_izracun_zatezne.opis%type
     ,p_vjerovnik_id      in     ju_izracun_zatezne.vjerovnik_id%type
     ,p_duznik_id         in     ju_izracun_zatezne.duznik_id%type
    )
    return   ju_izracun_zatezne.id%type
    is
      v_id ju_izracun_zatezne.id%type;
    begin
      insert into ju_izracun_zatezne (
        id,
        jus_id,
        tia_id,
        datum_izracuna,
        opis,
        vjerovnik_id,
        duznik_id,
        datum_kreacije
      )
      values
      (
        new_id,
        p_user_id,
        p_tip_izracuna_id,
        p_datum_izracuna,
        p_opis,
        p_vjerovnik_id,
        p_duznik_id,
        sysdate
      )
      returning id
      into v_id;

      return v_id;

    end;
-------------------------------------------------------------------------------
    procedure clear_tables
    is
    begin
      execute immediate 'truncate table ju_rezultat_izracuna';
      execute immediate 'truncate table ju_glavnice';
      execute immediate 'truncate table ju_uplate';
      delete from ju_izracun_zatezne cascade;
    end;
-------------------------------------------------------------------------------
    procedure izracun_zatezne(
      p_obracun_id        in     ju_izracun_zatezne.id%type
    )
    is
      v_glavnice_tab          ju_tipovi_pkg.glavnice;
      v_uplate_tab            ju_tipovi_pkg.uplate;

      v_obracun_header        ju_izracun_zatezne%rowtype;

      v_obracun_tab           ju_tipovi_pkg.izracun_kamate_tab_type;
    begin
      if p_obracun_id is null
      then
         return;
      end if;

      v_obracun_header := get_obracun_data(p_obracun_id);

      if    v_obracun_header.tia_id is null
      then
          return;
      end if;

      v_glavnice_tab  := ju_adapter_pkg.glavnice_iz(p_obracun_id);
      v_uplate_tab    := ju_adapter_pkg.uplate_iz(p_obracun_id);

      if v_glavnice_tab.count = 0
      then
         return;
      end if;

      v_obracun_tab := ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_tip_izracuna(p_tip_izracuna_id => v_obracun_header.tia_id),
                                                               p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                               p_glavnice_tab       => v_glavnice_tab,
                                                               p_uplate_tab         => v_uplate_tab,
                                                               p_datum_obracuna     => v_obracun_header.datum_izracuna);

      ju_adapter_pkg.obracun_u_session(p_obracun_id, v_obracun_tab);

      commit;
    end;
-------------------------------------------------------------------------------
   function broj_glavnica_za_izracun(
      p_obracun_id        in     ju_izracun_zatezne.id%type
   )
   return number
   is
     v_cnt  number;
   begin
     select    count(*)
     into      v_cnt
     from      ju_glavnice jse
     where     jse.ize_id = p_obracun_id;

     return v_cnt;
   end;

-------------------------------------------------------------------------------
   function broj_dijelova_izracuna(
      p_obracun_id        in     ju_izracun_zatezne.id%type
   )
   return number
   is
      v_cnt   number;
   begin
      select    count(*)
      into      v_cnt
      from      ju_rezultat_izracuna jsra
      where     jsra.ize_id = p_obracun_id
      ;

      return v_cnt;
   end;
-------------------------------------------------------------------------------
   procedure obrisi_spremljeni_izracun(
     p_izracun_id         in     ju_izracun_zatezne.id%type
   )
   is
   begin
     delete from ju_rezultat_izracuna ri where ri.ize_id = p_izracun_id;
     delete from ju_glavnice g where g.ize_id = p_izracun_id;
     delete from ju_uplate u where u.ize_id = p_izracun_id;
     delete from ju_izracun_zatezne where id = p_izracun_id;
     commit;
   end;
end;
/
