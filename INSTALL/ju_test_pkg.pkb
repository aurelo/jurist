prompt
prompt Creating package body JU_TEST_PKG
prompt =================================
prompt
CREATE OR REPLACE PACKAGE BODY ju_test_pkg
as
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
    procedure output_kamatne_stope_tab(
       p_kamatne_stope_tab     in    ju_tipovi_pkg.kamatne_stope_tab_type
    )
    is
    begin
       dbms_output.put_line('-----------------------');
       for i in 1..p_kamatne_stope_tab.count
       loop
           dbms_output.put_line('KS=> id:'||p_kamatne_stope_tab(i).id||' stopa:'||p_kamatne_stope_tab(i).stopa||' od-do: '||to_char(p_kamatne_stope_tab(i).datum_od, 'dd.mm.yyyy')||'-'||to_char(p_kamatne_stope_tab(i).datum_do, 'dd.mm.yyyy'));
       end loop;
    end;


    function glavnice_primjer
    return ju_tipovi_pkg.glavnica
    is
        v_glavnica_rec    ju_tipovi_pkg.transakcija_rec;
        v_glavnica_tab    ju_tipovi_pkg.glavnica;
    begin
----        v_glavnica_rec.opis := C_GLAVNICA_TIP;

        v_glavnica_rec.id    := 1;
        v_glavnica_rec.iznos := 185.78;
        v_glavnica_rec.datum := to_date('17.02.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 2;
        v_glavnica_rec.iznos := 45.89;
        v_glavnica_rec.datum := to_date('24.03.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 3;
        v_glavnica_rec.iznos := 176.71;
        v_glavnica_rec.datum := to_date('24.03.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 4;
        v_glavnica_rec.iznos := 176.71;
        v_glavnica_rec.datum := to_date('17.04.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 5;
        v_glavnica_rec.iznos := 176.71;
        v_glavnica_rec.datum := to_date('18.05.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 6;
        v_glavnica_rec.iznos := 176.71;
        v_glavnica_rec.datum := to_date('17.06.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 7;
        v_glavnica_rec.iznos := 176.71;
        v_glavnica_rec.datum := to_date('17.07.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 8;
        v_glavnica_rec.iznos := 176.71;
        v_glavnica_rec.datum := to_date('18.08.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 9;
        v_glavnica_rec.iznos := 1059.95;
        v_glavnica_rec.datum := to_date('23.09.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 10;
        v_glavnica_rec.iznos := 211.94;
        v_glavnica_rec.datum := to_date('23.09.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 11;
        v_glavnica_rec.iznos := 211.94;
        v_glavnica_rec.datum := to_date('17.10.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 12;
        v_glavnica_rec.iznos := 211.94;
        v_glavnica_rec.datum := to_date('17.11.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 13;
        v_glavnica_rec.iznos := 677.54;
        v_glavnica_rec.datum := to_date('11.12.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;


        v_glavnica_rec.id    := 14;
        v_glavnica_rec.iznos := 100;
        v_glavnica_rec.datum := to_date('27.02.2017', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;

        v_glavnica_rec.id    := 15;
        v_glavnica_rec.iznos := 3.27;
        v_glavnica_rec.datum := to_date('23.09.2016', 'dd.mm.yyyy');
        v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;


        return v_glavnica_tab;

    end;
-------------------------------------------------------------------------------
    function primjer_prve_glavnice
    return ju_tipovi_pkg.glavnica
    is
       v_rata_tab   ju_tipovi_pkg.glavnica;
    begin
       v_rata_tab(1) :=  glavnice_primjer()(1);

       return v_rata_tab;
    end;

-------------------------------------------------------------------------------
/*
    procedure t_proporcionalna_rata_fze
    is
       v_izracun_kamatne_stope_tab   ju_tipovi_pkg.kamatni_obracun_tab_type;

       v_naplata_dugovanja_rec       ju_tipovi_pkg.naplata_dugovanja_rec;
       v_naplata_dugovanja_tab       ju_tipovi_pkg.naplata_dugovanja_tab_type;

       v_prvi_dio_obracuna           ju_tipovi_pkg.kamatni_obracun_rec;
       v_drugi_dio_obracuna          ju_tipovi_pkg.kamatni_obracun_rec;
       v_treci_dio_obracuna          ju_tipovi_pkg.kamatni_obracun_rec;
    begin
       v_naplata_dugovanja_rec.stavka := 'G';

       v_naplata_dugovanja_rec.iznos    := 185.78;
       v_naplata_dugovanja_rec.datum_od := to_date('17.02.2016', 'dd.mm.yyyy');
       v_naplata_dugovanja_rec.datum_do := to_date('10.04.2017', 'dd.mm.yyyy');

       v_naplata_dugovanja_tab(1) := v_naplata_dugovanja_rec;

       v_izracun_kamatne_stope_tab := ju_ukamacivanje_engine_pkg.proporcionalni_obracun(v_naplata_dugovanja_tab, ju_konkretno_pkg.kamatne_stope_za_fizicke_osobe);

       assert(v_izracun_kamatne_stope_tab.count = 3, 'Ocekujem tri razdoblja ukamaĂ¦ivanja, a dobio: '||v_izracun_kamatne_stope_tab.count);

       -- provjeri rate obracuna
       v_prvi_dio_obracuna    := v_izracun_kamatne_stope_tab(1);
       v_drugi_dio_obracuna   := v_izracun_kamatne_stope_tab(2);
       v_treci_dio_obracuna   := v_izracun_kamatne_stope_tab(3);

       assert(v_prvi_dio_obracuna.datum_od = to_date('17.02.2016', 'dd.mm.yyyy'));
       assert(v_prvi_dio_obracuna.datum_do = to_date('30.06.2016', 'dd.mm.yyyy'));
       assert(v_prvi_dio_obracuna.broj_dana = 135);
       assert(v_prvi_dio_obracuna.kamatna_stopa_obracuna = 8.05);
       assert(v_prvi_dio_obracuna.kamata = 5.52);

       assert(v_drugi_dio_obracuna.datum_od = to_date('01.07.2016', 'dd.mm.yyyy'));
       assert(v_drugi_dio_obracuna.datum_do = to_date('31.12.2016', 'dd.mm.yyyy'));
       assert(v_drugi_dio_obracuna.broj_dana = 184);
       assert(v_drugi_dio_obracuna.kamatna_stopa_obracuna = 7.88);
       assert(v_drugi_dio_obracuna.kamata = 7.36);

       assert(v_treci_dio_obracuna.datum_od = to_date('01.01.2017', 'dd.mm.yyyy'));
       assert(v_treci_dio_obracuna.datum_do = to_date('10.04.2017', 'dd.mm.yyyy'));
       assert(v_treci_dio_obracuna.broj_dana = 100);
       assert(v_treci_dio_obracuna.kamatna_stopa_obracuna = 7.68);
       assert(v_treci_dio_obracuna.kamata = 3.91);

       -- provjeri sume
       assert(ju_ukamacivanje_engine_pkg.suma_kamata(v_izracun_kamatne_stope_tab) = 5.52 + 7.36 + 3.91);
       assert(ju_ukamacivanje_engine_pkg.suma_osnovice(v_naplata_dugovanja_tab) = 185.78);--osnovnica je samo jedna
    end;
*/
-------------------------------------------
-- TEST INTERNE STRUKTURE
-------------------------------------------
    procedure t_podjela_glavnice_po_ks
    is
    begin
      null;
    end;
-------------------------------------------
-- KRAJ TEST INTERNE STRUKTURE
-------------------------------------------


-------------------------------------------------------------------------------
    function t_prop_fze_rate
    return boolean
    is
      v_rata     ju_tipovi_pkg.transakcija_rec;
    begin
      v_rata := glavnice_primjer()(1);

      return false;
    end;
-------------------------------------------------------------------------------
    procedure t_nacin_izracuna
    is
       v_kamatne_stope_tab    ju_tipovi_pkg.kamatne_stope_tab_type;
    begin
       -- daj kamatne stope za fizicke osobe
       v_kamatne_stope_tab := ju_model_pkg.kamatne_stope_za_tip_izracuna(1);

       --output_kamatne_stope_tab(v_kamatne_stope_tab);
       assert(v_kamatne_stope_tab.count = 11, 'Za fizicke osobe ocekujem 11 kamatnih stopa, a dobio '||v_kamatne_stope_tab.count);

       assert(v_kamatne_stope_tab(1).stopa = 30);
       assert(v_kamatne_stope_tab(1).datum_od = to_date('30.05.1994', 'dd.mm.yyyy'));
       assert(v_kamatne_stope_tab(1).datum_do = to_date('30.06.1994', 'dd.mm.yyyy'));

       assert(v_kamatne_stope_tab(11).stopa = 7.68);
       assert(v_kamatne_stope_tab(11).datum_od = to_date('01.01.2017', 'dd.mm.yyyy'));
       assert(v_kamatne_stope_tab(11).datum_do = to_date('30.06.2017', 'dd.mm.yyyy'));

       -- daj kamatne stope za pravne osobe
       v_kamatne_stope_tab.delete;
       v_kamatne_stope_tab := ju_model_pkg.kamatne_stope_za_tip_izracuna(21);

       --output_kamatne_stope_tab(v_kamatne_stope_tab);
       assert(v_kamatne_stope_tab.count = 11, 'Za obicne pravne osobe ocekujem 11 kamatnih stopa, a dobio '||v_kamatne_stope_tab.count);

       assert(v_kamatne_stope_tab(1).stopa = 30);
       assert(v_kamatne_stope_tab(1).datum_od = to_date('30.05.1994', 'dd.mm.yyyy'));
       assert(v_kamatne_stope_tab(1).datum_do = to_date('30.06.1994', 'dd.mm.yyyy'));

       assert(v_kamatne_stope_tab(11).stopa = 9.68, 'Neispravana kamatna stopa');
       assert(v_kamatne_stope_tab(11).datum_od = to_date('01.01.2017', 'dd.mm.yyyy'));
       assert(v_kamatne_stope_tab(11).datum_do = to_date('30.06.2017', 'dd.mm.yyyy'));


       -- daj kamatne stope za pravne osobe - zakon o ovrsi
       v_kamatne_stope_tab.delete;
       v_kamatne_stope_tab := ju_model_pkg.kamatne_stope_za_tip_izracuna(41);


       --output_kamatne_stope_tab(v_kamatne_stope_tab);
       assert(v_kamatne_stope_tab.count = 16, 'Za predstecajne ocekujem 16 kamatnih stopa, a dobio '||v_kamatne_stope_tab.count);

       assert(v_kamatne_stope_tab(1).stopa = 30);
       assert(v_kamatne_stope_tab(1).datum_od = to_date('30.05.1994', 'dd.mm.yyyy'));
       assert(v_kamatne_stope_tab(1).datum_do = to_date('30.06.1994', 'dd.mm.yyyy'));

       assert(v_kamatne_stope_tab(7).stopa = 15);
       assert(v_kamatne_stope_tab(7).datum_od = to_date('01.07.2011', 'dd.mm.yyyy'));
       assert(v_kamatne_stope_tab(7).datum_do = to_date('29.06.2013', 'dd.mm.yyyy'));

       assert(v_kamatne_stope_tab(16).stopa = 9.68, 'Neispravana kamatna stopa');
       assert(v_kamatne_stope_tab(16).datum_od = to_date('01.01.2017', 'dd.mm.yyyy'));
       assert(v_kamatne_stope_tab(16).datum_do = to_date('30.06.2017', 'dd.mm.yyyy'));

    end;

-------------------------------------------------------------------------------
    procedure t_podjelu_glavnice_po_ks
    is
         v_period_tt  ju_tipovi_pkg.periodi_izracuna_glavnice_tt;

         v_dug_rec            ju_tipovi_pkg.transakcija_rec;
    begin
         v_period_tt :=
         ju_obracun_kamate_pkg.podjela_glavnice_po_ksu(p_glavnica          => glavnice_primjer()(1),
                                                       p_kamatne_stope_tab => ju_model_pkg.kamatne_stope_za_fizicke,
                                                       p_datum_obracuna    => to_date('10.04.2017', 'dd.mm.yyyy'));

         assert(v_period_tt.count = 3, 'Neispravno podijeljena jedna rata po propisanim kamatnim stopama');

         assert(v_period_tt(1).iznos = 185.78);
         assert(v_period_tt(1).datum_od = to_date('17.02.2016', 'dd.mm.yyyy'));
         assert(v_period_tt(1).datum_do = to_date('30.06.2016', 'dd.mm.yyyy'));
         assert(v_period_tt(1).kamatna_stopa = 8.05);

         assert(v_period_tt(2).iznos = 185.78);
         assert(v_period_tt(2).datum_od = to_date('01.07.2016', 'dd.mm.yyyy'));
         assert(v_period_tt(2).datum_do = to_date('31.12.2016', 'dd.mm.yyyy'));
         assert(v_period_tt(2).kamatna_stopa = 7.88);

         assert(v_period_tt(3).iznos = 185.78);
         assert(v_period_tt(3).datum_od = to_date('01.01.2017', 'dd.mm.yyyy'));
         assert(v_period_tt(3).datum_do = to_date('10.04.2017', 'dd.mm.yyyy'));
         assert(v_period_tt(3).kamatna_stopa = 7.68);

         ----  drugi primjer
         v_dug_rec.id    := 1;
         v_dug_rec.iznos := 150;
         v_dug_rec.datum := to_date('01.05.2002', 'dd.mm.yyyy');

         v_period_tt :=
         ju_obracun_kamate_pkg.podjela_glavnice_po_ksu(p_glavnica          => v_dug_rec,
                                                       p_kamatne_stope_tab => ju_model_pkg.kamatne_stope_za_fizicke,
                                                       p_datum_obracuna    => to_date('05.04.2004', 'dd.mm.yyyy'));

         assert(v_period_tt.count = 4, 'Ocekujem 4 podijele rate po propisanim kamatnim stopama, a dobio: '||v_period_tt.count);

         assert(v_period_tt(1).iznos = 150);
         assert(v_period_tt(1).datum_od = to_date('01.05.2002', 'dd.mm.yyyy'));
         assert(v_period_tt(1).datum_do = to_date('30.06.2002', 'dd.mm.yyyy'));
         assert(v_period_tt(1).kamatna_stopa = 18);

         assert(v_period_tt(2).iznos = 150);
         assert(v_period_tt(2).datum_od = to_date('01.07.2002', 'dd.mm.yyyy'));
         assert(v_period_tt(2).datum_do = to_date('31.12.2002', 'dd.mm.yyyy'));
         assert(v_period_tt(2).kamatna_stopa = 15);

         assert(v_period_tt(3).iznos = 150);
         assert(v_period_tt(3).datum_od = to_date('01.01.2003', 'dd.mm.yyyy'));
         assert(v_period_tt(3).datum_do = to_date('31.12.2003', 'dd.mm.yyyy'));
         assert(v_period_tt(3).kamatna_stopa = 15);

         assert(v_period_tt(4).iznos = 150);
         assert(v_period_tt(4).datum_od = to_date('01.01.2004', 'dd.mm.yyyy'));
         assert(v_period_tt(4).datum_do = to_date('05.04.2004', 'dd.mm.yyyy'));
         assert(v_period_tt(4).kamatna_stopa = 15);


    end;

-------------------------------------------------------------------------------
-- testovi za odreĂ°ivanje nacina izracuna kamate
    procedure t_odredivanje_nacina_izracuna
    is
       v_rata                       ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec;
       v_nacin_obracuna_kamate_tab  ju_tipovi_pkg.period_nacin_izracuna_tt;
    begin
      v_rata.glavnica_id := 1;
      v_rata.iznos       := 150;
      v_rata.datum_od    := to_date('01.05.2004', 'dd.mm.yyyy');
      v_rata.datum_do    := to_date('31.12.2004', 'dd.mm.yyyy');

      v_nacin_obracuna_kamate_tab := ju_obracun_kamate_pkg.nacin_izracuna_kamate(
       p_period_glavnica_ks    => v_rata
      ,p_nacin_obracuna_tab    => ju_model_pkg.nacin_obracuna_kamate
     );

     assert(v_nacin_obracuna_kamate_tab.count = 2, 'Ocekujem dva perioda izracuna, a dobio: '||v_nacin_obracuna_kamate_tab.count);

     assert(v_nacin_obracuna_kamate_tab(1).nacin_obracuna = ju_tipovi_pkg.KONFORMNI_OBRACUN, 'Ocekujem konformni, a dobio: '||v_nacin_obracuna_kamate_tab(1).nacin_obracuna);
     assert(v_nacin_obracuna_kamate_tab(1).datum_od = to_date('01.05.2004', 'dd.mm.yyyy'), 'Dobio datum_od: '||v_nacin_obracuna_kamate_tab(1).datum_od);
     assert(v_nacin_obracuna_kamate_tab(1).datum_do = to_date('19.07.2004', 'dd.mm.yyyy'), 'Dobio datum_do: '||v_nacin_obracuna_kamate_tab(1).datum_do);

     assert(v_nacin_obracuna_kamate_tab(2).nacin_obracuna = ju_tipovi_pkg.PROPORCIONALNI_OBRACUN);
     assert(v_nacin_obracuna_kamate_tab(2).datum_od = to_date('20.07.2004', 'dd.mm.yyyy'));
     assert(v_nacin_obracuna_kamate_tab(2).datum_do = to_date('31.12.2004', 'dd.mm.yyyy'));

     -- jedan nacin obracuna
      v_rata.glavnica_id := 1;
      v_rata.iznos       := 150;
      v_rata.datum_od    := to_date('15.05.2016', 'dd.mm.yyyy');
      v_rata.datum_do    := to_date('04.02.2017', 'dd.mm.yyyy');

      v_nacin_obracuna_kamate_tab := ju_obracun_kamate_pkg.nacin_izracuna_kamate(
       p_period_glavnica_ks    => v_rata
      ,p_nacin_obracuna_tab    => ju_model_pkg.nacin_obracuna_kamate
     );

     assert(v_nacin_obracuna_kamate_tab.count = 1, 'Ocekujem samo proporcionalni izracun, a dobio: '||v_nacin_obracuna_kamate_tab.count);

     assert(v_nacin_obracuna_kamate_tab(1).nacin_obracuna = ju_tipovi_pkg.PROPORCIONALNI_OBRACUN);
     assert(v_nacin_obracuna_kamate_tab(1).datum_od = to_date('15.05.2016', 'dd.mm.yyyy'), 'Ocekujem pocetak perioda 15.05.2016, a dobio: '||v_nacin_obracuna_kamate_tab(1).datum_od);
     assert(v_nacin_obracuna_kamate_tab(1).datum_do = to_date('04.02.2017', 'dd.mm.yyyy'));



    end;
-------------------------------------------------------------------------------
-- test za odreĂ°ivanje uplata u periodu glavnice
   procedure t_uplate_unutar_glavnica
   is
       v_glavnica_sa_periodima_r       ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec;
       v_uplata1                       ju_tipovi_pkg.transakcija_rec;
       v_uplata2                       ju_tipovi_pkg.transakcija_rec;

       v_sve_uplate_tab                ju_tipovi_pkg.uplate;
       v_uplate_unutar_glavnice_tab    ju_obracun_kamate_pkg.temporal_uplate_tab_type;-- ju_tipovi_pkg.uplate;
   begin
      v_glavnica_sa_periodima_r.glavnica_id   := 1;
      v_glavnica_sa_periodima_r.iznos         := 150;
      v_glavnica_sa_periodima_r.datum_od      := to_date('15.05.2016', 'dd.mm.yyyy');
      v_glavnica_sa_periodima_r.datum_do      := to_date('12.02.2017', 'dd.mm.yyyy');
      v_glavnica_sa_periodima_r.kamatna_stopa := 8.08;



      v_uplata1.id    := 1;
      v_uplata1.iznos := 15;

      v_uplata2.id    := 2;
      v_uplata2.iznos := 35;


      -- jedna uplata unutar perioda
      v_uplata1.datum := to_date('31.05.2016', 'dd.mm.yyyy');

      v_sve_uplate_tab.delete;
      v_sve_uplate_tab(1) := v_uplata1;

      v_uplate_unutar_glavnice_tab := ju_obracun_kamate_pkg.uplate_sjele_u_periodu(
          v_glavnica_sa_periodima_r
         ,ju_obracun_kamate_pkg.indeksiraj_uplate(v_sve_uplate_tab)
      );

      assert(v_uplate_unutar_glavnice_tab.count = 1);
      assert(v_uplate_unutar_glavnice_tab(1).uplata_id = 1);
      assert(v_uplate_unutar_glavnice_tab(1).datum_uplate = to_date('31.05.2016', 'dd.mm.yyyy'));


      -- uplata sjela iza obracuna zatezne za glavnicu
      v_uplata1.datum := to_date('31.03.2017', 'dd.mm.yyyy');

      v_sve_uplate_tab.delete;
      v_uplate_unutar_glavnice_tab.delete;

      v_sve_uplate_tab(1) := v_uplata1;

      v_uplate_unutar_glavnice_tab := ju_obracun_kamate_pkg.uplate_sjele_u_periodu(
          v_glavnica_sa_periodima_r
         ,ju_obracun_kamate_pkg.indeksiraj_uplate(v_sve_uplate_tab)
      );

      assert(v_uplate_unutar_glavnice_tab.count = 0, 'Ne ocekujem utjecaj uplate na glavnicu!');

     -- uplata sjela prije obracuna zatezne za glavnicu
      v_uplata1.datum := to_date('10.05.2016', 'dd.mm.yyyy');

      v_sve_uplate_tab.delete;
      v_uplate_unutar_glavnice_tab.delete;

      v_sve_uplate_tab(1) := v_uplata1;

      v_uplate_unutar_glavnice_tab := ju_obracun_kamate_pkg.uplate_sjele_u_periodu(
          v_glavnica_sa_periodima_r
         ,ju_obracun_kamate_pkg.indeksiraj_uplate(v_sve_uplate_tab)
      );

      assert(v_uplate_unutar_glavnice_tab.count = 1, 'Avans bi trebao smanjivati glavnicu!');

     -- dvije uplate na isti datum
      v_uplata1.datum := to_date('31.05.2016', 'dd.mm.yyyy');
      v_uplata2.datum := to_date('31.05.2016', 'dd.mm.yyyy');

      v_sve_uplate_tab.delete;
      v_uplate_unutar_glavnice_tab.delete;

      v_sve_uplate_tab(1) := v_uplata1;
      v_sve_uplate_tab(2) := v_uplata2;

      v_uplate_unutar_glavnice_tab := ju_obracun_kamate_pkg.uplate_sjele_u_periodu(
          v_glavnica_sa_periodima_r
         ,ju_obracun_kamate_pkg.indeksiraj_uplate(v_sve_uplate_tab)
      );

      assert(v_uplate_unutar_glavnice_tab.count = 2, 'Dvije uplate na isti datum obje utjecu na glavnicu!');


     -- dvije uplate, jedna nakon dospijeĂ¦a
      v_uplata1.datum := to_date('31.05.2016', 'dd.mm.yyyy');
      v_uplata2.datum := to_date('30.06.2017', 'dd.mm.yyyy');

      v_sve_uplate_tab.delete;
      v_uplate_unutar_glavnice_tab.delete;

      v_sve_uplate_tab(1) := v_uplata1;
      v_sve_uplate_tab(2) := v_uplata2;

      v_uplate_unutar_glavnice_tab := ju_obracun_kamate_pkg.uplate_sjele_u_periodu(
          v_glavnica_sa_periodima_r
         ,ju_obracun_kamate_pkg.indeksiraj_uplate(v_sve_uplate_tab)
      );

      assert(v_uplate_unutar_glavnice_tab.count = 1, 'Dvije uplate na isti datum obje utjecu na glavnicu!');


   end;

-------------------------------------------------------------------------------
-- test izracuna kamate po metodama izracuna (proporcionalna i konformna)
   procedure t_metode_obracuna_kamate
   is
       v_kamata   number;
   begin
     -- konformni ne prestupna godina
     v_kamata := ju_obracun_kamate_pkg.konformna_kamata(p_osnovica       => 150,
                                                        p_kamatna_stopa   => 18,
                                                        p_broj_dana       => 61,
                                                        p_godina_obracuna => 2002);

     assert(v_kamata = 4.21, 'Ocekujem 4.21 kamatu, a dobio: '||v_kamata);

     -- proporcionalni prestupna godina
     v_kamata := ju_obracun_kamate_pkg.proporcionalna_kamata( p_osnovica        => 150,
                                                              p_kamatna_stopa   => 15,
                                                              p_broj_dana       => 165,
                                                              p_godina_obracuna => 2004);

     assert(v_kamata = 10.14, 'Ocekujem 10.14 kamatu, a dobio: '||v_kamata);

     -- proporcionalni normalna godina
     v_kamata := ju_obracun_kamate_pkg.proporcionalna_kamata( p_osnovica        => 150,
                                                              p_kamatna_stopa   => 15,
                                                              p_broj_dana       => 365,
                                                              p_godina_obracuna => 2006);

     assert(v_kamata = 22.50, 'Ocekujem 20.50 kamatu, a dobio: '||v_kamata);

   end;

-------------------------------------------------------------------------------
    procedure t_zateznu_za_jednu_glavnicu
    is
         v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
         v_nema_uplata_tab    ju_tipovi_pkg.uplate;
    begin
         v_obracun_tab := ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_fizicke,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => primjer_prve_glavnice,
                                                                  p_uplate_tab         => v_nema_uplata_tab,
                                                                  p_datum_obracuna     => to_date('10.04.2017', 'dd.mm.yyyy'));

         assert(v_obracun_tab.count = 3);
    end;
-------------------------------------------------------------------------------
    procedure t_primjer_bez_uplata
    is
         v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
         v_nema_uplata_tab    ju_tipovi_pkg.uplate;

         v_suma_glavnice      number;
         v_suma_kamate        number;
    begin
         v_obracun_tab := ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_fizicke,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => glavnice_primjer,
                                                                  p_uplate_tab         => v_nema_uplata_tab,
                                                                  p_datum_obracuna     => to_date('10.04.2017', 'dd.mm.yyyy'));

         assert(v_obracun_tab.count = 35, 'Ocekujem 35 razdoblja uplate, a dobio: '||v_obracun_tab.count);

         v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
         v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
         
         --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);
         
         assert(v_suma_glavnice = 3768.51, 'Ocekujem sumu glavnice 3768.51, a dobio: '||v_suma_glavnice);
         assert(v_suma_kamate = 178.41, 'Ocekujem sumu kamate 178.39 + 0.02 (krivi izracun jedne rate u primjeru), a dobio: '||v_suma_kamate);
    end;
------------------------------------------------------------------------------
   procedure t_eodvjetnik_primjer1
   is
         v_dug_rec            ju_tipovi_pkg.transakcija_rec;
         v_glavnice_tab       ju_tipovi_pkg.glavnica;

         v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
         v_nema_uplata_tab    ju_tipovi_pkg.uplate;

         v_suma_glavnice      number;
         v_suma_kamate        number;

         v_izracun_rate       ju_tipovi_pkg.izracun_kamate_rec;
    begin
         v_dug_rec.id    := 1;
         v_dug_rec.iznos := 150;
         v_dug_rec.datum := to_date('01.05.2002', 'dd.mm.yyyy');

         v_glavnice_tab(1) := v_dug_rec;

         v_obracun_tab := ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_fizicke,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnice_tab,
                                                                  p_uplate_tab         => v_nema_uplata_tab,
                                                                  p_datum_obracuna     => to_date('05.04.2014', 'dd.mm.yyyy'));

        -- assert(v_obracun_tab.count = 9, 'Ocekujem 9 razdoblja uplate, a dobio: '||v_obracun_tab.count);

         v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
         v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
         
         --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);
         
         assert(v_suma_glavnice = 150, 'Ocekujem sumu glavnice 150, a dobio: '||v_suma_glavnice);
         assert(v_suma_kamate = 250.74, 'Ocekujem sumu kamate 250.74, a dobio: '||v_suma_kamate);
         assert(v_obracun_tab.count = 16, 'Ocekujem 16 izracuna rata, a dobio: '||v_obracun_tab.count);

         -- prava rata
         v_izracun_rate := v_obracun_tab(1);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150);
         assert(v_izracun_rate.datum_od = to_date('01.05.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('30.06.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.zatezna_kamata = 4.21);

         -- druga rata
         v_izracun_rate := v_obracun_tab(2);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150, 'Ocekujem osnovicu po glavnici 150, a dobio: '||v_izracun_rate.osnovica_izracuna_po_glavnici);
         assert(v_izracun_rate.osnovica_izracuna_po_kamati = 4.21, 'Ocekujem osnovicu po kamati 4.21, a dobio: '||v_izracun_rate.osnovica_izracuna_po_glavnici);
         assert(v_izracun_rate.datum_od = to_date('01.07.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('31.12.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.nacin_izracuna_kamate = ju_tipovi_pkg.KONFORMNI_OBRACUN, 'Ocekujem konformni obracun!');
         assert(v_izracun_rate.zatezna_kamata = 11.26);
   end;
-------------------------------------------------------------------------------
   procedure t_eodvjetnik_primjer2
   is
         v_dug_rec            ju_tipovi_pkg.transakcija_rec;
         v_glavnice_tab       ju_tipovi_pkg.glavnica;

         v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
         v_nema_uplata_tab    ju_tipovi_pkg.uplate;

         v_suma_glavnice      number;
         v_suma_kamate        number;

         v_izracun_rate       ju_tipovi_pkg.izracun_kamate_rec;
    begin
         v_dug_rec.id    := 1;
         v_dug_rec.iznos := 150;
         v_dug_rec.datum := to_date('01.05.2002', 'dd.mm.yyyy');

         v_glavnice_tab(1) := v_dug_rec;

         v_obracun_tab := ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_pravne,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnice_tab,
                                                                  p_uplate_tab         => v_nema_uplata_tab,
                                                                  p_datum_obracuna     => to_date('05.04.2014', 'dd.mm.yyyy'));

        -- assert(v_obracun_tab.count = 9, 'Ocekujem 9 razdoblja uplate, a dobio: '||v_obracun_tab.count);

         v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
         --dbms_output.put_line('kamata primjer 2');
         v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
         assert(v_suma_glavnice = 150, 'Ocekujem sumu glavnice 150, a dobio: '||v_suma_glavnice);
         assert(v_suma_kamate = 278.93, 'Ocekujem sumu kamate 278.93, a dobio: '||v_suma_kamate);
         assert(v_obracun_tab.count = 16, 'Ocekujem 16 izracuna rata, a dobio: '||v_obracun_tab.count);

         -- prava rata
         v_izracun_rate := v_obracun_tab(1);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150);
         assert(v_izracun_rate.datum_od = to_date('01.05.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('30.06.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.zatezna_kamata = 4.21);

         -- druga rata
         v_izracun_rate := v_obracun_tab(2);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150, 'Ocekujem osnovicu izracuna po glavnici 150, a dobio: '||v_izracun_rate.osnovica_izracuna_po_glavnici);
         assert(v_izracun_rate.osnovica_izracuna_po_kamati = 4.21);
         assert(v_izracun_rate.datum_od = to_date('01.07.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('31.12.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.nacin_izracuna_kamate = ju_tipovi_pkg.KONFORMNI_OBRACUN, 'Ocekujem konformni obracun!');
         assert(v_izracun_rate.zatezna_kamata = 11.26);

         -- zadnja rata
         v_izracun_rate := v_obracun_tab(16);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150.0);
         assert(v_izracun_rate.datum_od = to_date('01.01.2014', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('05.04.2014', 'dd.mm.yyyy'));
         assert(v_izracun_rate.nacin_izracuna_kamate = ju_tipovi_pkg.PROPORCIONALNI_OBRACUN, 'Ocekujem proporcionalni obracun!');
         assert(v_izracun_rate.zatezna_kamata = 5.86);
   end;
-------------------------------------------------------------------------------
 procedure t_eodvjetnik_primjer3
   is
         v_dug_rec            ju_tipovi_pkg.transakcija_rec;
         v_glavnice_tab       ju_tipovi_pkg.glavnica;

         v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
         v_nema_uplata_tab    ju_tipovi_pkg.uplate;

         v_suma_glavnice      number;
         v_suma_kamate        number;

         v_izracun_rate       ju_tipovi_pkg.izracun_kamate_rec;
    begin
         v_dug_rec.id    := 1;
         v_dug_rec.iznos := 150;
         v_dug_rec.datum := to_date('01.05.2002', 'dd.mm.yyyy');

         v_glavnice_tab(1) := v_dug_rec;

         v_obracun_tab := ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_predstecajne,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnice_tab,
                                                                  p_uplate_tab         => v_nema_uplata_tab,
                                                                  p_datum_obracuna     => to_date('05.04.2014', 'dd.mm.yyyy'));

        -- assert(v_obracun_tab.count = 9, 'Ocekujem 9 razdoblja uplate, a dobio: '||v_obracun_tab.count);

         v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
         v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
         assert(v_suma_glavnice = 150, 'Ocekujem sumu glavnice 150, a dobio: '||v_suma_glavnice);
         assert(v_suma_kamate = 275.92, 'Ocekujem sumu kamate 275.92, a dobio: '||v_suma_kamate);
         assert(v_obracun_tab.count = 17, 'Ocekujem 17 izracuna rata, a dobio: '||v_obracun_tab.count);

         -- prava rata
         v_izracun_rate := v_obracun_tab(1);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150);
         assert(v_izracun_rate.datum_od = to_date('01.05.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('30.06.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.zatezna_kamata = 4.21);

         -- druga rata
         v_izracun_rate := v_obracun_tab(2);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150);
         assert(v_izracun_rate.osnovica_izracuna_po_kamati = 4.21);
         assert(v_izracun_rate.datum_od = to_date('01.07.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('31.12.2002', 'dd.mm.yyyy'));
         assert(v_izracun_rate.nacin_izracuna_kamate = ju_tipovi_pkg.KONFORMNI_OBRACUN, 'Ocekujem konformni obracun!');
         assert(v_izracun_rate.zatezna_kamata = 11.26);

         -- zadnja rata
         v_izracun_rate := v_obracun_tab(17);
         assert(v_izracun_rate.osnovica_izracuna_po_glavnici = 150.0);
         assert(v_izracun_rate.datum_od = to_date('01.01.2014', 'dd.mm.yyyy'));
         assert(v_izracun_rate.datum_do = to_date('05.04.2014', 'dd.mm.yyyy'));
         assert(v_izracun_rate.nacin_izracuna_kamate = ju_tipovi_pkg.PROPORCIONALNI_OBRACUN, 'Ocekujem proporcionalni obracun!');
         assert(v_izracun_rate.zatezna_kamata = 4.82);
   end;
-------------------------------------------------------------------------------
   procedure t_primjer_uplate1
   is
     v_glavnica_rec    ju_tipovi_pkg.transakcija_rec;
     v_glavnica_tab    ju_tipovi_pkg.glavnica;
     
     v_uplata_rec      ju_tipovi_pkg.transakcija_rec;
     v_uplata_tab      ju_tipovi_pkg.uplate;
     
     v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
     
     v_suma_glavnice      number;
     v_suma_kamate        number;
   begin
     v_glavnica_rec.id     := 1;
     v_glavnica_rec.iznos  := 120;
     v_glavnica_rec.datum  := to_date('05.01.2012', 'dd.mm.yyyy');
     
     v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;
     
     
     v_uplata_rec.id       := 1;
     v_uplata_rec.iznos    := 35;
     v_uplata_rec.datum    := to_date('06.05.2013', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 
     
     
     v_obracun_tab  :=    ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_pravne,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnica_tab,
                                                                  p_uplate_tab         => v_uplata_tab,
                                                                  p_datum_obracuna     => to_date('03.07.2015', 'dd.mm.yyyy'));
                                                                  
     v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
     v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
     
     --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);    
     
     assert(v_suma_glavnice = 108.96, 'Ocekujem glavnicu 108.96, a dobio sam '||v_suma_glavnice);                                                    
     assert(v_suma_kamate = 35.33, 'Ocekujem kamatu 35.33, a dobio sam '||v_suma_kamate);  

   end;
-------------------------------------------------------------------------------
   procedure t_primjer_uplate_avansa
   is
     v_glavnica_rec    ju_tipovi_pkg.transakcija_rec;
     v_glavnica_tab    ju_tipovi_pkg.glavnica;
     
     v_uplata_rec      ju_tipovi_pkg.transakcija_rec;
     v_uplata_tab      ju_tipovi_pkg.uplate;
     
     v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
     
     v_suma_glavnice      number;
     v_suma_kamate        number;
   begin
     v_glavnica_rec.id     := 1;
     v_glavnica_rec.iznos  := 120;
     v_glavnica_rec.datum  := to_date('05.01.2012', 'dd.mm.yyyy');
     
     v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;
     
     
     v_uplata_rec.id       := 1;
     v_uplata_rec.iznos    := 125;
     v_uplata_rec.datum    := to_date('06.05.2011', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 
     
     
     v_obracun_tab  :=    ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_pravne,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnica_tab,
                                                                  p_uplate_tab         => v_uplata_tab,
                                                                  p_datum_obracuna     => to_date('03.07.2015', 'dd.mm.yyyy'));
                                                                  
     v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
     v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
     
     --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);    
     
     assert(v_suma_glavnice = 0, 'Za avanse vece od duga ocekujem glavnicu 0, a dobio sam '||v_suma_glavnice);                                                    
     assert(v_suma_kamate = 0, 'Za avanse vece od duga ocekujem kamatu 0, a dobio sam '||v_suma_kamate);  

   end;
-------------------------------------------------------------------------------
   procedure t_primjer_dvije_uplate
   is
     v_glavnica_rec    ju_tipovi_pkg.transakcija_rec;
     v_glavnica_tab    ju_tipovi_pkg.glavnica;
     
     v_uplata_rec      ju_tipovi_pkg.transakcija_rec;
     v_uplata_tab      ju_tipovi_pkg.uplate;
     
     v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
     
     v_suma_glavnice      number;
     v_suma_kamate        number;
   begin
     v_glavnica_rec.id     := 1;
     v_glavnica_rec.iznos  := 120;
     v_glavnica_rec.datum  := to_date('05.01.2012', 'dd.mm.yyyy');
     
     v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;
     
     
     v_uplata_rec.id       := 1;
     v_uplata_rec.iznos    := 35;
     v_uplata_rec.datum    := to_date('06.05.2013', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 
     

     v_uplata_rec.id       := 2;
     v_uplata_rec.iznos    := 100;
     v_uplata_rec.datum    := to_date('15.08.2014', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 


     
     v_obracun_tab  :=    ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_pravne,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnica_tab,
                                                                  p_uplate_tab         => v_uplata_tab,
                                                                  p_datum_obracuna     => to_date('03.04.2015', 'dd.mm.yyyy'));
                                                                  
     v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
     v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
     
     --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);    
     
     assert(v_suma_glavnice = 29.83, 'Ocekujem glavnicu 29.83, a dobio sam '||v_suma_glavnice);                                                    
     assert(v_suma_kamate = 2.84, 'Ocekujem kamatu 2.84, a dobio sam '||v_suma_kamate);  

   end;
-------------------------------------------------------------------------------
   procedure t_primjer_zatvaranja
   is
     v_glavnica_rec    ju_tipovi_pkg.transakcija_rec;
     v_glavnica_tab    ju_tipovi_pkg.glavnica;
     
     v_uplata_rec      ju_tipovi_pkg.transakcija_rec;
     v_uplata_tab      ju_tipovi_pkg.uplate;
     
     v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
     
     v_suma_glavnice      number;
     v_suma_kamate        number;
   begin
     v_glavnica_rec.id     := 1;
     v_glavnica_rec.iznos  := 120;
     v_glavnica_rec.datum  := to_date('05.01.2012', 'dd.mm.yyyy');
     
     v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;
     
     
     v_uplata_rec.id       := 1;
     v_uplata_rec.iznos    := 35;
     v_uplata_rec.datum    := to_date('06.05.2013', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 
     

     v_uplata_rec.id       := 2;
     v_uplata_rec.iznos    := 100;
     v_uplata_rec.datum    := to_date('15.08.2014', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 
     
     
     v_uplata_rec.id       := 3;
     v_uplata_rec.iznos    := 85;
     v_uplata_rec.datum    := to_date('10.02.2015', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec;

     
     v_obracun_tab  :=    ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_pravne,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnica_tab,
                                                                  p_uplate_tab         => v_uplata_tab,
                                                                  p_datum_obracuna     => to_date('03.04.2015', 'dd.mm.yyyy'));
                                                                  
     v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
     v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
     
     --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);    
     
     assert(v_suma_glavnice = 0, 'Ocekujem podmiren dug za glavnicu, a dobio sam '||v_suma_glavnice);                                                    
     assert(v_suma_kamate = 0, 'Ocekujem podmirenu kamatu, a dobio sam '||v_suma_kamate);  

   end;
-------------------------------------------------------------------------------
   procedure t_uplata_na_zadnji_dan
   is
     v_glavnica_rec    ju_tipovi_pkg.transakcija_rec;
     v_glavnica_tab    ju_tipovi_pkg.glavnica;
     
     v_uplata_rec      ju_tipovi_pkg.transakcija_rec;
     v_uplata_tab      ju_tipovi_pkg.uplate;
     
     v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
     
     v_suma_glavnice      number;
     v_suma_kamate        number;
   begin
     v_glavnica_rec.id     := 1;
     v_glavnica_rec.iznos  := 120;
     v_glavnica_rec.datum  := to_date('05.01.2012', 'dd.mm.yyyy');
     
     v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;
     
     
     v_uplata_rec.id       := 1;
     v_uplata_rec.iznos    := 35;
     v_uplata_rec.datum    := to_date('31.12.2012', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 
     
     
     v_obracun_tab  :=    ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_fizicke,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnica_tab,
                                                                  p_uplate_tab         => v_uplata_tab,
                                                                  p_datum_obracuna     => to_date('03.05.2013', 'dd.mm.yyyy'));
                                                                  
     v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
     v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
     
     --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);    
     
     assert(v_suma_glavnice = 99.24, 'Ocekujem glavnicu 99.24, a dobio sam '||v_suma_glavnice);                                                    
     assert(v_suma_kamate = 4.01, 'Ocekujem kamatu 4.01, a dobio sam '||v_suma_kamate);  

   end;
-------------------------------------------------------------------------------
   procedure t_uplata_manja_od_kamate
   is
     v_glavnica_rec    ju_tipovi_pkg.transakcija_rec;
     v_glavnica_tab    ju_tipovi_pkg.glavnica;
     
     v_uplata_rec      ju_tipovi_pkg.transakcija_rec;
     v_uplata_tab      ju_tipovi_pkg.uplate;
     
     v_obracun_tab        ju_tipovi_pkg.izracun_kamate_tab_type;
     
     v_suma_glavnice      number;
     v_suma_kamate        number;
   begin
     v_glavnica_rec.id     := 1;
     v_glavnica_rec.iznos  := 120;
     v_glavnica_rec.datum  := to_date('05.01.2012', 'dd.mm.yyyy');
     
     v_glavnica_tab(v_glavnica_tab.count + 1) := v_glavnica_rec;
     
     
     v_uplata_rec.id       := 1;
     v_uplata_rec.iznos    := 10;
     v_uplata_rec.datum    := to_date('31.12.2012', 'dd.mm.yyyy');
     
     v_uplata_tab(v_uplata_tab.count + 1) := v_uplata_rec; 
     
     
     v_obracun_tab  :=    ju_obracun_kamate_pkg.obracunaj_zateznu(p_kamatne_stope_tab  => ju_model_pkg.kamatne_stope_za_fizicke,
                                                                  p_nacin_obracuna_tab => ju_model_pkg.nacin_obracuna_kamate,
                                                                  p_glavnice_tab       => v_glavnica_tab,
                                                                  p_uplate_tab         => v_uplata_tab,
                                                                  p_datum_obracuna     => to_date('03.05.2013', 'dd.mm.yyyy'));
                                                                  
     v_suma_glavnice := ju_obracun_kamate_pkg.suma_glavnice(v_obracun_tab);
     v_suma_kamate   := ju_obracun_kamate_pkg.suma_kamate(v_obracun_tab);
     
     --ju_obracun_kamate_pkg.output_izracun_zatezne(v_obracun_tab);    
     
     assert(v_suma_glavnice = 120, 'Ocekujem glavnicu 120, a dobio sam '||v_suma_glavnice);                                                    
     assert(v_suma_kamate = 9.26, 'Ocekujem kamatu 9.26, a dobio sam '||v_suma_kamate);  

   end;
------------------------------------------------------------------------------- 
    procedure test
    is
    begin
       t_podjelu_glavnice_po_ks;
       t_odredivanje_nacina_izracuna;
       t_uplate_unutar_glavnica;
       t_metode_obracuna_kamate;
       t_zateznu_za_jednu_glavnicu;
       t_primjer_bez_uplata;
       t_eodvjetnik_primjer1;
       t_eodvjetnik_primjer2;
       t_eodvjetnik_primjer3;

       t_nacin_izracuna;
       
       t_primjer_uplate1;
       t_primjer_uplate_avansa;
       t_primjer_dvije_uplate;
       t_primjer_zatvaranja;
       t_uplata_na_zadnji_dan;
       t_uplata_manja_od_kamate;
    end;

end ju_test_pkg;
/

