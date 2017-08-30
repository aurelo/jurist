prompt
prompt Creating table JU_IZRACUN_ZATEZNE
prompt =================================
prompt
create table JU_IZRACUN_ZATEZNE
(
  id              NUMBER not null,
  jus_id          number not null,
  tia_id          NUMBER not null,
  datum_izracuna  DATE not null,
  opis            VARCHAR2(512),
  datum_kreacije  DATE,
  vjerovnik_id    number,
  duznik_id       number
)
/
-- Create/Recreate primary, unique and foreign key constraints 
alter table ju_izracun_zatezne
  add constraint ju_ize_PK primary key (ID)
/
alter table JU_IZRACUN_ZATEZNE
  add constraint JU_ize_TIA_FK foreign key (TIA_ID)
  references JU_TIPOVI_IZRACUNA (ID)
/
alter table JU_IZRACUN_ZATEZNE
  add constraint JU_ize_VJEROVNIK_FK foreign key (vjerovnik_ID)
  references ju_podaci_osobe (ID)
/
alter table JU_IZRACUN_ZATEZNE
  add constraint JU_ize_DUZNIK_FK foreign key (duznik_ID)
  references ju_podaci_osobe (ID)
/
prompt
prompt Creating table ju_vrste_transakcija
prompt ===================================
prompt
create table ju_vrste_transakcija
(
  id          number not null,
  naziv       varchar2(64),
  strana      varchar2(1),
  prioritetna varchar2(1),
  sort_datuma varchar2(4)
)
/
alter table ju_vrste_transakcija
  add constraint ju_vta_pk primary key (id)
/
alter table ju_vrste_transakcija
  add constraint ju_vta_prioritetna_chk
  check (prioritetna in ('Y', 'N'))
/
alter table ju_vrste_transakcija
  add constraint ju_vta_sort_chk
  check (sort_datuma in ('ASC', 'DESC'))
/
alter table ju_vrste_transakcija
  add constraint ju_vta_strana_chk
  check (strana in ('D', 'P'))
/
prompt
prompt Creating table ju_transakcije
prompt =============================
prompt
create table ju_transakcije
(
  id     number not null,
  vta_id number,
  ize_id number,
  iznos  number,
  datum  date
)
/
alter table ju_transakcije
  add constraint ju_tne_pk primary key (id)
/
alter table ju_transakcije
  add constraint ju_tne_ize_id foreign key (ize_id)
  references ju_izracun_zatezne (id)
/
alter table ju_transakcije
  add constraint ju_tne_vta_fk foreign key (vta_id)
  references ju_vrste_transakcija (id)
/
prompt
prompt Creating table JU_REZULTAT_IZRACUNA
prompt ===================================
prompt
create table JU_REZULTAT_IZRACUNA
(
  id                            NUMBER not null,
  ize_id                        NUMBER,
  dug_id                        NUMBER,
  uplata_id                     NUMBER,
  kamata_id                     NUMBER,
  kamatna_stopa                 NUMBER,
  datum_od                      DATE,
  datum_do                      DATE,
  broj_dana                     INTEGER,
  nacin_izracuna_kamate         VARCHAR2(1),
  osnovica                      NUMBER,
  kamata_prethodnog_razdoblja   NUMBER,
  umanjenje_zbog_uplate         NUMBER,
  osnovica_izracuna_po_dugu     NUMBER,
  osnovica_izracuna_po_kamati   NUMBER,
  zatezna_kamata                NUMBER,
  ukupna_zatezna_kamata         NUMBER,
  uplata_na_zadnji_dan_YN       varchar2(1)
)
/
-- Create/Recreate primary, unique and foreign key constraints 
alter table JU_REZULTAT_IZRACUNA
  add constraint JU_ria_ize_FK foreign key (ize_ID)
  references JU_IZRACUN_ZATEZNE (ID)
 /
 