prompt
prompt Creating view JU_KAMATNE_STOPE_IZRACUNA_V
prompt =========================================
prompt
create or replace force view ju_kamatne_stope_izracuna_v as
select     tia.id id_tipa_izracuna
,             tia.naziv naziv_izracuna
,             toa.opis tip_osobe
,             dtia.primaran
,             zki.opis zakon
,             zki.datum_od zakon_datum_od
,             zki.datum_do zakon_datum_do
,             kse.id ks_id
,             kse.stopa ks_stopa
,             kse.datum_od ks_datum_od
,             kse.datum_do ks_datum_do
   from       ju_kamatne_stope kse
,             ju_tipovi_osoba toa
,             ju_zakoni zki
,             ju_tipovi_izracuna tia
,             ju_definicija_tipa_izracuna dtia
   where      toa.id = kse.toa_id
   and        zki.id = kse.zki_id
   and        tia.toa_id = toa.id
   and        tia.id = dtia.tia_id
   and        dtia.zki_id = zki.id
   order by   tia.id, toa.id, kse.datum_od
/

prompt
prompt Creating view JU_VRIJEDECE_KAMATNE_STOPE_V
prompt ==========================================
prompt
create or replace force view ju_vrijedece_kamatne_stope_v as
with tia as
(
 select   *
 from     ju_tipovi_izracuna
 )
, primarne_period_ks as
 (
 select   min(ks.ks_datum_od) primarna_od
 ,        max(nvl(ks.ks_datum_do, sysdate)) primarna_do
 ,        ks.id_tipa_izracuna
 from     ju_kamatne_stope_izracuna_v ks
 ,        tia
 where    tia.id = ks.id_tipa_izracuna
 and      nvl(ks.primaran, 'N') = 'D'
 group by ks.id_tipa_izracuna
 )
, primarne_ks as
 (
 select    jksa.*
 from      ju_kamatne_stope_izracuna_v jksa
 ,         tia
 where     tia.id = jksa.id_tipa_izracuna
 and       jksa.primaran = 'D'
 )
,obicne_izvan_primarnih as
 (
 select    jksa.*
 from      ju_kamatne_stope_izracuna_v jksa
 ,         tia
 where     tia.id = jksa.id_tipa_izracuna
 and       nvl(jksa.primaran, 'N') = 'N'
 and       (
             jksa.ks_datum_do < nvl((
   select    primarna_od
   from      primarne_period_ks pks
   where     pks.id_tipa_izracuna = tia.id
                                     ), sysdate + 1)
 or
             jksa.ks_datum_od >  nvl((
   select    primarna_do
   from      primarne_period_ks pks
   where     pks.id_tipa_izracuna = tia.id
                                     ), jksa.ks_datum_od - 1)
 )
)
, obicne_prije_primarnih as
 (
 select    jksa.id_tipa_izracuna,
           jksa.naziv_izracuna,
           jksa.tip_osobe,
           jksa.primaran,
           jksa.zakon,
           jksa.zakon_datum_od,
           jksa.zakon_datum_do,
           jksa.ks_id,
           jksa.ks_stopa,
           jksa.ks_datum_od,
           pps.primarna_od - 1 ks_datum_do
 from      ju_kamatne_stope_izracuna_v jksa
 ,         tia
 ,         primarne_period_ks pps
 where     tia.id = jksa.id_tipa_izracuna
 and       nvl(jksa.primaran, 'N') = 'N'
 and       pps.id_tipa_izracuna = tia.id
 and       pps.primarna_od between jksa.ks_datum_od and jksa.ks_datum_do
 )
select   id_tipa_izracuna,
         naziv_izracuna,
         tip_osobe,
         primaran,
         zakon,
         zakon_datum_od,
         zakon_datum_do,
         ks_id,
         ks_stopa,
         ks_datum_od,
         ks_datum_do
from
(
  select    *
  from      primarne_ks
  union all
  select    *
  from      obicne_izvan_primarnih oip
  union all
  select    *
  from      obicne_prije_primarnih
) tab
order by 1 desc
,        10
/
prompt
prompt Creating view JU_TRANSAKCIJE_IZRACUNA_SORT_V
prompt ============================================
prompt
create or replace view ju_transakcije_izracuna_sort_v
as
      select   jte.ize_id izracun_id
      ,        jte.id transakcija_id
      ,        jte.iznos
      ,        jte.datum 
      ,        jte.vta_id vrsta_transakcije_id
      ,        vta.strana
      ,        vta.prioritetna
      ,        vta.naziv
      from     ju_transakcije jte
      ,        ju_vrste_transakcija vta
      where    jte.vta_id = vta.id 
      order by jte.ize_id
      ,        vta.strana
      ,        decode(vta.prioritetna, 'Y', 0, 1)
      ,        decode(vta.sort_datuma, 'ASC', jte.datum) asc
      ,        decode(vta.sort_datuma, 'DESC', jte.datum) desc
      ,        jte.id
/
prompt
prompt Creating view JU_IZRACUN_REKAPITULACIJA_V
prompt =========================================
prompt
create or replace view ju_izracun_rekapitulacija_v as
with
 dugovi as
(
select    count(*) broj_dugova
,         nvl(sum(sd.iznos), 0) suma_dugova
,         sd.izracun_id
from      ju_transakcije_izracuna_sort_v sd
where     sd.strana = 'D'
group by  sd.izracun_id
)
,uplate as
(
 select   count(*) broj_uplata
 ,        nvl(sum(su.iznos), 0) iznos_uplata
 ,        su.izracun_id
from      ju_transakcije_izracuna_sort_v su
where     su.strana = 'P'
group by  su.izracun_id
)
,dug as
(
 select   nvl(sum(ri.osnovica_izracuna_po_dugu), 0) dugovi_dug
 ,        nvl(sum(ri.osnovica_izracuna_po_kamati), 0) kamate_dug
 ,        nvl(sum(ri.ukupna_zatezna_kamata), 0) zatezna_kamata
 ,        ri.ize_id izracun_id
 from     ju_rezultat_izracuna ri
 where    ri.id in (
   select   max(ri_last.id)
   from     ju_rezultat_izracuna ri_last
   where    ri_last.ize_id = ri.ize_id
   and      ri_last.dug_id = ri.dug_id
 )
 group by ri.ize_id
)
select   dug.izracun_id
,        broj_dugova
,        suma_dugova
,        broj_uplata
,        iznos_uplata
,        dugovi_dug
,        kamate_dug
,        zatezna_kamata
,        dugovi_dug + kamate_dug + zatezna_kamata ukupan_dug
from     dugovi
,        uplate
,        dug
where    dug.izracun_id = dugovi.izracun_id
and      dug.izracun_id = uplate.izracun_id(+)
/
prompt
prompt Creating view ju_izracun_pretplata_v
prompt ====================================
prompt
create or replace view ju_izracun_pretplata_v as
(
select    ri.ize_id izracun_id
,         ri.uplata_id
,         u.iznos
,         u.datum datum_uplate
,         sum(ri.umanjenje_zbog_uplate) umanjenje_zbog_uplate
,         u.iznos - sum(ri.umanjenje_zbog_uplate) preplaceno
from      Ju_Rezultat_Izracuna ri
,         Ju_Transakcije u
where     u.id = ri.uplata_id
and       ri.id in (
   select   max(ri_last.id)
   from     Ju_Rezultat_Izracuna ri_last
   where    ri_last.uplata_id = ri.uplata_id
   and      ri_last.osnovica > 0
   group by ri_last.dug_id
)
group by ri.ize_id 
,         ri.uplata_id
,         u.iznos
,         u.datum 
)
/
