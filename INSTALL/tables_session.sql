prompt
prompt Creating table JU_SESSION_IZRACUN_ZATEZNE
prompt =========================================
prompt
create table JU_SESSION_IZRACUN_ZATEZNE
(
  id              NUMBER not null,
  session_context VARCHAR2(32) not null,
  tia_id          NUMBER not null,
  datum_izracuna  DATE not null,
  opis            VARCHAR2(512),
  datum_kreacije  DATE
)
/
-- Create/Recreate primary, unique and foreign key constraints 
alter table ju_session_izracun_zatezne
  add constraint ju_sie_PK primary key (ID)
/
alter table JU_SESSION_IZRACUN_ZATEZNE
  add constraint JU_SIE_TIA_FK foreign key (TIA_ID)
  references JU_TIPOVI_IZRACUNA (ID)
/
prompt
prompt Creating table JU_SESSION_GLAVNICE
prompt ==================================
prompt
create table JU_SESSION_GLAVNICE
(
  id              NUMBER not null,
  sie_id          NUMBER not null,
  session_context VARCHAR2(32) not null,
  iznos           NUMBER,
  datum_dospijeca DATE
)
/
alter table ju_session_glavnice
 add constraint JU_SGE_SIE_FK foreign key (SIE_ID)
  references ju_session_izracun_zatezne (ID)
/
prompt
prompt Creating table JU_SESSION_UPLATE
prompt ================================
prompt
create table JU_SESSION_UPLATE
(
  id              NUMBER not null,
  sie_id          NUMBER not null,
  session_context VARCHAR2(32) not null,
  iznos           NUMBER,
  datum_uplate    DATE
)
/
alter table ju_session_uplate
 add constraint JU_SUE_SIE_FK foreign key (SIE_ID)
  references ju_session_izracun_zatezne (ID)
/
prompt
prompt Creating table JU_SESSION_REZULTAT_IZRACUNA
prompt ===========================================
prompt
create table JU_SESSION_REZULTAT_IZRACUNA
(
  id                            NUMBER not null,
  session_context               VARCHAR2(32),
  sie_id                        NUMBER,
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
  ukupna_zatezna_kamata         NUMBER
)
/
-- Create/Recreate primary, unique and foreign key constraints 
alter table JU_SESSION_REZULTAT_IZRACUNA
  add constraint JU_SRA_SIE_FK foreign key (SIE_ID)
  references JU_SESSION_IZRACUN_ZATEZNE (ID)
 /
 