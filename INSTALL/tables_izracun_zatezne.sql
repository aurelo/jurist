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
prompt Creating table JU_GLAVNICE
prompt ==========================
prompt
create table JU_GLAVNICE
(
  id              NUMBER not null,
  ize_id          NUMBER not null,
  iznos           NUMBER,
  datum_dospijeca DATE
)
/
alter table ju_glavnice
 add constraint JU_GVE_ize_FK foreign key (ize_ID)
  references ju_izracun_zatezne (ID)
/
prompt
prompt Creating table JU_UPLATE
prompt ========================
prompt
create table JU_UPLATE
(
  id              NUMBER not null,
  ize_id          NUMBER not null,
  iznos           NUMBER,
  datum_uplate    DATE
)
/
alter table ju_uplate
 add constraint JU_ule_ize_FK foreign key (ize_ID)
  references ju_izracun_zatezne (ID)
/
prompt
prompt Creating table JU_REZULTAT_IZRACUNA
prompt ===================================
prompt
create table JU_REZULTAT_IZRACUNA
(
  id                            NUMBER not null,
  ize_id                        NUMBER,
  glavnica_id                   NUMBER,
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
  osnovica_izracuna_po_glavnici NUMBER,
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
 