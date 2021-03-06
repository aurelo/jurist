CREATE OR REPLACE PACKAGE ju_test_pkg
as
    ---
    -- vise malih rata iz 2016-te i 2017-te
    ---
-------------------------------------------------------------------------------
    function dugovi_primjer
    return ju_tipovi_pkg.dugovi;
-------------------------------------------------------------------------------
-- TESTOVI
-------------------------------------------------------------------------------
-------------------------------------------
-- TEST INTERNE STRUKTURE
-------------------------------------------
-------------------------------------------
-- KRAJ TEST INTERNE STRUKTURE
-------------------------------------------
-------------------------------------------------------------------------------
    function t_prop_fze_rate
    return boolean;
-------------------------------------------------------------------------------
    procedure t_nacin_izracuna;
-------------------------------------------------------------------------------
-- testovi za jednu glavnicu
-------------------------------------------------------------------------------
    procedure t_podjela_duga_po_ks;
    procedure t_zateznu_za_jednu_glavnicu;
-------------------------------------------------------------------------------
-- testovi za odredivanje nacina izracuna kamate
    procedure t_odredivanje_nacina_izracuna;
-------------------------------------------------------------------------------
-- test za odredenje uplata u periodu glavnice
   procedure t_uplate_unutar_glavnica;
-------------------------------------------------------------------------------
-- test izracuna kamate po metodama izracuna (proporcionalna i konformna)
   procedure t_metode_obracuna_kamate;
-------------------------------------------------------------------------------
   procedure t_primjer_bez_uplata;
   procedure t_eodvjetnik_primjer1;
   procedure t_eodvjetnik_primjer2;
   procedure t_eodvjetnik_primjer3;
-------------------------------------------------------------------------------
   procedure t_primjer_uplate1;
-------------------------------------------------------------------------------
    procedure test;
end ju_test_pkg;
/

