prompt
prompt Creating view JU_SESSION_ZATEZNE_IZRACUN_V
prompt ==========================================
prompt
create or replace view ju_session_zatezne_izracun_v
as
select    acs.seq_id 
,         acs.n001 tip_izracuna_id
,         acs.d001 datum_izracuna
,         acs.c001 opis_izracuna
from      apex_collections acs
where     acs.collection_name = 'ZATEZNE_IZRACUN'--ju_session_izracun_pkg.ZATEZNE_IZRACUN
/
prompt
prompt Creating view JU_SESSION_GLAVNICE_V
prompt ===================================
prompt
create or replace view ju_session_glavnice_v
as
select    acs.seq_id 
,         acs.n001 iznos
,         acs.d001 datum_dospijeca
from      apex_collections acs
where     acs.collection_name = 'GLAVNICE'--ju_session_izracun_pkg.GLAVNICE
/
prompt
prompt Creating view JU_SESSION_UPLATE_V
prompt =================================
prompt
create or replace view ju_session_uplate_v
as
select    acs.seq_id 
,         acs.n001 iznos
,         acs.d001 datum_uplate
from      apex_collections acs
where     acs.collection_name = 'UPLATE'--ju_session_izracun_pkg.UPLATE
/
prompt
prompt Creating view JU_SESSION_REZULTAT_IZRACUNA_V
prompt ============================================
prompt
create or replace view ju_session_rezultat_izracuna_v
as
select    acs.seq_id
,         acs.n001 glavnica_id
,         acs.n002 uplata_id
,         acs.c001 uplata_na_zadnji_dan_YN 
,         acs.n003 osnovica
,         acs.n004 kamata_prethodnog_razdoblja
,         acs.n005 umanjenje_zbog_uplate
,         to_number(acs.c006) / 100 osnovica_izracuna_po_glavnici
,         to_number(acs.c007) / 100 osnovica_izracuna_po_kamati
,         acs.d001 datum_od
,         acs.d002 datum_do
,         acs.c008 broj_dana
,         acs.c009 kamatna_stopa_id
,         to_number(acs.c010) /100 kamatna_stopa
,         acs.c002 nacin_izracuna_kamate
,         to_number(acs.c011) /100 zatezna_kamata                   
,         to_number(acs.c012) /100 ukupna_zatezna_kamata            
from      apex_collections acs
where     acs.collection_name = 'ZATEZNE_REZULTAT'--ju_session_izracun_pkg.ZATEZNE_REZULTAT
/
prompt
prompt Creating view JU_SESSION_REKAPITULACIJA_V
prompt =========================================
prompt
create or replace view ju_session_rekapitulacija_v
(
         broj_glavnica
,        suma_glavnica
,        broj_uplata
,        iznos_uplata
,        glavnice_dug
,        kamate_dug
,        ukupan_dug
)
as
 with 
 glavnice as
(
select    count(*) broj_glavnica
,         nvl(sum(sg.iznos), 0) suma_glavnica
from      ju_session_glavnice_v sg
)
,uplate as 
(
 select   count(*) broj_uplata
 ,        nvl(sum(su.iznos), 0) iznos_uplata
 from     ju_session_uplate_v su
)
,dug as
(
 select   nvl(sum(ri.osnovica_izracuna_po_glavnici), 0) glavnice_dug
 ,        nvl(sum(ri.osnovica_izracuna_po_kamati), 0) kamate_dug
 from     ju_session_rezultat_izracuna_v ri
 where    ri.seq_id in (
   select   max(ri_last.seq_id)
   from     ju_session_rezultat_izracuna_v ri_last
   where    ri_last.glavnica_id = ri.glavnica_id
 )
)
select   broj_glavnica
,        suma_glavnica
,        broj_uplata
,        iznos_uplata
,        glavnice_dug
,        kamate_dug
,        glavnice_dug + kamate_dug ukupan_dug
from     glavnice
,        uplate
,        dug
/
