prompt
prompt Creating package JU_OBRACUN_KAMATE_PKG
prompt ======================================
prompt
CREATE OR REPLACE PACKAGE ju_obracun_kamate_pkg
as

     type izracun_uplate_rec is record (
        uplata_id           number
       ,datum_uplate        date
       ,orginal_iznos       number
       ,preostali_iznos     number
       ,poredak             integer
     );

--     type uplate_tab_type is  table of izracun_uplate_rec
--     index by varchar2(8);--indeksirano po datumu uplate u formatu yyyymmdd

     type temporal_uplate_tab_type is  table of izracun_uplate_rec
     index by pls_integer;
-------------------------------------------------------------------------------
     function indeksiraj_uplate(
       p_uplate_tab             in    ju_tipovi_pkg.uplate
     )
     return temporal_uplate_tab_type
     ;

-------------------------------------------------------------------------------
     type izracun_glavnice_rec is record(
        glavnica_id                     number
       ,datum_dospijeca                 date
       ,orginal_osnovnica               number
       ,osnovica_izracuna_po_glavnici   number
       ,osnovica_izracuna_po_kamati     number
     );

     type temporal_glavnice_tab_type is table of izracun_glavnice_rec
     index by pls_integer;
-------------------------------------------------------------------------------
     function indeksiraj_glavnice(
       p_glavnica_tab             in    ju_tipovi_pkg.glavnice
     )
     return temporal_glavnice_tab_type
     ;

-------------------------------------------------------------------------------
-- PRIVREMENO PUBLIC PROCEDURE ZBOG TESTA
-------------------------------------------------------------------------------
    procedure output_izracun_zatezne(
      p_obracun_zatezne_tab        in     ju_tipovi_pkg.izracun_kamate_tab_type
    )
    ;
-------------------------------------------------------------------------------
    function proporcionalna_kamata(
      p_osnovica            in     number
     ,p_kamatna_stopa       in     number
     ,p_broj_dana           in     integer
     ,p_godina_obracuna     in     varchar2
    )
    return number;
 -------------------------------------------------------------------------------
    function konformna_kamata(
      p_osnovica            in    number
     ,p_kamatna_stopa       in    number
     ,p_broj_dana           in    integer
     ,p_godina_obracuna     in    varchar2
    )
    return number;
-------------------------------------------------------------------------------
     function podjela_glavnice_po_ksu(
       p_glavnica              in    ju_tipovi_pkg.transakcija_rec
      ,p_kamatne_stope_tab     in    ju_tipovi_pkg.kamatne_stope_tab_type
      ,p_datum_obracuna        in    date
      ,p_maksimalni_period     in    varchar2 default 'G'
     )
     return ju_tipovi_pkg.periodi_izracuna_glavnice_tt;
-------------------------------------------------------------------------------
     function nacin_izracuna_kamate(
       p_period_glavnica_ks    in    ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec
      ,p_nacin_obracuna_tab    in    ju_tipovi_pkg.nacin_obracuna_tab_type
      ,p_datum_do_zbog_uplate  in    date default null
     )
     return ju_tipovi_pkg.period_nacin_izracuna_tt;
-------------------------------------------------------------------------------
    function uplate_sjele_u_periodu(
        p_period_izracuna_glavnice   in    ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec
       ,p_sve_uplate                 in    temporal_uplate_tab_type--ju_tipovi_pkg.uplate
    )
    return temporal_uplate_tab_type--ju_tipovi_pkg.uplate
    ;
-------------------------------------------------------------------------------
-- PUBLIC PROCEDURES AND FUNCTIONS
-------------------------------------------------------------------------------

     function obracunaj_zateznu(
       p_kamatne_stope_tab     in    ju_tipovi_pkg.kamatne_stope_tab_type
      ,p_nacin_obracuna_tab    in    ju_tipovi_pkg.nacin_obracuna_tab_type
      ,p_glavnice_tab          in    ju_tipovi_pkg.glavnice
      ,p_uplate_tab            in    ju_tipovi_pkg.uplate
      ,p_datum_obracuna        in    date  default sysdate
     )
     return ju_tipovi_pkg.izracun_kamate_tab_type;

-------------------------------------------------------------------------------
     function suma_glavnice_old(
       p_uplate_tab                in    ju_tipovi_pkg.glavnice
     )
     return number;
-------------------------------------------------------------------------------
     function suma_glavnice(
       p_obracun_zatezne_tab       in    ju_tipovi_pkg.izracun_kamate_tab_type
      ,p_za_glavnicu_id            in    number default null
     )
     return number;
-------------------------------------------------------------------------------
     function suma_kamate(
       p_obracun_zatezne_tab       in    ju_tipovi_pkg.izracun_kamate_tab_type
      ,p_za_glavnicu_id            in    number default null
     )
     return number;
-------------------------------------------------------------------------------

end ju_obracun_kamate_pkg;
/
