prompt Disabling triggers for JU_TIPOVI_OSOBA...
alter table JU_TIPOVI_OSOBA disable all triggers;
prompt Disabling triggers for JU_TIPOVI_IZRACUNA...
alter table JU_TIPOVI_IZRACUNA disable all triggers;
prompt Disabling triggers for JU_ZAKONI...
alter table JU_ZAKONI disable all triggers;
prompt Disabling triggers for JU_DEFINICIJA_TIPA_IZRACUNA...
alter table JU_DEFINICIJA_TIPA_IZRACUNA disable all triggers;
prompt Disabling triggers for JU_KAMATNE_STOPE...
alter table JU_KAMATNE_STOPE disable all triggers;
prompt Disabling triggers for JU_NACINI_OBRACUNA...
alter table JU_NACINI_OBRACUNA disable all triggers;
prompt Disabling foreign key constraints for JU_TIPOVI_IZRACUNA...
alter table JU_TIPOVI_IZRACUNA disable constraint JU_TIA_TOA_FK;
prompt Disabling foreign key constraints for JU_DEFINICIJA_TIPA_IZRACUNA...
alter table JU_DEFINICIJA_TIPA_IZRACUNA disable constraint JU_DTOA_TIA_FK;
alter table JU_DEFINICIJA_TIPA_IZRACUNA disable constraint JU_DTOA_ZKI_FK;
prompt Disabling foreign key constraints for JU_KAMATNE_STOPE...
alter table JU_KAMATNE_STOPE disable constraint JU_KS_TOA_ID;
alter table JU_KAMATNE_STOPE disable constraint JU_KS_ZKI_FK;
prompt Disabling foreign key construaints for ju_izracun_zatezne
alter table ju_izracun_zatezne disable constraint JU_IZE_TIA_FK;
prompt Disabling foreign key constraint for JU_PODACI_OSOBE
alter table JU_PODACI_OSOBE disable constraint JU_PODACI_OSOBE_TOA_FK;
alter table JU_PODACI_OSOBE disable constraint JU_PODACI_OSOBE_JUS_FK;
prompt Truncating JU_USERS...
truncate table ju_users
/
prompt Truncating JU_DEFINICIJA_TIPA_IZRACUNA...
truncate table JU_DEFINICIJA_TIPA_IZRACUNA
/
prompt Truncating JU_KAMATNE_STOPE...
truncate table JU_KAMATNE_STOPE
/
prompt Truncating JU_NACINI_OBRACUNA...
truncate table JU_NACINI_OBRACUNA
/
prompt Truncating JU_TIPOVI_IZRACUNA...
truncate table JU_TIPOVI_IZRACUNA
/
prompt Truncating JU_ZAKONI...
truncate table JU_ZAKONI
/
prompt Truncating JU_TIPOVI_OSOBA...
truncate table JU_TIPOVI_OSOBA
/
prompt Loading JU_USERS...
insert into ju_users (
  id
 ,username
 ,email
 ,password_hash
 ,active
 ,locked
 ,verified
)
values
(
  1
 ,'JANKOVIC'
 ,'odvjetnik-jankovic@ka.t-com.hr'
 ,'1234'
 ,'Y'
 ,'N'
 ,'Y'
)
/
prompt Loading JU_TIPOVI_OSOBA...
insert into JU_TIPOVI_OSOBA (id, opis)
values (1, 'Fizička osoba');
insert into JU_TIPOVI_OSOBA (id, opis)
values (2, 'Pravna osoba');
commit;
prompt 2 records loaded
prompt Loading JU_ZAKONI...
insert into JU_ZAKONI (id, opis, datum_od, datum_do)
values (1, 'Zakon o kamatama', to_date('30-05-1994', 'dd-mm-yyyy'), to_date('31-12-2007', 'dd-mm-yyyy'));
insert into JU_ZAKONI (id, opis, datum_od, datum_do)
values (4, 'Zakon o financijskom poslovanju i predstečajnoj nagodbi', to_date('30-06-2013', 'dd-mm-yyyy'), null);
insert into JU_ZAKONI (id, opis, datum_od, datum_do)
values (2, 'Zakon o obveznim odnosima', to_date('01-01-2008', 'dd-mm-yyyy'), null);
commit;
prompt 3 records loaded
prompt Loading JU_TIPOVI_IZRACUNA...
insert into JU_TIPOVI_IZRACUNA (id, naziv, toa_id, sifra)
values (1, 'izračun za fizičke osobe', 1, 'FZ');
insert into JU_TIPOVI_IZRACUNA (id, naziv, toa_id, sifra)
values (21, 'izračun za pravne osobe (ZOO)', 2, 'MB-ZOO');
insert into JU_TIPOVI_IZRACUNA (id, naziv, toa_id, sifra)
values (41, 'izračun za pravne osobe (ZPFFN)', 2, 'MB-ZFPPN');
commit;
prompt 3 records loaded
prompt Loading JU_KAMATNE_STOPE...
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (1, 30, to_date('30-05-1994', 'dd-mm-yyyy'), to_date('30-06-1994', 'dd-mm-yyyy'), 1, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (2, 22, to_date('01-07-1994', 'dd-mm-yyyy'), to_date('07-05-1996', 'dd-mm-yyyy'), 1, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (3, 24, to_date('08-05-1996', 'dd-mm-yyyy'), to_date('10-09-1996', 'dd-mm-yyyy'), 1, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (4, 18, to_date('11-09-1996', 'dd-mm-yyyy'), to_date('30-06-2002', 'dd-mm-yyyy'), 1, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (66, 10.14, to_date('01-08-2015', 'dd-mm-yyyy'), to_date('31-12-2015', 'dd-mm-yyyy'), 4, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (12, 12.4, to_date('30-06-2013', 'dd-mm-yyyy'), to_date('31-12-2013', 'dd-mm-yyyy'), 4, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (21, 14, to_date('01-01-2008', 'dd-mm-yyyy'), to_date('30-06-2011', 'dd-mm-yyyy'), 2, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (23, 8.14, to_date('01-08-2015', 'dd-mm-yyyy'), to_date('31-12-2015', 'dd-mm-yyyy'), 2, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (61, 24, to_date('08-05-1996', 'dd-mm-yyyy'), to_date('10-09-1996', 'dd-mm-yyyy'), 1, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (62, 18, to_date('11-09-1996', 'dd-mm-yyyy'), to_date('30-06-2002', 'dd-mm-yyyy'), 1, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (63, 12.29, to_date('01-07-2014', 'dd-mm-yyyy'), to_date('31-12-2014', 'dd-mm-yyyy'), 4, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (64, 12.14, to_date('01-01-2015', 'dd-mm-yyyy'), to_date('30-06-2015', 'dd-mm-yyyy'), 4, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (65, 12.13, to_date('01-07-2015', 'dd-mm-yyyy'), to_date('31-07-2015', 'dd-mm-yyyy'), 4, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (5, 15, to_date('01-07-2002', 'dd-mm-yyyy'), to_date('31-12-2007', 'dd-mm-yyyy'), 1, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (10, 7.88, to_date('01-07-2016', 'dd-mm-yyyy'), to_date('31-12-2016', 'dd-mm-yyyy'), 2, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (6, 17, to_date('01-01-2008', 'dd-mm-yyyy'), to_date('30-06-2011', 'dd-mm-yyyy'), 2, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (8, 10.14, to_date('01-08-2015', 'dd-mm-yyyy'), to_date('31-12-2015', 'dd-mm-yyyy'), 2, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (9, 8.05, to_date('01-01-2016', 'dd-mm-yyyy'), to_date('30-06-2016', 'dd-mm-yyyy'), 2, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (11, 7.68, to_date('01-01-2017', 'dd-mm-yyyy'), to_date('30-06-2017', 'dd-mm-yyyy'), 2, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (22, 12, to_date('01-07-2011', 'dd-mm-yyyy'), to_date('31-07-2015', 'dd-mm-yyyy'), 2, 1);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (24, 10.05, to_date('01-01-2016', 'dd-mm-yyyy'), to_date('30-06-2016', 'dd-mm-yyyy'), 2, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (25, 9.88, to_date('01-07-2016', 'dd-mm-yyyy'), to_date('31-12-2016', 'dd-mm-yyyy'), 2, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (26, 9.68, to_date('01-01-2017', 'dd-mm-yyyy'), to_date('30-06-2017', 'dd-mm-yyyy'), 2, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (43, 15, to_date('01-07-2002', 'dd-mm-yyyy'), to_date('31-12-2007', 'dd-mm-yyyy'), 1, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (44, 12.35, to_date('01-01-2014', 'dd-mm-yyyy'), to_date('30-06-2014', 'dd-mm-yyyy'), 4, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (41, 30, to_date('30-05-1994', 'dd-mm-yyyy'), to_date('30-06-1994', 'dd-mm-yyyy'), 1, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (42, 22, to_date('01-07-1994', 'dd-mm-yyyy'), to_date('07-05-1996', 'dd-mm-yyyy'), 1, 2);
insert into JU_KAMATNE_STOPE (id, stopa, datum_od, datum_do, zki_id, toa_id)
values (7, 15, to_date('01-07-2011', 'dd-mm-yyyy'), to_date('31-07-2015', 'dd-mm-yyyy'), 2, 2);
commit;
prompt 28 records loaded
prompt Loading JU_DEFINICIJA_TIPA_IZRACUNA...
insert into JU_DEFINICIJA_TIPA_IZRACUNA (id, primaran, zki_id, tia_id)
values (21, null, 1, 1);
insert into JU_DEFINICIJA_TIPA_IZRACUNA (id, primaran, zki_id, tia_id)
values (23, null, 1, 21);
insert into JU_DEFINICIJA_TIPA_IZRACUNA (id, primaran, zki_id, tia_id)
values (24, null, 2, 21);
insert into JU_DEFINICIJA_TIPA_IZRACUNA (id, primaran, zki_id, tia_id)
values (25, 'D', 4, 41);
insert into JU_DEFINICIJA_TIPA_IZRACUNA (id, primaran, zki_id, tia_id)
values (41, null, 2, 1);
insert into JU_DEFINICIJA_TIPA_IZRACUNA (id, primaran, zki_id, tia_id)
values (42, null, 1, 41);
insert into JU_DEFINICIJA_TIPA_IZRACUNA (id, primaran, zki_id, tia_id)
values (43, null, 2, 41);
commit;
prompt 7 records loaded
prompt Loading JU_NACINI_OBRACUNA...
insert into JU_NACINI_OBRACUNA (id, metoda_obracuna, duljina_razdoblja, datum_od, datum_do)
values (1, 'K', '<=G', to_date('30-05-1994', 'dd-mm-yyyy'), to_date('19-07-2004', 'dd-mm-yyyy'));
insert into JU_NACINI_OBRACUNA (id, metoda_obracuna, duljina_razdoblja, datum_od, datum_do)
values (2, 'P', '>G', to_date('30-05-1994', 'dd-mm-yyyy'), to_date('19-07-2004', 'dd-mm-yyyy'));
insert into JU_NACINI_OBRACUNA (id, metoda_obracuna, duljina_razdoblja, datum_od, datum_do)
values (3, 'P', null, to_date('20-07-2004', 'dd-mm-yyyy'), null);
commit;

prompt Enabling foreign key constraints for JU_TIPOVI_IZRACUNA...
alter table JU_TIPOVI_IZRACUNA enable constraint JU_TIA_TOA_FK;
prompt Enabling foreign key constraints for JU_DEFINICIJA_TIPA_IZRACUNA...
alter table JU_DEFINICIJA_TIPA_IZRACUNA enable constraint JU_DTOA_TIA_FK;
alter table JU_DEFINICIJA_TIPA_IZRACUNA enable constraint JU_DTOA_ZKI_FK;
prompt Enabling foreign key constraints for JU_KAMATNE_STOPE...
alter table JU_KAMATNE_STOPE enable constraint JU_KS_TOA_ID;
alter table JU_KAMATNE_STOPE enable constraint JU_KS_ZKI_FK;
prompt Enabling triggers for JU_TIPOVI_OSOBA...
alter table JU_TIPOVI_OSOBA enable all triggers;
prompt Enabling triggers for JU_TIPOVI_IZRACUNA...
alter table JU_TIPOVI_IZRACUNA enable all triggers;
prompt Enabling triggers for JU_ZAKONI...
alter table JU_ZAKONI enable all triggers;
prompt Enabling triggers for JU_DEFINICIJA_TIPA_IZRACUNA...
alter table JU_DEFINICIJA_TIPA_IZRACUNA enable all triggers;
prompt Enabling triggers for JU_KAMATNE_STOPE...
alter table JU_KAMATNE_STOPE enable all triggers;
prompt Enabling triggers for JU_NACINI_OBRACUNA...
alter table JU_NACINI_OBRACUNA enable all triggers;
alter table ju_izracun_zatezne enable constraint JU_IZE_TIA_FK;
alter table JU_PODACI_OSOBE enable constraint JU_PODACI_OSOBE_TOA_FK;
alter table JU_PODACI_OSOBE enable constraint JU_PODACI_OSOBE_JUS_FK;
set feedback on
set define on
prompt Done.