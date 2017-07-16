prompt
prompt Creating package body ju_integration_test_pkg
prompt =============================================
prompt
create or replace package body ju_integration_test_pkg
as
   --C_DUMMY_SESSION   constant ju_session_izracun_zatezne.session_context%type := 'ABC123456789S';

    procedure assert(
      p_test     in   boolean
     ,p_message  in   varchar2 default null
    )
    is
    begin
      if not p_test
      then
           dbms_output.put_line(nvl(p_message, 'Error in test!'));
           raise_application_error(-20001, nvl(p_message, 'Error in test!'));
      end if;
    end;

   procedure t_1_glavnica
   is
     v_obracun_id     ju_izracun_zatezne.id%type;

     v_cnt            number;
   begin
     ju_zatezne_app_pkg.clear_tables;

     v_obracun_id  := ju_zatezne_app_pkg.get_izracun_id(p_user_id         => 1, -- loaded user
                                                        p_tip_izracuna_id => 1,-- za fizicke osobe
                                                        p_datum_izracuna  => to_date('25.04.2014', 'dd.mm.yyyy'),
                                                        p_opis            => 'Izracun jedne glavnice');
     insert into ju_glavnice
      (
        id
       ,ize_id
       ,iznos
       ,datum_dospijeca
      )
      values
      (
        ju_zatezne_app_pkg.new_id
       ,v_obracun_id
       ,150
       ,to_date('05.05.2013', 'dd.mm.yyyy')
      )
      ;

      ju_zatezne_app_pkg.izracun_zatezne(v_obracun_id);

      commit;

      assert(ju_zatezne_app_pkg.broj_glavnica_za_izracun(v_obracun_id) = 1, 'Ocekujem jednu glavnicu za izracun: '||ju_zatezne_app_pkg.broj_glavnica_za_izracun(v_obracun_id));
      assert(ju_zatezne_app_pkg.broj_dijelova_izracuna(v_obracun_id) = 2, 'Ocekujem dva detalja izracuna, a dobio sam: '||ju_zatezne_app_pkg.broj_dijelova_izracuna(v_obracun_id));
   end;


   procedure test
   is
   begin

     t_1_glavnica;
   end;

end;
/

