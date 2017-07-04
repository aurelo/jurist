prompt
prompt Creating table JU_TIPOVI_OSOBA
prompt ==============================
prompt
create table JU_TIPOVI_OSOBA
(
  id   NUMBER not null,
  opis VARCHAR2(32) not null
)
/
alter table JU_TIPOVI_OSOBA
  add constraint JU_TIPOVI_OSOBA_PK primary key (ID)
/
prompt
prompt Creating table JU_TIPOVI_IZRACUNA
prompt =================================
prompt
create table JU_TIPOVI_IZRACUNA
(
  id     NUMBER not null,
  sifra  VARCHAR2(8),
  naziv  VARCHAR2(64) not null,
  toa_id NUMBER not null
)
/
alter table JU_TIPOVI_IZRACUNA
  add constraint JU_TIA_PK primary key (ID)
/
alter table JU_TIPOVI_IZRACUNA
  add constraint JU_TIA_TOA_FK foreign key (TOA_ID)
  references JU_TIPOVI_OSOBA (ID)
/
prompt
prompt Creating table JU_ZAKONI
prompt ========================
prompt
create table JU_ZAKONI
(
  id       NUMBER not null,
  opis     VARCHAR2(256) not null,
  datum_od DATE not null,
  datum_do DATE
)
/
alter table JU_ZAKONI
  add constraint JU_ZAKONI_PK primary key (ID)
/
prompt
prompt Creating table JU_DEFINICIJA_TIPA_IZRACUNA
prompt ==========================================
prompt
create table JU_DEFINICIJA_TIPA_IZRACUNA
(
  id       NUMBER not null,
  primaran VARCHAR2(1),
  zki_id   NUMBER not null,
  tia_id   NUMBER not null
)
/
alter table JU_DEFINICIJA_TIPA_IZRACUNA
  add constraint JU_DEFINICIJA_TIPA_OBRACUN_PK primary key (ID)
/
alter table JU_DEFINICIJA_TIPA_IZRACUNA
  add constraint JU_DEFINICIJA_TIPA_IZRACUNA_UK unique (ZKI_ID, TIA_ID)
/
alter table JU_DEFINICIJA_TIPA_IZRACUNA
  add constraint JU_DTOA_TIA_FK foreign key (TIA_ID)
  references JU_TIPOVI_IZRACUNA (ID)
/
alter table JU_DEFINICIJA_TIPA_IZRACUNA
  add constraint JU_DTOA_ZKI_FK foreign key (ZKI_ID)
  references JU_ZAKONI (ID)
/
prompt
prompt Creating table JU_KAMATNE_STOPE
prompt ===============================
prompt
create table JU_KAMATNE_STOPE
(
  id       NUMBER not null,
  stopa    NUMBER,
  datum_od DATE,
  datum_do DATE,
  zki_id   NUMBER,
  toa_id   NUMBER
)
/
alter table JU_KAMATNE_STOPE
  add constraint JU_KS_PK primary key (ID)
/
alter table JU_KAMATNE_STOPE
  add constraint JU_KS_TOA_ID foreign key (TOA_ID)
  references JU_TIPOVI_OSOBA (ID)
/
alter table JU_KAMATNE_STOPE
  add constraint JU_KS_ZKI_FK foreign key (ZKI_ID)
  references JU_ZAKONI (ID)
/
prompt
prompt Creating table JU_NACINI_OBRACUNA
prompt =================================
prompt
create table JU_NACINI_OBRACUNA
(
  id                NUMBER not null,
  metoda_obracuna   VARCHAR2(1) not null,
  duljina_razdoblja VARCHAR2(4),
  datum_od          DATE not null,
  datum_do          DATE
)
/
alter table JU_NACINI_OBRACUNA
  add constraint JU_NACINI_OBRACUNA_PK primary key (ID)
/
alter table JU_NACINI_OBRACUNA
  add constraint JU_DULJINA_RAZDOBLJA_CHK
  check ( "DULJINA_RAZDOBLJA" in ('<=G', '>G'))
/
alter table JU_NACINI_OBRACUNA
  add constraint JU_METODA_OBRACUNA_CHK
  check ( "METODA_OBRACUNA" in ('K', 'P'))
/
