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
prompt Creating view JU_SESSION_DUGOVI_V
prompt =================================
prompt
create or replace view ju_session_dugovi_v as
select    acs.seq_id
,         acs.n001 iznos
,         acs.d001 datum_dospijeca
,         acs.n002 vrsta_duga_id
from      apex_collections acs
where     acs.collection_name = 'DUGOVI'
/
prompt
prompt Creating view JU_SESSION_UPLATE_V
prompt =================================
prompt
create or replace view ju_session_uplate_v as
select    acs.seq_id
,         acs.n001 iznos
,         acs.d001 datum_uplate
,         acs.n002 vrsta_transakcije_id
from      apex_collections acs
where     acs.collection_name = 'UPLATE'--ju_session_izracun_pkg.UPLATE
/
prompt
prompt Creating view JU_SESSION_REZULTAT_IZRACUNA_V
prompt ============================================
prompt
create or replace view ju_session_rezultat_izracuna_v as
select    acs.seq_id
,         acs.n001 dug_id
,         acs.n002 uplata_id
,         acs.c001 uplata_na_zadnji_dan_YN
,         acs.n003 osnovica
,         acs.n004 kamata_prethodnog_razdoblja
,         acs.n005 umanjenje_zbog_uplate
,         to_number(acs.c006) / 100 osnovica_izracuna_po_dugu
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
create or replace view ju_session_rekapitulacija_v as
with
 dugovi as
(
select    count(*) broj_dugova
,         nvl(sum(sd.iznos), 0) suma_dugova
from      ju_session_dugovi_v sd
)
,uplate as
(
 select   count(*) broj_uplata
 ,        nvl(sum(su.iznos), 0) iznos_uplata
 from     ju_session_uplate_v su
)
,dug as
(
 select   nvl(sum(ri.osnovica_izracuna_po_dugu), 0) dugovi_dug
 ,        nvl(sum(ri.osnovica_izracuna_po_kamati), 0) kamate_dug
 from     ju_session_rezultat_izracuna_v ri
 where    ri.seq_id in (
   select   max(ri_last.seq_id)
   from     ju_session_rezultat_izracuna_v ri_last
   where    ri_last.dug_id = ri.dug_id
 )
)
select   broj_dugova
,        suma_dugova
,        broj_uplata
,        iznos_uplata
,        dugovi_dug
,        kamate_dug
,        dugovi_dug + kamate_dug ukupan_dug
from     dugovi
,        uplate
,        dug
/
