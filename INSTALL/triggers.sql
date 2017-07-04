CREATE OR REPLACE TRIGGER  JU_ZAKONI_BIR
  before insert on JU_ZAKONI
  for each row  
begin   
  if :NEW."ID" is null then 
    select "JU_ZAKONI_SEQ".nextval into :NEW."ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  JU_ZAKONI_BIR ENABLE
/
CREATE OR REPLACE TRIGGER  JU_TIPOVI_OSOBA_BIR
  before insert on JU_TIPOVI_OSOBA               
  for each row  
begin   
  if :NEW."ID" is null then 
    select "JU_TIPOVI_OSOBA_SEQ".nextval into :NEW."ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  JU_TIPOVI_OSOBA_BIR ENABLE
/
CREATE OR REPLACE TRIGGER  JU_TIPOVI_IZRACUNA_BIR
  before insert on JU_TIPOVI_IZRACUNA               
  for each row  
begin   
  if :NEW."ID" is null then 
    select "JU_TIPOVI_IZRACUNA_SEQ".nextval into :NEW."ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  JU_TIPOVI_IZRACUNA_BIR ENABLE
/
CREATE OR REPLACE TRIGGER  JU_NACINI_OBRACUNA_BIR
  before insert on JU_NACINI_OBRACUNA
  for each row  
begin   
  if :NEW."ID" is null then 
    select "JU_NACINI_OBRACUNA_SEQ".nextval into :NEW."ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  JU_NACINI_OBRACUNA_BIR ENABLE
/
CREATE OR REPLACE TRIGGER  JU_KAMATNE_STOPE_BIR
  before insert on JU_KAMATNE_STOPE
  for each row  
begin   
  if :NEW."ID" is null then 
    select "JU_KAMATNE_STOPE_SEQ".nextval into :NEW."ID" from sys.dual; 
  end if; 
end;

/
ALTER TRIGGER  JU_KAMATNE_STOPE_BIR ENABLE
/
CREATE OR REPLACE TRIGGER  JU_DEFINICIJA_TIPA_OBRACUNA_BI
  before insert on JU_DEFINICIJA_TIPA_IZRACUNA
  for each row  
begin   
  if :NEW."ID" is null then 
    select JU_DEFINICIJA_TIPA_SEQ.nextval into :NEW."ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  JU_DEFINICIJA_TIPA_OBRACUNA_BI ENABLE
/

