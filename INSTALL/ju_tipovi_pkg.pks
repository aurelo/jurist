prompt
prompt Creating package JU_TIPOVI_PKG
prompt ==============================
prompt
CREATE OR REPLACE PACKAGE ju_tipovi_pkg
as
    -- kamatna stopa za period
    type kamatne_stope_rec is record(
      id           number
     ,stopa        number
     ,datum_od     date
     ,datum_do     date
    )
    ;
-------------------------------------------------------------------------------
    type kamatne_stope_tab_type is table of kamatne_stope_rec
    index by binary_integer;
-------------------------------------------------------------------------------
   subtype NACIN_OBRACUNA_KAMATE is varchar2(1);
   KONFORMNI_OBRACUN constant NACIN_OBRACUNA_KAMATE := 'K';
   PROPORCIONALNI_OBRACUN constant NACIN_OBRACUNA_KAMATE := 'P';

   subtype RAZDOBLJE_OBRACUNA_KAMATE is varchar2(4);
   ISPOD_GODINE constant RAZDOBLJE_OBRACUNA_KAMATE := '<=G';
   DULJE_OD_GODINE constant RAZDOBLJE_OBRACUNA_KAMATE := '>G';
    -- NACIN_OBRACUNA_REC
    -- nacin obracua koji se primjenjuje za razdoblje
    -- METODA IZRAÉ•NA:
    -- # ili proporcionalna ili konformna
    -- RAZDOBLJE OBRAÉ•NA
    -- # veci od godine dana, manje od godine dana ili svejedno
    type nacin_obracuna_rec  is record(
      metoda_izracuna_kamate     NACIN_OBRACUNA_KAMATE
     ,datum_od                   date
     ,datum_do                   date
     ,uz_razdoblje_obracuna      RAZDOBLJE_OBRACUNA_KAMATE
    );
-------------------------------------------------------------------------------
    type nacin_obracuna_tab_type is table of nacin_obracuna_rec
    index by binary_integer;
-------------------------------------------------------------------------------
    -- glavnica (osnovnica) ili uplata
    -- ako je prioritetna, napalacuje se prvo
    type transakcija_rec is record (
      id               number
     ,iznos            number
     ,datum            date
    )
    ;
-------------------------------------------------------------------------------
    type glavnice is table of transakcija_rec
    index by binary_integer;
    type uplate   is table of transakcija_rec
    index by binary_integer;
-------------------------------------------------------------------------------
    type glavnica_po_kamatnoj_stopi_rec is record(
      glavnica_id                       number
     ,iznos                             number
     ,datum_od                          date
     ,datum_do                          date
     ,kamatna_stopa_id                  number
     ,kamatna_stopa                     number
    );
-------------------------------------------------------------------------------
    type periodi_izracuna_glavnice_tt is table of glavnica_po_kamatnoj_stopi_rec
    index by binary_integer;
-------------------------------------------------------------------------------
    type glavnica_po_ks_tip_obracun_rec is record (
      glavnica_id                       number
     ,iznos                             number
     ,datum_od                          date
     ,datum_do                          date
     ,kamatna_stopa_id                  number     
     ,kamatna_stopa                     number
     ,nacin_obracuna                    NACIN_OBRACUNA_KAMATE
    );
-------------------------------------------------------------------------------
    type period_nacin_izracuna_tt is table of glavnica_po_ks_tip_obracun_rec
    index by binary_integer;
-------------------------------------------------------------------------------
    type izracun_kamate_rec is record(
       glavnica_id                      number
      ,uplata_id                        number
      ,osnovica                         number
      ,kamata_prethodnog_razdoblja      number
      ,umanjenje_zbog_uplate            number
      ,osnovica_izracuna_po_glavnici    number
      ,osnovica_izracuna_po_kamati      number
      ,datum_od                         date
      ,datum_do                         date
      ,broj_dana                        integer
      ,kamatna_stopa_id                 number
      ,kamatna_stopa                    number
      ,nacin_izracuna_kamate            varchar2(1)
      ,zatezna_kamata                   number
      ,ukupna_zatezna_kamata            number
    );
-------------------------------------------------------------------------------
    type izracun_kamate_tab_type is table of izracun_kamate_rec
    index by binary_integer;

end ju_tipovi_pkg;
/