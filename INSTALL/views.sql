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
