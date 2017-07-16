prompt
prompt Creating package body JU_OBRACUN_KAMATE_PKG
prompt ===========================================
prompt
CREATE OR REPLACE PACKAGE BODY ju_obracun_kamate_pkg
as
-------------------------------------------------------------------------------
-- PRIVATE PROCEDURES AND FUNCTIONS
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
     type prethodno_razdoblje_rec is record (
       godina_prethodnog_razdoblja      varchar2(4)
      ,kamata_prethodnog_razdoblja      number
      ,subtotal_zatezne_kamate          number
     );
------------------------------------------------------------------------------
    C_SHOULD_OUTPUT constant boolean := false;
-------------------------------------------------------------------------------
  procedure output_position(
    p_line_number     in    number
  )
  is

  begin
    if C_SHOULD_OUTPUT
    then
      dbms_output.put_line(p_line_number);
    end if;
  end;
-------------------------------------------------------------------------------
  procedure output_text(
    p_text     in      varchar2
  )
  is

  begin
    if C_SHOULD_OUTPUT
    then
      dbms_output.put_line(p_text);
    end if;
  end;
-------------------------------------------------------------------------------
  procedure output_glavnica(
    p_glavnica     in   ju_tipovi_pkg.transakcija_rec
   ,p_output                  in     boolean default C_SHOULD_OUTPUT
  )
  is
  begin
    if p_output
    then
       dbms_output.put_line('   *** GLAVNICA: id:'||p_glavnica.id||' iznos: '||p_glavnica.iznos||' datum dospijeca: '||to_char(p_glavnica.datum, 'dd.mm.yyyy'));
    end if;
  end;
-------------------------------------------------------------------------------
  procedure output_glavnica_po_ksu(
    p_glavnica_po_ksu_rec     in     ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec
   ,p_output                  in     boolean default C_SHOULD_OUTPUT
  )
  is
  begin
    if p_output
    then
        dbms_output.put_line('PERIOD IZRACUNA: '||to_char(p_glavnica_po_ksu_rec.datum_od, 'dd.mm.yyyy')||'-'||to_char(p_glavnica_po_ksu_rec.datum_do, 'dd.mm.yyyy')||' uz ks: '||p_glavnica_po_ksu_rec.kamatna_stopa);
    end if;
  end;
-------------------------------------------------------------------------------
  procedure output_uplate(
    p_uplate_tab          in     temporal_uplate_tab_type--ju_tipovi_pkg.uplate
   ,p_output              in     boolean default C_SHOULD_OUTPUT
  )
  is
    i    number;
  begin
    if not p_output
    then
       return;
    end if;

    if p_uplate_tab.count = 0
    then
        dbms_output.put_line('Nema uplata');
        return;
    else
        dbms_output.put_line('Ima '||p_uplate_tab.count||' uplata/e'||' ,a prvi indeks uplate je: '||p_uplate_tab.first);
    end if;

    i := p_uplate_tab.first;
    
    loop
        dbms_output.put_line('Indeks tablice: '||i ||' uplata id: '||p_uplate_tab(i).uplata_id||' dana: '||to_char(p_uplate_tab(i).datum_uplate, 'dd.mm.yyyy')||' u orginal iznosu: '||p_uplate_tab(i).orginal_iznos||' preostali iznos: '||p_uplate_tab(i).preostali_iznos||' poredak: '||p_uplate_tab(i).poredak);        
    
        exit when i = p_uplate_tab.last or i is null;
        i := p_uplate_tab.next(i);
    end loop;

--    for i in 1..p_uplate_tab.count
--    loop
--        dbms_output.put_line('Indeks tablice: '||i ||' uplata id: '||p_uplate_tab(i).uplata_id||' dana: '||to_char(p_uplate_tab(i).datum_uplate, 'dd.mm.yyyy')||' u orginal iznosu: '||p_uplate_tab(i).orginal_iznos||' preostali iznos: '||p_uplate_tab(i).preostali_iznos||' poredak: '||p_uplate_tab(i).poredak);
--    end loop;

  end;
-------------------------------------------------------------------------------
  procedure output_nacin_obracuna(
     p_nacin_obracuna_u_periodu_rec    in   ju_tipovi_pkg.glavnica_po_ks_tip_obracun_rec
    ,p_output                          in   boolean default C_SHOULD_OUTPUT
  )
  is
  begin
    if p_output
    then
       dbms_output.put_line('NACIN OBRCÂUNA: '||p_nacin_obracuna_u_periodu_rec.nacin_obracuna||' za period: '||to_char(p_nacin_obracuna_u_periodu_rec.datum_od, 'dd.mm.yyyy')||'-'||to_char(p_nacin_obracuna_u_periodu_rec.datum_do, 'dd.mm.yyyy'));
    end if;
  end;
-------------------------------------------------------------------------------
  procedure output_izracun_zatezne(
    p_izracun_zatezne_rec              in   ju_tipovi_pkg.izracun_kamate_rec
   ,p_output                           in   boolean  default C_SHOULD_OUTPUT
  )
  is
  begin
    if p_output
    then
      dbms_output.put_line('  --> KAMATA: '||p_izracun_zatezne_rec.zatezna_kamata||' za broj dana: '||p_izracun_zatezne_rec.broj_dana||' od-do: '||p_izracun_zatezne_rec.datum_od||'-'||p_izracun_zatezne_rec.datum_do||' osnovica glavnica-kamata:'||p_izracun_zatezne_rec.osnovica_izracuna_po_glavnici||'-'||p_izracun_zatezne_rec.osnovica_izracuna_po_kamati);
    end if;
  end;
-------------------------------------------------------------------------------
  procedure output_iznosi_za_izracun(
    p_iznos_za_izracun_rec             in   prethodno_razdoblje_rec
   ,p_output                           in   boolean  default C_SHOULD_OUTPUT
  )
  is
  begin
    if p_output
    then
       dbms_output.put_line('Iznosi za izracun: god prije: '||p_iznos_za_izracun_rec.godina_prethodnog_razdoblja||' kamata prethodnog razdoblja: '||p_iznos_za_izracun_rec.kamata_prethodnog_razdoblja||' subtotal zatezne: '||p_iznos_za_izracun_rec.subtotal_zatezne_kamate);
    end if;
  end;
-------------------------------------------------------------------------------
    procedure output_izracun_zatezne(
      p_obracun_zatezne_tab         in     ju_tipovi_pkg.izracun_kamate_tab_type
    )
    is
    begin
        for i in 1..p_obracun_zatezne_tab.count
        loop
             dbms_output.put_line('glavnica: '||p_obracun_zatezne_tab(i).glavnica_id||' zatezna kamata: '||p_obracun_zatezne_tab(i).zatezna_kamata||' broj dana: '||p_obracun_zatezne_tab(i).broj_dana||' od-do: '||p_obracun_zatezne_tab(i).datum_od||'-'||p_obracun_zatezne_tab(i).datum_do||' nacin: '||p_obracun_zatezne_tab(i).nacin_izracuna_kamate||' ks: '||p_obracun_zatezne_tab(i).kamatna_stopa||' osnovnica za izracun glavnica: '||p_obracun_zatezne_tab(i).osnovica_izracuna_po_glavnici||' osnovnica za izracun kamata: '||p_obracun_zatezne_tab(i).osnovica_izracuna_po_kamati||' umanjenje zbog uplate (id='||p_obracun_zatezne_tab(i).uplata_id||'): '||p_obracun_zatezne_tab(i).umanjenje_zbog_uplate||' ukupna zatezna: '||p_obracun_zatezne_tab(i).ukupna_zatezna_kamata||' uplata na zadnji dan: '||p_obracun_zatezne_tab(i).uplata_na_zadnji_dan_YN);
        end loop;
    end;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
  function is_godina_prijestupna(
       p_godina       in    varchar2
    )
    return boolean
    is
       v_godina    number := to_number(p_godina);
    begin
       return case when (
                     (mod(v_godina, 4) = 0 and mod(v_godina, 100) <> 0 )
                      or
                      mod(v_godina, 400) = 0) then true
              else false
              end;
    end;
-------------------------------------------------------------------------------
    function proporcionalna_kamata(
      p_osnovica            in     number
     ,p_kamatna_stopa       in     number
     ,p_broj_dana           in     integer
     ,p_godina_obracuna     in     varchar2
    )
    return number
    is
    --------------
    -- formula:
    -- K = G * kamatna stopa * broj dana / 36500(36600)
    --------------
      v_koeficijent_godine    integer;
    begin
      v_koeficijent_godine := case when is_godina_prijestupna(p_godina_obracuna) then 36600 else 36500 end;

      return round(nvl(p_osnovica, 0) * nvl(p_kamatna_stopa, 0) * nvl(p_broj_dana, 0) / v_koeficijent_godine, 2);
    end;
-------------------------------------------------------------------------------
    function konformna_kamata(
      p_osnovica            in    number
     ,p_kamatna_stopa       in    number
     ,p_broj_dana           in    integer
     ,p_godina_obracuna     in    varchar2
    )
    return number
    is
    -------------
    -- formula:
    -- K = G * ((1 + kamatna stopa / 100) na broj dana/broj dana u godini  - 1)
    -------------
      v_koeficijent_godine     integer;
    begin
      v_koeficijent_godine := case when is_godina_prijestupna(p_godina_obracuna) then 366 else 365 end;

     return round(nvl(p_osnovica, 0) * ( power(1 + nvl(p_kamatna_stopa, 0) / 100, p_broj_dana / v_koeficijent_godine) -  1), 2);
    end;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--     function indeksiraj_uplate_po_datumu(
--       p_uplate_tab             in    ju_tipovi_pkg.uplate
--     )
--     return uplate_tab_type
--     is
--        v_indeksirane_uplate_tab     uplate_tab_type;
--        v_izracun_uplate             izracun_uplate_rec;
--     begin
--        if p_uplate_tab.count > 0
--        then
--
--           for i in 1..p_uplate_tab.count
--           loop
--                v_izracun_uplate.uplata_id       := p_uplate_tab(i).id;
--                v_izracun_uplate.datum_uplate    := p_uplate_tab(i).datum;
--                v_izracun_uplate.orginal_iznos   := p_uplate_tab(i).iznos;
--                v_izracun_uplate.preostali_iznos := p_uplate_tab(i).iznos;
--
--                v_indeksirane_uplate_tab(to_char(p_uplate_tab(i).datum, 'yyyymmdd')) := v_izracun_uplate;
--           end loop;
--        end if;
--
--        return v_indeksirane_uplate_tab;
--     end;
-------------------------------------------------------------------------------
     function indeksiraj_uplate(
       p_uplate_tab             in    ju_tipovi_pkg.uplate
     )
     return temporal_uplate_tab_type
     is
        v_indeksirane_uplate_tab     temporal_uplate_tab_type;
        v_izracun_uplate             izracun_uplate_rec;
     begin
        if p_uplate_tab.count > 0
        then

           for i in 1..p_uplate_tab.count
           loop
                v_izracun_uplate.uplata_id       := p_uplate_tab(i).id;
                v_izracun_uplate.datum_uplate    := p_uplate_tab(i).datum;
                v_izracun_uplate.orginal_iznos   := p_uplate_tab(i).iznos;
                v_izracun_uplate.preostali_iznos := p_uplate_tab(i).iznos;
                
                v_izracun_uplate.poredak         := i;

                v_indeksirane_uplate_tab(p_uplate_tab(i).id) := v_izracun_uplate;
           end loop;
        end if;

        return v_indeksirane_uplate_tab;
     end;
-------------------------------------------------------------------------------
     function indeksiraj_glavnice(
       p_glavnica_tab             in    ju_tipovi_pkg.glavnice
     )
     return temporal_glavnice_tab_type
     is
       v_indeksirane_glavnice_tab   temporal_glavnice_tab_type;
       v_izracun_glavnice_rec       izracun_glavnice_rec;
     begin
       if p_glavnica_tab.count > 0
       then

            for i in 1..p_glavnica_tab.count
            loop
              v_izracun_glavnice_rec.glavnica_id                   := p_glavnica_tab(i).id;
              v_izracun_glavnice_rec.datum_dospijeca               := p_glavnica_tab(i).datum;
              v_izracun_glavnice_rec.orginal_osnovnica             := p_glavnica_tab(i).iznos;

              v_izracun_glavnice_rec.osnovica_izracuna_po_glavnici := p_glavnica_tab(i).iznos;
              v_izracun_glavnice_rec.osnovica_izracuna_po_kamati   := 0;
              

              v_indeksirane_glavnice_tab(v_izracun_glavnice_rec.glavnica_id) := v_izracun_glavnice_rec;
            end loop;

       end if;

       return v_indeksirane_glavnice_tab;
     end;
-------------------------------------------------------------------------------
     function ima_uplata_u_periodu(
       p_period_glavnice_ks    in    ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec
      ,p_uplate                in    temporal_uplate_tab_type--uplate_tab_type
     )
     return boolean
     is
       v_ima_uplata   boolean := false;
     begin
       for i in 1..p_uplate.count
       loop
         if to_date(i, 'yyyymmdd') between p_period_glavnice_ks.datum_od and p_period_glavnice_ks.datum_do - 1
         then
             v_ima_uplata := true;
             exit;
         end if;
       end loop;

       return v_ima_uplata;
     end;
-------------------------------------------------------------------------------
     function podjela_glavnice_po_ksu(
       p_glavnica              in    ju_tipovi_pkg.transakcija_rec
      ,p_kamatne_stope_tab     in    ju_tipovi_pkg.kamatne_stope_tab_type
      ,p_datum_obracuna        in    date
      ,p_maksimalni_period     in    varchar2 default 'G'
     )
     return ju_tipovi_pkg.periodi_izracuna_glavnice_tt
     is
         v_period_rec                 ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec;
         v_vazece_kamatne_stope_tab   ju_tipovi_pkg.periodi_izracuna_glavnice_tt;

         v_datum_dospijeca_glavnice   date;

         v_godina_od                  number;
         v_godina_do                  number;

         v_period_datum_od            date;
         v_period_datum_do            date;
     begin
         v_period_rec.glavnica_id   := p_glavnica.id;
         v_period_rec.iznos         := p_glavnica.iznos;
         v_datum_dospijeca_glavnice := p_glavnica.datum;


     -- kamata vrijedi za period u tri slucaja
   --<-1 slucaj--> <-  3 slucaj ->      <- 2 slucaj ->
      --^------------------------------------^--=> period za izracun kamate
      for i in 1..p_kamatne_stope_tab.count
      loop

         --dbms_output.put_line('Glavnica datum: '||p_glavnica.datum||' obracun na: '||p_datum_obracuna||' ks od-do: '||p_kamatne_stope_tab(i).datum_od||'-'||p_kamatne_stope_tab(i).datum_do);

          -- 1. slucaj
          if  v_datum_dospijeca_glavnice between p_kamatne_stope_tab(i).datum_od and p_kamatne_stope_tab(i).datum_do
          -- 2. slucaj
          or  p_datum_obracuna between p_kamatne_stope_tab(i).datum_od and p_kamatne_stope_tab(i).datum_do
          -- 3. slucaj
          or  (
               v_datum_dospijeca_glavnice < p_kamatne_stope_tab(i).datum_od
               and
               p_datum_obracuna > p_kamatne_stope_tab(i).datum_do
              )
          then
             v_period_rec.kamatna_stopa_id := p_kamatne_stope_tab(i).id;
             v_period_rec.kamatna_stopa    := p_kamatne_stope_tab(i).stopa;
             v_period_rec.datum_od         := greatest(v_datum_dospijeca_glavnice, p_kamatne_stope_tab(i).datum_od);
             v_period_rec.datum_do         := least(p_datum_obracuna, p_kamatne_stope_tab(i).datum_do);

             v_godina_od := to_char(v_period_rec.datum_od, 'YYYY');
             v_godina_do := to_char(v_period_rec.datum_do, 'YYYY');

             v_period_datum_od := v_period_rec.datum_od;
             v_period_datum_do := v_period_rec.datum_do;

             -- ako racunam kamate po godinama, moram periode rasjepati ako prelaze preko godine dana
             if   p_maksimalni_period = 'G'
             and  v_godina_od != v_godina_do
             then
                for i in v_godina_od..v_godina_do
                loop
                     -- ili 01.01. godine, ili poÄ‚Â¨etak perioda
                     v_period_rec.datum_od      := greatest(v_period_datum_od, trunc(to_date(i, 'yyyy'), 'YYYY'));

                     -- ili kraj perioda ili zadnji dan godine ili datum obracuna
                     v_period_rec.datum_do      := least(v_period_datum_do, least(p_datum_obracuna, to_date('31.12.'||i, 'dd.mm.yyyy')));

                     v_vazece_kamatne_stope_tab(v_vazece_kamatne_stope_tab.count + 1) := v_period_rec;

                end loop;
             else
                v_vazece_kamatne_stope_tab(v_vazece_kamatne_stope_tab.count + 1) := v_period_rec;
             end if;

          end if;
      end loop;

      return v_vazece_kamatne_stope_tab;
     end;
-------------------------------------------------------------------------------
    function uplate_sjele_u_periodu(
        p_period_izracuna_glavnice   in    ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec
       ,p_sve_uplate                 in    temporal_uplate_tab_type --ju_tipovi_pkg.uplate
    )
    return temporal_uplate_tab_type--ju_tipovi_pkg.uplate
    is
       v_uplate_sjele_u_periodu_tab        temporal_uplate_tab_type;--ju_tipovi_pkg.uplate;
       v_uplata_index_id                   number;
       
       v_idx                               number;
       v_ordered_tab                       temporal_uplate_tab_type;--ju_tipovi_pkg.uplate;
    begin
       if p_sve_uplate.count = 0
       then
          return v_uplate_sjele_u_periodu_tab;
       else
          v_uplata_index_id := p_sve_uplate.first;
       end if;

       loop

--       for i in 1..p_sve_uplate.count
--       loop

           if (
              p_sve_uplate(v_uplata_index_id).datum_uplate between p_period_izracuna_glavnice.datum_od and p_period_izracuna_glavnice.datum_do-- za uplatu uzimam i zadnji dan - 1
           -- avans (upalta sjela prije glavnice)
           or p_sve_uplate(v_uplata_index_id).datum_uplate < p_period_izracuna_glavnice.datum_od
              )
           and p_sve_uplate(v_uplata_index_id).preostali_iznos > 0
           then
               v_uplate_sjele_u_periodu_tab(v_uplate_sjele_u_periodu_tab.count + 1) := p_sve_uplate(v_uplata_index_id);
               --v_uplate_sjele_u_periodu_tab(p_sve_uplate(v_uplata_index_id).poredak) := p_sve_uplate(v_uplata_index_id);
           end if;

           exit when v_uplata_index_id = p_sve_uplate.last;

           v_uplata_index_id := p_sve_uplate.next(v_uplata_index_id);

       end loop;

       output_uplate(v_uplate_sjele_u_periodu_tab);
       
       if v_uplate_sjele_u_periodu_tab.count = 0
       then
           return v_uplate_sjele_u_periodu_tab;
       else
           for j in 1..v_uplate_sjele_u_periodu_tab.count
           loop
               v_ordered_tab(v_uplate_sjele_u_periodu_tab(j).poredak) := v_uplate_sjele_u_periodu_tab(j);
           end loop;
           
           
           v_idx := v_ordered_tab.first;
           
           loop
              exit when v_idx = v_ordered_tab.last or v_idx is null;
              v_idx := v_ordered_tab.next(v_idx);
           end loop; 
       end if;

       output_uplate(v_ordered_tab);

       --return v_uplate_sjele_u_periodu_tab;
       return v_ordered_tab;
    end;
-------------------------------------------------------------------------------
     function nacin_izracuna_kamate(
       p_period_glavnica_ks    in    ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec
      ,p_nacin_obracuna_tab    in    ju_tipovi_pkg.nacin_obracuna_tab_type
      ,p_datum_do_zbog_uplate  in    date default null
     )
     return ju_tipovi_pkg.period_nacin_izracuna_tt
     is
       v_glavnica_po_ks_za_algoritam     ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec;

       v_period_izracuna_rec             ju_tipovi_pkg.glavnica_po_ks_tip_obracun_rec;
       podjela_po_nacinu_obracuna_tab    ju_tipovi_pkg.period_nacin_izracuna_tt;

       -------------------
       -- pomocne funkcije
       -------------------
       function razdoblje_obracuna_odgovara(
         p_nacin_obracuna_rec     in    ju_tipovi_pkg.nacin_obracuna_rec
        ,p_datum_od               in    date
        ,p_datum_do               in    date
       )
       return boolean
       is
       begin
--         if  months_between(p_datum_do, p_datum_od) < 0
--         then
--           return false;
--         end if;

         --dbms_output.put_line('razdoblje obracuna: '||nvl(p_nacin_obracuna_rec.uz_razdoblje_obracuna, 'nije odreÄ‚Â°eno')||' od-do: '||p_datum_od||'-'||p_datum_do);
         return
                p_nacin_obracuna_rec.uz_razdoblje_obracuna is null
         or     (
             p_nacin_obracuna_rec.uz_razdoblje_obracuna = ju_tipovi_pkg.DULJE_OD_GODINE
             and months_between(p_datum_do, p_datum_od) > 12
                )
         or     (
             p_nacin_obracuna_rec.uz_razdoblje_obracuna = ju_tipovi_pkg.ISPOD_GODINE
             and months_between(p_datum_do, p_datum_od) <= 12
                )
         ;
       end;
       -------------------
     begin
       v_period_izracuna_rec.glavnica_id      := p_period_glavnica_ks.glavnica_id;
       v_period_izracuna_rec.iznos            := p_period_glavnica_ks.iznos;
       v_period_izracuna_rec.kamatna_stopa_id := p_period_glavnica_ks.kamatna_stopa_id;
       v_period_izracuna_rec.kamatna_stopa    := p_period_glavnica_ks.kamatna_stopa;

       v_glavnica_po_ks_za_algoritam          := p_period_glavnica_ks;

       -- ako se desila uplata u periodu 
       if   p_datum_do_zbog_uplate is not null
       and  p_datum_do_zbog_uplate < v_glavnica_po_ks_za_algoritam.datum_do
       and  p_datum_do_zbog_uplate > v_glavnica_po_ks_za_algoritam.datum_od
       then
            v_glavnica_po_ks_za_algoritam.datum_do := p_datum_do_zbog_uplate;
       end if;

       output_glavnica_po_ksu(v_glavnica_po_ks_za_algoritam, false);

       for i in 1..p_nacin_obracuna_tab.count
       loop
           --dbms_output.put_line('Glavnica id: '||v_glavnica_po_ks_za_algoritam.glavnica_id||'  od-do: '||v_glavnica_po_ks_za_algoritam.datum_od||'-'||v_glavnica_po_ks_za_algoritam.datum_do||' alg od-do: '||p_nacin_obracuna_tab(i).datum_od||'-'||p_nacin_obracuna_tab(i).datum_do||' tip obracuna: '||p_nacin_obracuna_tab(i).metoda_izracuna_kamate||' uz razdoblje izracuna: '||p_nacin_obracuna_tab(i).uz_razdoblje_obracuna);

           -- 1 slucaj
           ---<------>------   -> nacin obracuna kamate
           -------^----^----   -> period glavnice
           if   v_glavnica_po_ks_za_algoritam.datum_od between p_nacin_obracuna_tab(i).datum_od and p_nacin_obracuna_tab(i).datum_do
           and  razdoblje_obracuna_odgovara(p_nacin_obracuna_tab(i), v_glavnica_po_ks_za_algoritam.datum_od, least(p_nacin_obracuna_tab(i).datum_do, v_glavnica_po_ks_za_algoritam.datum_do))
           then

              v_period_izracuna_rec.datum_od       := v_glavnica_po_ks_za_algoritam.datum_od;
              v_period_izracuna_rec.datum_do       := least(p_nacin_obracuna_tab(i).datum_do, v_glavnica_po_ks_za_algoritam.datum_do);
              v_period_izracuna_rec.nacin_obracuna := p_nacin_obracuna_tab(i).metoda_izracuna_kamate;

              --dbms_output.put_line('1 slucaj: od-do: '||v_period_izracuna_rec.datum_od||'-'||v_period_izracuna_rec.datum_do);

              podjela_po_nacinu_obracuna_tab(podjela_po_nacinu_obracuna_tab.count + 1) := v_period_izracuna_rec;

              if p_nacin_obracuna_tab(i).datum_do > v_period_izracuna_rec.datum_do
              then
                 exit;-- ovaj nacin obracuna u potpunosti pokriva period glavnice
              else
              -- dalje gledam za ostatak perioda
                 v_glavnica_po_ks_za_algoritam.datum_od := v_period_izracuna_rec.datum_do + 1;
              end if;

           elsif
           -- 2 slucaj
           ----<------>------   -> nacin obracuna kamate
           --^----^----------   -> period glavnice
                       v_glavnica_po_ks_za_algoritam.datum_do between p_nacin_obracuna_tab(i).datum_od and nvl(p_nacin_obracuna_tab(i).datum_do, sysdate)
                 and   razdoblje_obracuna_odgovara(p_nacin_obracuna_tab(i), p_nacin_obracuna_tab(i).datum_od, v_glavnica_po_ks_za_algoritam.datum_do)
           then

              v_period_izracuna_rec.datum_od       := greatest(p_nacin_obracuna_tab(i).datum_od, v_glavnica_po_ks_za_algoritam.datum_od);
              v_period_izracuna_rec.datum_do       := v_glavnica_po_ks_za_algoritam.datum_do;
              v_period_izracuna_rec.nacin_obracuna := p_nacin_obracuna_tab(i).metoda_izracuna_kamate;

              --dbms_output.put_line('2 slucaj od-do: '||v_period_izracuna_rec.datum_od||'-'||v_period_izracuna_rec.datum_do);

              podjela_po_nacinu_obracuna_tab(podjela_po_nacinu_obracuna_tab.count + 1) := v_period_izracuna_rec;

              -- doÄąË‡ao sam do kraja perioda izracuna glavnice
              exit;
           elsif
           -- 3 slucaj
           ----<-->--------   -> nacin obracuna kamate
           --^-------^-----   -> period glavnice
                     v_glavnica_po_ks_za_algoritam.datum_od <= p_nacin_obracuna_tab(i).datum_od
                 and nvl(p_nacin_obracuna_tab(i).datum_do, sysdate) < v_glavnica_po_ks_za_algoritam.datum_do
                 and razdoblje_obracuna_odgovara(p_nacin_obracuna_tab(i), p_nacin_obracuna_tab(i).datum_od, nvl(p_nacin_obracuna_tab(i).datum_od, sysdate))
           then
              v_period_izracuna_rec.datum_od       := p_nacin_obracuna_tab(i).datum_od;
              v_period_izracuna_rec.datum_do       := p_nacin_obracuna_tab(i).datum_do;
              v_period_izracuna_rec.nacin_obracuna := p_nacin_obracuna_tab(i).metoda_izracuna_kamate;

              --dbms_output.put_line('3 slucaj od-do: '||v_period_izracuna_rec.datum_od||'-'||v_period_izracuna_rec.datum_do);

              podjela_po_nacinu_obracuna_tab(podjela_po_nacinu_obracuna_tab.count + 1) := v_period_izracuna_rec;

              -- dalje gledam za ostatak perioda
              v_glavnica_po_ks_za_algoritam.datum_od := p_nacin_obracuna_tab(i).datum_do + 1;
           end if;
       end loop;

       return podjela_po_nacinu_obracuna_tab;
     end;
-------------------------------------------------------------------------------
     function zatezna_za_period(
       p_period_glavnica_ks_nacin    in    ju_tipovi_pkg.glavnica_po_ks_tip_obracun_rec
      ,p_iznosi_za_izracun           in    prethodno_razdoblje_rec
--      ,p_trenutna_osnovica           in    number
      ,p_trenutna_osnovica_glavnica  in    number
      ,p_trenutna_osnovica_kamata    in    number
      ,p_uplata_rec                  in    izracun_uplate_rec default null
--      ,p_nacin_obracuna_tab          in    ju_tipovi_pkg.nacin_obracuna_tab_type
     )
     return ju_tipovi_pkg.izracun_kamate_rec
     is
         v_izracun_zatezne_rec    ju_tipovi_pkg.izracun_kamate_rec;
     begin
         output_iznosi_za_izracun(p_iznosi_za_izracun, false);
         --dbms_output.put_line('Trenutna osnovica glavnica: '||p_trenutna_osnovica_glavnica||' trenutna osnovica kamata: '||p_trenutna_osnovica_kamata);

         v_izracun_zatezne_rec.glavnica_id := p_period_glavnica_ks_nacin.glavnica_id;
         v_izracun_zatezne_rec.datum_od    := p_period_glavnica_ks_nacin.datum_od;
         v_izracun_zatezne_rec.datum_do    := p_period_glavnica_ks_nacin.datum_do;
         v_izracun_zatezne_rec.broj_dana   := p_period_glavnica_ks_nacin.datum_do - p_period_glavnica_ks_nacin.datum_od + 1;

         v_izracun_zatezne_rec.kamatna_stopa_id      := p_period_glavnica_ks_nacin.kamatna_stopa_id;
         v_izracun_zatezne_rec.kamatna_stopa         := p_period_glavnica_ks_nacin.kamatna_stopa;
         v_izracun_zatezne_rec.nacin_izracuna_kamate := p_period_glavnica_ks_nacin.nacin_obracuna;

--         v_izracun_zatezne_rec.osnovica                    := nvl(p_trenutna_osnovica, 0);--nvl(p_period_glavnica_ks_nacin.iznos, 0);
         v_izracun_zatezne_rec.osnovica                    := nvl(p_trenutna_osnovica_glavnica, 0);--nvl(p_period_glavnica_ks_nacin.iznos, 0);


         v_izracun_zatezne_rec.kamata_prethodnog_razdoblja := nvl(p_iznosi_za_izracun.kamata_prethodnog_razdoblja, 0);
         v_izracun_zatezne_rec.ukupna_zatezna_kamata       := nvl(p_iznosi_za_izracun.subtotal_zatezne_kamate, 0);

         v_izracun_zatezne_rec.uplata_id                   := p_uplata_rec.uplata_id;

         -- ako je bila uplata, ili se radi o konformnom obracunu za ne prvu ratu unutar iste godine
         -- tad je osnovica do tada izracunata glavnica + kamata za ratu, umanjena za eventualnu uplatu
         if nvl(p_uplata_rec.preostali_iznos, 0) > 0
         or  (
                v_izracun_zatezne_rec.nacin_izracuna_kamate = ju_tipovi_pkg.KONFORMNI_OBRACUN
                and
                nvl(p_iznosi_za_izracun.godina_prethodnog_razdoblja, to_char(v_izracun_zatezne_rec.datum_od, 'YYYY')) = to_char(v_izracun_zatezne_rec.datum_od, 'YYYY')
               )
         then
             -- ZG dodao ovaj red 13.07.2017
             v_izracun_zatezne_rec.kamata_prethodnog_razdoblja := v_izracun_zatezne_rec.ukupna_zatezna_kamata;


             if nvl(p_uplata_rec.preostali_iznos, 0) <= v_izracun_zatezne_rec.kamata_prethodnog_razdoblja
             then
               v_izracun_zatezne_rec.osnovica_izracuna_po_kamati   := v_izracun_zatezne_rec.kamata_prethodnog_razdoblja - nvl(p_uplata_rec.preostali_iznos, 0);
               v_izracun_zatezne_rec.osnovica_izracuna_po_glavnici := p_trenutna_osnovica_glavnica;
             else
               v_izracun_zatezne_rec.osnovica_izracuna_po_kamati   := 0;
               v_izracun_zatezne_rec.osnovica_izracuna_po_glavnici := greatest(p_trenutna_osnovica_glavnica + v_izracun_zatezne_rec.kamata_prethodnog_razdoblja - nvl(p_uplata_rec.preostali_iznos, 0), 0);
             end if;

             v_izracun_zatezne_rec.umanjenje_zbog_uplate          := least(nvl(p_uplata_rec.preostali_iznos, 0), p_trenutna_osnovica_glavnica + v_izracun_zatezne_rec.kamata_prethodnog_razdoblja);

         else
             v_izracun_zatezne_rec.osnovica_izracuna_po_glavnici  := v_izracun_zatezne_rec.osnovica;
             v_izracun_zatezne_rec.osnovica_izracuna_po_kamati    := p_trenutna_osnovica_kamata;
             v_izracun_zatezne_rec.umanjenje_zbog_uplate := least(nvl(p_uplata_rec.preostali_iznos, 0), v_izracun_zatezne_rec.osnovica_izracuna_po_glavnici);
         end if;
--         v_izracun_zatezne_rec.osnovica_za_izracun := case when v_izracun_zatezne_rec.umanjenje_zbog_uplate > 0
--                                                          or    (
--                                                                 v_izracun_zatezne_rec.nacin_izracuna_kamate = ju_tipovi_pkg.KONFORMNI_OBRACUN
--                                                                 and
--                                                                 nvl(p_iznosi_za_izracun.godina_prethodnog_razdoblja, to_char(v_izracun_zatezne_rec.datum_od, 'YYYY')) = to_char(v_izracun_zatezne_rec.datum_od, 'YYYY')
--                                                                )
--                                                           then greatest(nvl(v_izracun_zatezne_rec.osnovica_za_izracun, v_izracun_zatezne_rec.osnovica) + v_izracun_zatezne_rec.kamata_prethodnog_razdoblja - v_izracun_zatezne_rec.umanjenje_zbog_uplate, 0)
--                                                           else nvl(v_izracun_zatezne_rec.osnovica_za_izracun, v_izracun_zatezne_rec.osnovica)
--                                                       end;


         v_izracun_zatezne_rec.zatezna_kamata := case
                  when p_period_glavnica_ks_nacin.nacin_obracuna = ju_tipovi_pkg.KONFORMNI_OBRACUN
                    then konformna_kamata(p_osnovica        => v_izracun_zatezne_rec.osnovica_izracuna_po_glavnici +  + v_izracun_zatezne_rec.osnovica_izracuna_po_kamati,
                                          p_kamatna_stopa   => p_period_glavnica_ks_nacin.kamatna_stopa,
                                          p_broj_dana       => v_izracun_zatezne_rec.broj_dana,
                                          p_godina_obracuna => to_char(p_period_glavnica_ks_nacin.datum_do, 'YYYY'))
                  when p_period_glavnica_ks_nacin.nacin_obracuna = ju_tipovi_pkg.PROPORCIONALNI_OBRACUN
                    then proporcionalna_kamata(p_osnovica        => v_izracun_zatezne_rec.osnovica_izracuna_po_glavnici + v_izracun_zatezne_rec.osnovica_izracuna_po_kamati,
                                               p_kamatna_stopa   => p_period_glavnica_ks_nacin.kamatna_stopa,
                                               p_broj_dana       => v_izracun_zatezne_rec.broj_dana,
                                               p_godina_obracuna => to_char(p_period_glavnica_ks_nacin.datum_do, 'YYYY'))
                  else 0.00
                end;

         --v_izracun_zatezne_rec.ukupna_zatezna_kamata := v_izracun_zatezne_rec.kamata_prethodnog_razdoblja + v_izracun_zatezne_rec.zatezna_kamata;

         return v_izracun_zatezne_rec;
     end;
-------------------------------------------------------------------------------
     function priprema_za_sljedeci_period(
       p_kamata_za_period_rec    in   ju_tipovi_pkg.izracun_kamate_rec
     )
     return prethodno_razdoblje_rec
     is
       v_priprema_za_sljedece_rec    prethodno_razdoblje_rec;
     begin
       v_priprema_za_sljedece_rec.godina_prethodnog_razdoblja := to_char(p_kamata_za_period_rec.datum_do, 'YYYY');
       v_priprema_za_sljedece_rec.kamata_prethodnog_razdoblja := p_kamata_za_period_rec.zatezna_kamata;
       v_priprema_za_sljedece_rec.subtotal_zatezne_kamate     := p_kamata_za_period_rec.ukupna_zatezna_kamata;

       return v_priprema_za_sljedece_rec;
     end;
-------------------------------------------------------------------------------
-- PUBLIC PROCEDURES AND FUNCTIONS
-------------------------------------------------------------------------------
function obracunaj_zateznu(
       p_kamatne_stope_tab     in    ju_tipovi_pkg.kamatne_stope_tab_type
      ,p_nacin_obracuna_tab    in    ju_tipovi_pkg.nacin_obracuna_tab_type
      ,p_glavnice_tab          in    ju_tipovi_pkg.glavnice
      ,p_uplate_tab            in    ju_tipovi_pkg.uplate
      ,p_datum_obracuna        in    date  default sysdate
     )
     return ju_tipovi_pkg.izracun_kamate_tab_type
     is
          uplate_za_izracun_tab           temporal_uplate_tab_type;
          glavnice_u_periodu_tab          temporal_glavnice_tab_type;


          glavnica_po_ksu_tab             ju_tipovi_pkg.periodi_izracuna_glavnice_tt;
          glavnica_po_ksu_nacin_obr_tab   ju_tipovi_pkg.period_nacin_izracuna_tt;
          
          v_trenutna_osnovica_rec         ju_tipovi_pkg.glavnica_po_kamatnoj_stopi_rec;

          v_dio_obracuna_zatezne_rec      ju_tipovi_pkg.izracun_kamate_rec;
          obracun_zatezne_kamate_tab      ju_tipovi_pkg.izracun_kamate_tab_type;

          glavnica_idx                    number;
          v_glavnica                      ju_tipovi_pkg.transakcija_rec;

          v_prethodno_razdoblje_iznosi_r  prethodno_razdoblje_rec;

          v_uplate_u_periodu_tab          temporal_uplate_tab_type;--ju_tipovi_pkg.uplate;

          v_iskoristeni_iznos_uplate      number;
          
  
          upl                             number;
          v_uplata_id_u_obradi            number;
          v_datum_uplate                  date;


          ------------------------------------
          -- pomocne funkcije
          ------------------------------------
          function predani_svi_potrebni_podaci
          return boolean
          is
          begin
             return  p_kamatne_stope_tab.count > 0
                 and p_nacin_obracuna_tab.count > 0
                 and p_glavnice_tab.count > 0;
          end;
          ------------------------------------
          function trenutna_osnovica_za_glavnicu(
            p_glavnica_id             in      number
          )
          return number
          is
          begin
            return glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_glavnici;
          end;
          -------------------------------------
          function trenutna_osnovica_za_kamatu(
            p_glavnica_id             in      number
          )
          return number
          is
          begin
            return glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_kamati;
          end;
          ------------------------------------
          procedure osnovica_promijenjena(
            p_glavnica_id             in      number
           ,p_nova_osnovica_glavnica  in      number
           ,p_nova_osnovica_kamata    in      number
          )
          is
          begin
            --dbms_output.put_line('Osnovica promijenjena: glavnica_id: '||p_glavnica_id||' nova glavnica: '||p_nova_osnovica_glavnica||' nova kamata: '||p_nova_osnovica_kamata);
            glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_glavnici := least(glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_glavnici, p_nova_osnovica_glavnica);
            glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_kamati   := least(glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_kamati, p_nova_osnovica_kamata);
          end;
          ------------------------------------
          function uplata_iskoristena_u_iznosu(
            p_uplata_id                in      number
           ,p_obracun_perioda_rec      in      ju_tipovi_pkg.izracun_kamate_rec
          )
          return number
          is
             v_iskoristeni_iznos_uplate    number;
          begin
             --dbms_output.put_line('Uplata id: '||p_uplata_id||' iskoristena u iznosu: '||p_obracun_perioda_rec.umanjenje_zbog_uplate||' na glavnici: '||p_obracun_perioda_rec.glavnica_id);
             v_iskoristeni_iznos_uplate := p_obracun_perioda_rec.umanjenje_zbog_uplate;
             uplate_za_izracun_tab(p_uplata_id).preostali_iznos := uplate_za_izracun_tab(p_uplata_id).preostali_iznos - v_iskoristeni_iznos_uplate;

             return v_iskoristeni_iznos_uplate;
          end;
          ------------------------------------
          procedure dodaj_kamatu_u_obracun(
            p_nuliraj_ukupnu_zateznu      in    boolean default false
          )
          is
          begin
            --dbms_output.put_line('Dodajem: Ukupna zatezna: '||v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata||' zatezna: '||v_dio_obracuna_zatezne_rec.zatezna_kamata||' umanjenje: '||v_dio_obracuna_zatezne_rec.umanjenje_zbog_uplate||' osnovica za izracun: '||v_dio_obracuna_zatezne_rec.osnovica_za_izracun||' kamata prethodnog razdoblja: '||v_dio_obracuna_zatezne_rec.kamata_prethodnog_razdoblja);
--
--            dbms_output.put_line('v_dio_obracuna_zatezne_rec.glavnica_id: '||v_dio_obracuna_zatezne_rec.glavnica_id||' obracun_zatezne_kamate_tab.count: '||obracun_zatezne_kamate_tab.count);
--            dbms_output.put_line(case when p_nuliraj_ukupnu_zateznu then 'TURE' else 'FALSE' end);
--
--            if obracun_zatezne_kamate_tab.count > 0
--            then
--               dbms_output.put_line('obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id: '||obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id);
--            end if;

            if   p_nuliraj_ukupnu_zateznu
            and  obracun_zatezne_kamate_tab.exists(obracun_zatezne_kamate_tab.count)
            and  obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id = v_dio_obracuna_zatezne_rec.glavnica_id
            then
--                 dbms_output.put_line('if');
                 v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata :=  greatest(nvl(obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).ukupna_zatezna_kamata, 0) - nvl(v_dio_obracuna_zatezne_rec.umanjenje_zbog_uplate, 0), 0) + nvl(v_dio_obracuna_zatezne_rec.zatezna_kamata, 0);
            elsif not obracun_zatezne_kamate_tab.exists(obracun_zatezne_kamate_tab.count)
            or    obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id != v_dio_obracuna_zatezne_rec.glavnica_id
            then
--                 dbms_output.put_line('elsif');
                 v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata := nvl(v_dio_obracuna_zatezne_rec.zatezna_kamata, 0);
            else
--                 dbms_output.put_line('else');
                 v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata := v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata + nvl(v_dio_obracuna_zatezne_rec.zatezna_kamata, 0);
            end if;
            
            -- kad je uplata na zadnji dan predaje se datum od za jedan dan veći od datuma do da se ne obracunava zatezna, no da se izracuna zavrsno stanje
            if    v_dio_obracuna_zatezne_rec.datum_od > v_dio_obracuna_zatezne_rec.datum_do
            and   nvl(v_dio_obracuna_zatezne_rec.umanjenje_zbog_uplate, 0) > 0
            then
                v_dio_obracuna_zatezne_rec.uplata_na_zadnji_dan_YN := 'Y';
            else
                v_dio_obracuna_zatezne_rec.uplata_na_zadnji_dan_YN := null;
            end if;

--            dbms_output.put_line('Nakon ukupna zatezna: '||v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata);

            obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count + 1) := v_dio_obracuna_zatezne_rec;
          end;
          ------------------------------------
     begin
     ----
     -- POCÂETAK
     ----
          -- vrati praznu tablicu ako nisu predani potrebni podaci
          if not predani_svi_potrebni_podaci
          then
            return obracun_zatezne_kamate_tab;
          end if;

          ------------------------------------------------------
          -- obracun ide po svakoj rati glavnice
          --  1) za svaku glavnicu
          --     1 A) raspodjeli glavnicu po kamatama koje vrijede u tom razdoblju
          --       1 A 1) ako nema uplata - izracunaj za period uzimajuci u obzir nacin obracuna kamate
          --       1 A 2) ako ima uplata u periodu
          --              za svaku uplatu - novi period po uplati
          ------------------------------------------------------
          uplate_za_izracun_tab   := indeksiraj_uplate(p_uplate_tab);
          glavnice_u_periodu_tab  := indeksiraj_glavnice(p_glavnice_tab);

          glavnica_idx := p_glavnice_tab.first;
          loop

              v_glavnica := p_glavnice_tab(glavnica_idx);
              output_glavnica(v_glavnica);

              -- za novu glavnicu ne postoji prethodna kamata
              v_prethodno_razdoblje_iznosi_r.kamata_prethodnog_razdoblja := 0;

              -------------------
              --1 A -- raspodjeli glavnicu po kamatnim stopama koje vrijede u razdoblju od
              --       dospijeca glavnice do datuma obracuna
              -------------------
              glavnica_po_ksu_tab := podjela_glavnice_po_ksu(v_glavnica, p_kamatne_stope_tab, p_datum_obracuna);

              for i in 1..glavnica_po_ksu_tab.count
              loop
                   v_trenutna_osnovica_rec := glavnica_po_ksu_tab(i);

                   output_glavnica_po_ksu(v_trenutna_osnovica_rec);
                   v_uplate_u_periodu_tab := uplate_sjele_u_periodu(v_trenutna_osnovica_rec, uplate_za_izracun_tab);
                   
                   v_datum_uplate       := null;
                   
                   if v_uplate_u_periodu_tab.count > 0
                   then
                       upl := v_uplate_u_periodu_tab.first;
                       
                       loop  
                           v_datum_uplate := v_uplate_u_periodu_tab(upl).datum_uplate;
                           
                           -- avans ne cijepa razdoblje obracuna, a uplata unutar razdoblja da
                           v_trenutna_osnovica_rec.datum_do := greatest(v_datum_uplate, glavnica_po_ksu_tab(i).datum_do);
                          
                           glavnica_po_ksu_nacin_obr_tab  := nacin_izracuna_kamate(v_trenutna_osnovica_rec, p_nacin_obracuna_tab, v_datum_uplate);


                           for j in 1..glavnica_po_ksu_nacin_obr_tab.count
                           loop

                              if   v_uplata_id_u_obradi is not null 
                              and  v_uplata_id_u_obradi != upl
                              then
                                  v_dio_obracuna_zatezne_rec     := zatezna_za_period(glavnica_po_ksu_nacin_obr_tab(j), v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), uplate_za_izracun_tab(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id));
                                  dodaj_kamatu_u_obracun(true);
        
                                  v_iskoristeni_iznos_uplate := uplata_iskoristena_u_iznosu(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id, v_dio_obracuna_zatezne_rec);
                                  osnovica_promijenjena(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_glavnici, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_kamati);
                              -- AVANS
                              elsif  v_uplata_id_u_obradi is null
                              and    v_datum_uplate < glavnica_po_ksu_tab(i).datum_od
                              then
                                  v_dio_obracuna_zatezne_rec     := zatezna_za_period(glavnica_po_ksu_nacin_obr_tab(j), v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), uplate_za_izracun_tab(v_uplate_u_periodu_tab(upl).uplata_id));
                                  dodaj_kamatu_u_obracun(true);
        
                                  v_iskoristeni_iznos_uplate := uplata_iskoristena_u_iznosu(v_uplate_u_periodu_tab(upl).uplata_id, v_dio_obracuna_zatezne_rec);
                                  osnovica_promijenjena(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_glavnici, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_kamati);
                              else
                                  v_dio_obracuna_zatezne_rec     := zatezna_za_period(glavnica_po_ksu_nacin_obr_tab(j), v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id));
                                  dodaj_kamatu_u_obracun;
                              end if;
                                   
                              v_prethodno_razdoblje_iznosi_r := priprema_za_sljedeci_period(v_dio_obracuna_zatezne_rec);
                              
                              output_izracun_zatezne(v_dio_obracuna_zatezne_rec);
                              
                          end loop;
                          
                          v_trenutna_osnovica_rec.datum_od := v_datum_uplate + 1;
                          --v_trenutna_osnovica_rec.datum_od := greatest(v_datum_uplate, glavnica_po_ksu_tab(i).datum_do) + 1;
                          v_trenutna_osnovica_rec.datum_do := glavnica_po_ksu_tab(i).datum_do;
                          
                          
                          v_uplata_id_u_obradi := upl;
                          
                          exit when upl = v_uplate_u_periodu_tab.last;
                          upl := v_uplate_u_periodu_tab.next(upl);
                       end loop;
                   end if;
                   
                    -- ovaj izracun obuhvaca situacije bez uplate i situaciju kad nakon uplate jos ostaje razdoblje za izracun kamate
                    -- odredi nacin izracuna kamate (konformni ili proporcionalni) za period
                   -- >> start zadnji_dio
                   glavnica_po_ksu_nacin_obr_tab  := nacin_izracuna_kamate(v_trenutna_osnovica_rec, p_nacin_obracuna_tab, v_datum_uplate);


                   for j in 1..glavnica_po_ksu_nacin_obr_tab.count
                   loop
                      output_nacin_obracuna(glavnica_po_ksu_nacin_obr_tab(j));
                      
                      -- NIJE BILO UPLATA
                      if v_uplata_id_u_obradi is null
                      then
                        -- obracunaj zateznu za period
                            v_dio_obracuna_zatezne_rec     := zatezna_za_period(glavnica_po_ksu_nacin_obr_tab(j), v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id));
                            dodaj_kamatu_u_obracun;
                      -- AVANSNA UPLATA NEMA DRUGI DIO OBRACUNA, JER UPLATA NE CIJEPA PERIOD OBRACUNA
                      elsif v_uplata_id_u_obradi is not null
                      and   v_datum_uplate < glavnica_po_ksu_tab(i).datum_od
                      then
                            null;
                      -- DRUGI DIO OBRACUNA ZA UPLATU
                      else
                            v_dio_obracuna_zatezne_rec     := zatezna_za_period(glavnica_po_ksu_nacin_obr_tab(j), v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), uplate_za_izracun_tab(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id));
                            dodaj_kamatu_u_obracun(true);
        
                            v_iskoristeni_iznos_uplate := uplata_iskoristena_u_iznosu(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id, v_dio_obracuna_zatezne_rec);
                            osnovica_promijenjena(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_glavnici, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_kamati);

                      end if;

                      output_izracun_zatezne(v_dio_obracuna_zatezne_rec);

                      -- obraun ovog razdoblja je podloga za sljedeci period
                      v_prethodno_razdoblje_iznosi_r := priprema_za_sljedeci_period(v_dio_obracuna_zatezne_rec);
                   end loop;
                   -- >> end zadnji_dio
                    
                   v_uplata_id_u_obradi := null;
              end loop;

              -------------------
              --SLJEDECA GLAVNICA
              -------------------
              glavnica_idx:= p_glavnice_tab.next(glavnica_idx);
              exit when glavnica_idx is null;
          end loop;

          return obracun_zatezne_kamate_tab;
     end;



--     function obracunaj_zateznu_old(
--       p_kamatne_stope_tab     in    ju_tipovi_pkg.kamatne_stope_tab_type
--      ,p_nacin_obracuna_tab    in    ju_tipovi_pkg.nacin_obracuna_tab_type
--      ,p_glavnice_tab          in    ju_tipovi_pkg.glavnice
--      ,p_uplate_tab            in    ju_tipovi_pkg.uplate
--      ,p_datum_obracuna        in    date  default sysdate
--     )
--     return ju_tipovi_pkg.izracun_kamate_tab_type
--     is
--          uplate_za_izracun_tab           temporal_uplate_tab_type;
--          glavnice_u_periodu_tab          temporal_glavnice_tab_type;
--
--
--          glavnica_po_ksu_tab             ju_tipovi_pkg.periodi_izracuna_glavnice_tt;
--          glavnica_po_ksu_nacin_obr_tab   ju_tipovi_pkg.period_nacin_izracuna_tt;
--
--          v_dio_obracuna_zatezne_rec      ju_tipovi_pkg.izracun_kamate_rec;
--          obracun_zatezne_kamate_tab      ju_tipovi_pkg.izracun_kamate_tab_type;
--
--          glavnica_idx                    number;
--          v_glavnica                      ju_tipovi_pkg.transakcija_rec;
--
--          v_prethodno_razdoblje_iznosi_r  prethodno_razdoblje_rec;
--
--          v_uplate_u_periodu_tab          temporal_uplate_tab_type;--ju_tipovi_pkg.uplate;
--
--          v_iskoristeni_iznos_uplate      number;
--          
--  
--          upl                             number;
--          v_prije_uplate_rec              ju_tipovi_pkg.glavnica_po_ks_tip_obracun_rec;
--          v_poslije_uplate_rec            ju_tipovi_pkg.glavnica_po_ks_tip_obracun_rec;
--          v_uplata_id_u_obradi            number;
--          v_datum_uplate                  date;
--
--
--          ------------------------------------
--          -- pomocne funkcije
--          ------------------------------------
--          function predani_svi_potrebni_podaci
--          return boolean
--          is
--          begin
--             return  p_kamatne_stope_tab.count > 0
--                 and p_nacin_obracuna_tab.count > 0
--                 and p_glavnice_tab.count > 0;
--          end;
--          ------------------------------------
--          function trenutna_osnovica_za_glavnicu(
--            p_glavnica_id             in      number
--          )
--          return number
--          is
--          begin
--            return glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_glavnici;
--          end;
--          -------------------------------------
--          function trenutna_osnovica_za_kamatu(
--            p_glavnica_id             in      number
--          )
--          return number
--          is
--          begin
--            return glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_kamati;
--          end;
--          ------------------------------------
--          procedure osnovica_promijenjena(
--            p_glavnica_id             in      number
--           ,p_nova_osnovica_glavnica  in      number
--           ,p_nova_osnovica_kamata    in      number
--          )
--          is
--          begin
--            --dbms_output.put_line('Osnovica promijenjena: glavnica_id: '||p_glavnica_id||' nova glavnica: '||p_nova_osnovica_glavnica||' nova kamata: '||p_nova_osnovica_kamata);
--            glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_glavnici := least(glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_glavnici, p_nova_osnovica_glavnica);
--            glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_kamati   := least(glavnice_u_periodu_tab(p_glavnica_id).osnovica_izracuna_po_kamati, p_nova_osnovica_kamata);
--          end;
--          ------------------------------------
--          function uplata_iskoristena_u_iznosu(
--            p_uplata_id                in      number
--           ,p_obracun_perioda_rec      in      ju_tipovi_pkg.izracun_kamate_rec
--          )
--          return number
--          is
--             v_iskoristeni_iznos_uplate    number;
--          begin
--             --dbms_output.put_line('Uplata id: '||p_uplata_id||' iskoristena u iznosu: '||p_obracun_perioda_rec.umanjenje_zbog_uplate||' na glavnici: '||p_obracun_perioda_rec.glavnica_id);
--             v_iskoristeni_iznos_uplate := p_obracun_perioda_rec.umanjenje_zbog_uplate;
--             uplate_za_izracun_tab(p_uplata_id).preostali_iznos := uplate_za_izracun_tab(p_uplata_id).preostali_iznos - v_iskoristeni_iznos_uplate;
--
--             return v_iskoristeni_iznos_uplate;
--          end;
--          ------------------------------------
--          procedure dodaj_dio_u_obracun(
--            p_nuliraj_ukupnu_zateznu      in    boolean default false
--          )
--          is
--          begin
--            --dbms_output.put_line('Dodajem: Ukupna zatezna: '||v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata||' zatezna: '||v_dio_obracuna_zatezne_rec.zatezna_kamata||' umanjenje: '||v_dio_obracuna_zatezne_rec.umanjenje_zbog_uplate||' osnovica za izracun: '||v_dio_obracuna_zatezne_rec.osnovica_za_izracun||' kamata prethodnog razdoblja: '||v_dio_obracuna_zatezne_rec.kamata_prethodnog_razdoblja);
----
----            dbms_output.put_line('v_dio_obracuna_zatezne_rec.glavnica_id: '||v_dio_obracuna_zatezne_rec.glavnica_id||' obracun_zatezne_kamate_tab.count: '||obracun_zatezne_kamate_tab.count);
----            dbms_output.put_line(case when p_nuliraj_ukupnu_zateznu then 'TURE' else 'FALSE' end);
----
----            if obracun_zatezne_kamate_tab.count > 0
----            then
----               dbms_output.put_line('obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id: '||obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id);
----            end if;
--
--            if   p_nuliraj_ukupnu_zateznu
--            and  obracun_zatezne_kamate_tab.exists(obracun_zatezne_kamate_tab.count)
--            and  obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id = v_dio_obracuna_zatezne_rec.glavnica_id
--            then
----                 dbms_output.put_line('if');
--                 v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata :=  greatest(nvl(obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).ukupna_zatezna_kamata, 0) - nvl(v_dio_obracuna_zatezne_rec.umanjenje_zbog_uplate, 0), 0) + nvl(v_dio_obracuna_zatezne_rec.zatezna_kamata, 0);
--            elsif not obracun_zatezne_kamate_tab.exists(obracun_zatezne_kamate_tab.count)
--            or    obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count).glavnica_id != v_dio_obracuna_zatezne_rec.glavnica_id
--            then
----                 dbms_output.put_line('elsif');
--                 v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata := nvl(v_dio_obracuna_zatezne_rec.zatezna_kamata, 0);
--            else
----                 dbms_output.put_line('else');
--                 v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata := v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata + nvl(v_dio_obracuna_zatezne_rec.zatezna_kamata, 0);
--            end if;
--
----            dbms_output.put_line('Nakon ukupna zatezna: '||v_dio_obracuna_zatezne_rec.ukupna_zatezna_kamata);
--
--            obracun_zatezne_kamate_tab(obracun_zatezne_kamate_tab.count + 1) := v_dio_obracuna_zatezne_rec;
--          end;
--     begin
--     ----
--     -- POCÂETAK
--     ----
--          -- vrati praznu tablicu ako nisu predani potrebni podaci
--          if not predani_svi_potrebni_podaci
--          then
--            return obracun_zatezne_kamate_tab;
--          end if;
--
--          ------------------------------------------------------
--          -- obracun ide po svakoj rati glavnice
--          --  1) za svaku glavnicu
--          --     1 A) raspodjeli glavnicu po kamatama koje vrijede u tom razdoblju
--          --       1 A 1) ako nema uplata - izracunaj za period uzimajuci u obzir nacin obracuna kamate
--          --       1 A 2) ako ima uplata u periodu
--          --              za svaku uplatu - novi period po uplati
--          ------------------------------------------------------
--          uplate_za_izracun_tab   := indeksiraj_uplate(p_uplate_tab);
--          glavnice_u_periodu_tab  := indeksiraj_glavnice(p_glavnice_tab);
--
--          glavnica_idx := p_glavnice_tab.first;
--          loop
--
--              v_glavnica := p_glavnice_tab(glavnica_idx);
--              output_glavnica(v_glavnica);
--
--              -- za novu glavnicu ne postoji prethodna kamata
--              v_prethodno_razdoblje_iznosi_r.kamata_prethodnog_razdoblja := 0;
--
--              -------------------
--              --1 A -- raspodjeli glavnicu po kamatnim stopama koje vrijede u razdoblju od
--              --       dospijeca glavnice do datuma obracuna
--              -------------------
--              glavnica_po_ksu_tab := podjela_glavnice_po_ksu(v_glavnica, p_kamatne_stope_tab, p_datum_obracuna);
--
--              for i in 1..glavnica_po_ksu_tab.count
--              loop
--                   output_glavnica_po_ksu(glavnica_po_ksu_tab(i));
--                   v_uplate_u_periodu_tab := uplate_sjele_u_periodu(glavnica_po_ksu_tab(i), uplate_za_izracun_tab);
--
--                   --------
--                   -- 1 A 1
--                   --------
--                   if v_uplate_u_periodu_tab.count = 0
--                   then
--                      -- odredi nacin izracuna kamate (konformni ili proporcionalni) za period
--                      glavnica_po_ksu_nacin_obr_tab  := nacin_izracuna_kamate(glavnica_po_ksu_tab(i), p_nacin_obracuna_tab);
--
--
--                      for j in 1..glavnica_po_ksu_nacin_obr_tab.count
--                      loop
--                        output_nacin_obracuna(glavnica_po_ksu_nacin_obr_tab(j));
--
--                        -- obracunaj zateznu za period
--                        v_dio_obracuna_zatezne_rec     := zatezna_za_period(glavnica_po_ksu_nacin_obr_tab(j), v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id));
--                        output_izracun_zatezne(v_dio_obracuna_zatezne_rec);
--
--                        --dbms_output.put_line('DODAJ u OBRACUN: '||$$plsql_line);
--                        dodaj_dio_u_obracun;
--
--                        -- obraun ovog razdoblja je podloga za sljedeci period
--                        v_prethodno_razdoblje_iznosi_r := priprema_za_sljedeci_period(v_dio_obracuna_zatezne_rec);
--                      end loop;
--
--                   else
--                          -- odredi nacin izracuna kamate (konformni ili proporcionalni) za period
--                        glavnica_po_ksu_nacin_obr_tab  := nacin_izracuna_kamate(glavnica_po_ksu_tab(i), p_nacin_obracuna_tab);
--                        
--                        <<glavnica_po_ks>>
--                        for j in 1..glavnica_po_ksu_nacin_obr_tab.count
--                        loop
--
--                          output_nacin_obracuna(glavnica_po_ksu_nacin_obr_tab(j));
--                          v_datum_uplate       := null;
--                          v_uplata_id_u_obradi := null;
--
--                          upl := v_uplate_u_periodu_tab.first;
--                          --for upl in 1..v_uplate_u_periodu_tab.count
--                          <<uplate>>
--                          loop
--
--                              -- uplata sjela prije dospijeca glavnice
--                              -- ili iskoristen cijeli iznos uplate na prethodne periode
--                              if  v_uplate_u_periodu_tab(upl).datum_uplate <= glavnica_po_ksu_nacin_obr_tab(j).datum_od
--                              or  uplate_za_izracun_tab(v_uplate_u_periodu_tab(upl).uplata_id).preostali_iznos <= 0
--                              then
--                                  -- obracunaj zateznu za period
--                                  v_dio_obracuna_zatezne_rec     := zatezna_za_period(glavnica_po_ksu_nacin_obr_tab(j), v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), uplate_za_izracun_tab(v_uplate_u_periodu_tab(upl).uplata_id));
--                                  output_izracun_zatezne(v_dio_obracuna_zatezne_rec);
--
----                                  dbms_output.put_line('DODAJ u OBRACUN: '||$$plsql_line);
--                                  dodaj_dio_u_obracun(p_nuliraj_ukupnu_zateznu => true);
--
--                                  v_iskoristeni_iznos_uplate := uplata_iskoristena_u_iznosu(v_uplate_u_periodu_tab(upl).uplata_id, v_dio_obracuna_zatezne_rec);
--                                  osnovica_promijenjena(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_glavnici, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_kamati);
--
--
--                                  -- obraun ovog razdoblja je podloga za sljedeci period
--                                  v_prethodno_razdoblje_iznosi_r := priprema_za_sljedeci_period(v_dio_obracuna_zatezne_rec);
--                                  
--                                  exit when upl = v_uplate_u_periodu_tab.last or upl is null;
--                                  upl := v_uplate_u_periodu_tab.next(upl);
--
--                                  continue;
--
--                              -- uplata sjela u razdoblju obracuna glavnice
--                              elsif v_uplate_u_periodu_tab(upl).datum_uplate between glavnica_po_ksu_nacin_obr_tab(j).datum_od + 1 and glavnica_po_ksu_nacin_obr_tab(j).datum_do
--                              then
--                                       
--                                      v_prije_uplate_rec            := glavnica_po_ksu_nacin_obr_tab(j);
--                                      v_prije_uplate_rec.datum_do   := v_uplate_u_periodu_tab(upl).datum_uplate - 1;
--                                      if v_datum_uplate is not null
--                                      then
--                                         v_prije_uplate_rec.datum_od := greatest(v_datum_uplate, glavnica_po_ksu_nacin_obr_tab(j).datum_od);   
--                                      end if;
-- 
--                                      v_poslije_uplate_rec          := glavnica_po_ksu_nacin_obr_tab(j);
--                                      v_poslije_uplate_rec.datum_od := v_uplate_u_periodu_tab(upl).datum_uplate;
--                                      
--                                      v_datum_uplate                := v_uplate_u_periodu_tab(upl).datum_uplate;
--
--                                      -- 1 PRIJE UPLATE
--                                       -- obracunaj zateznu za period
--                                      if   v_uplata_id_u_obradi is not null
--                                      and  v_uplata_id_u_obradi != upl
--                                      then
--                                        v_dio_obracuna_zatezne_rec     := zatezna_za_period(v_poslije_uplate_rec, v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), uplate_za_izracun_tab(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id));
--                                        dodaj_dio_u_obracun(p_nuliraj_ukupnu_zateznu => true);
--                                        v_iskoristeni_iznos_uplate := uplata_iskoristena_u_iznosu(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id, v_dio_obracuna_zatezne_rec);
--                                        osnovica_promijenjena(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_glavnici, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_kamati);
--                                      else
--                                        v_dio_obracuna_zatezne_rec     := zatezna_za_period(v_prije_uplate_rec, v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id));
--                                        dodaj_dio_u_obracun;
--                                      end if;
--                                      
--                                      
--                                      output_izracun_zatezne(v_dio_obracuna_zatezne_rec);
--                                      
--                                      -- obraun ovog razdoblja je podloga za sljedeci period
--                                      v_prethodno_razdoblje_iznosi_r := priprema_za_sljedeci_period(v_dio_obracuna_zatezne_rec);
--
--                                      -- pri uplati se racuna kompletna kamata za doticnu glavnicu do tad
--                                      v_prethodno_razdoblje_iznosi_r.kamata_prethodnog_razdoblja := suma_kamate(obracun_zatezne_kamate_tab, v_dio_obracuna_zatezne_rec.glavnica_id);
--                                      
--                                      v_uplata_id_u_obradi          := upl;
--                                      /*
--                                      -- 2 POSLIJE UPLATE
--                                       -- obracunaj zateznu za period
--                                      v_dio_obracuna_zatezne_rec     := zatezna_za_period(v_poslije_uplate_rec, v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), uplate_za_izracun_tab(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id));
--                                      output_izracun_zatezne(v_dio_obracuna_zatezne_rec);
--
--                                      --dbms_output.put_line('DODAJ u OBRACUN: '||$$plsql_line);
--                                      dodaj_dio_u_obracun(p_nuliraj_ukupnu_zateznu => true);
--
--                                      v_iskoristeni_iznos_uplate := uplata_iskoristena_u_iznosu(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id, v_dio_obracuna_zatezne_rec);
--                                      osnovica_promijenjena(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_glavnici, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_kamati);
--
--
--                                      -- obraun ovog razdoblja je podloga za sljedeci period
--                                      v_prethodno_razdoblje_iznosi_r := priprema_za_sljedeci_period(v_dio_obracuna_zatezne_rec);
--                                      */
--                              end if;
--                           
--                           exit when upl = v_uplate_u_periodu_tab.last or upl is null;
--                           upl := v_uplate_u_periodu_tab.next(upl);
--
--                           end loop uplate;
--                                      if   v_uplata_id_u_obradi is not null
--                                      and  v_uplata_id_u_obradi = v_uplate_u_periodu_tab.last
--                                      then
--                                         -- 2 POSLIJE UPLATE
--                                         -- obracunaj zateznu za period
--                                        v_dio_obracuna_zatezne_rec     := zatezna_za_period(v_poslije_uplate_rec, v_prethodno_razdoblje_iznosi_r, trenutna_osnovica_za_glavnicu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), trenutna_osnovica_za_kamatu(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id), uplate_za_izracun_tab(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id));
--                                        output_izracun_zatezne(v_dio_obracuna_zatezne_rec);
--
--                                        --dbms_output.put_line('DODAJ u OBRACUN: '||$$plsql_line);
--                                        dodaj_dio_u_obracun(p_nuliraj_ukupnu_zateznu => true);
--
--                                        v_iskoristeni_iznos_uplate := uplata_iskoristena_u_iznosu(v_uplate_u_periodu_tab(v_uplata_id_u_obradi).uplata_id, v_dio_obracuna_zatezne_rec);
--                                        osnovica_promijenjena(glavnica_po_ksu_nacin_obr_tab(j).glavnica_id, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_glavnici, v_dio_obracuna_zatezne_rec.osnovica_izracuna_po_kamati);
--
--
--                                        -- obraun ovog razdoblja je podloga za sljedeci period
--                                        v_prethodno_razdoblje_iznosi_r := priprema_za_sljedeci_period(v_dio_obracuna_zatezne_rec);
--                                      end if;
--
--                        end loop glavnica_po_ks;
--
--                   end if;
--
--              end loop;
--
--              -------------------
--              --SLJEDECA GLAVNICA
--              -------------------
--              glavnica_idx:= p_glavnice_tab.next(glavnica_idx);
--              exit when glavnica_idx is null;
--          end loop;
--
--          return obracun_zatezne_kamate_tab;
--     end;


-------------------------------------------------------------------------------
    
-------------------------------------------------------------------------------
     function suma_glavnice_old(
       p_uplate_tab                in    ju_tipovi_pkg.glavnice
     )
     return number
     is
       v_suma_glavnice        number := 0;
     begin
       for i in 1..p_uplate_tab.count
       loop
         v_suma_glavnice := nvl(v_suma_glavnice, 0) + p_uplate_tab(i).iznos;
       end loop;

       return v_suma_glavnice;
     end;
------------------------------------------------------------------------------
     function suma_glavnice(
       p_obracun_zatezne_tab       in    ju_tipovi_pkg.izracun_kamate_tab_type
      ,p_za_glavnicu_id            in    number default null
     )
     return number
     is
        v_suma_glavnice   number := 0;

        type osnovica_po_glavnici_tab_type is table of number
        index by pls_integer;

        osnovica_po_glavnici_tab   osnovica_po_glavnici_tab_type ;
        
        glavnica_id     pls_integer;
     begin
        for i in 1..p_obracun_zatezne_tab.count
        loop
             if nvl(p_za_glavnicu_id, p_obracun_zatezne_tab(i).glavnica_id) = p_obracun_zatezne_tab(i).glavnica_id
             then
                osnovica_po_glavnici_tab(p_obracun_zatezne_tab(i).glavnica_id) := p_obracun_zatezne_tab(i).osnovica_izracuna_po_glavnici;
             end if;
        end loop;


       if osnovica_po_glavnici_tab.count = 0
        then
          return 0;
        end if;
        
        glavnica_id := osnovica_po_glavnici_tab.first;
             
        loop
           v_suma_glavnice := nvl(v_suma_glavnice, 0) + nvl(osnovica_po_glavnici_tab(glavnica_id), 0);
          
           exit when glavnica_id = osnovica_po_glavnici_tab.last;
           glavnica_id := osnovica_po_glavnici_tab.next(glavnica_id);
        end loop;

--        for glavnica_id in 1..osnovica_po_glavnici_tab.count
--        loop
--          v_suma_glavnice := nvl(v_suma_glavnice, 0) + nvl(osnovica_po_glavnici_tab(glavnica_id), 0);
--        end loop;

        return nvl(v_suma_glavnice, 0);
     end;
-------------------------------------------------------------------------------
     function suma_kamate_old(
       p_obracun_zatezne_tab       in    ju_tipovi_pkg.izracun_kamate_tab_type
      ,p_za_glavnicu_id            in    number default null
     )
     return number
     is
        v_suma_kamate   number := 0;
     begin
        for i in 1..p_obracun_zatezne_tab.count
        loop

             dbms_output.put_line('glavnica: '||p_obracun_zatezne_tab(i).glavnica_id||' zatezna kamata: '||p_obracun_zatezne_tab(i).zatezna_kamata||' broj dana: '||p_obracun_zatezne_tab(i).broj_dana||' od-do: '||p_obracun_zatezne_tab(i).datum_od||'-'||p_obracun_zatezne_tab(i).datum_do||' nacin: '||p_obracun_zatezne_tab(i).nacin_izracuna_kamate||' ks: '||p_obracun_zatezne_tab(i).kamatna_stopa||' osnovnica za izracun po glavnici: '||p_obracun_zatezne_tab(i).osnovica_izracuna_po_glavnici||' umanjenje zbog uplate (id='||p_obracun_zatezne_tab(i).uplata_id||'): '||p_obracun_zatezne_tab(i).umanjenje_zbog_uplate||' ukupna zatezna: '||p_obracun_zatezne_tab(i).ukupna_zatezna_kamata);

             if nvl(p_za_glavnicu_id, p_obracun_zatezne_tab(i).glavnica_id) = p_obracun_zatezne_tab(i).glavnica_id
             then
               v_suma_kamate := nvl(v_suma_kamate, 0) + p_obracun_zatezne_tab(i).zatezna_kamata;
             end if;
        end loop;

        return nvl(v_suma_kamate, 0);
     end;
-------------------------------------------------------------------------------
     function suma_kamate(
       p_obracun_zatezne_tab       in    ju_tipovi_pkg.izracun_kamate_tab_type
      ,p_za_glavnicu_id            in    number default null
     )
     return number
     is
        v_suma_kamate   number := 0;

        type zatezna_po_glavnici_tab_type is table of number
        index by pls_integer;

        zatezna_po_glavnici_tab zatezna_po_glavnici_tab_type ;
        
        glavnica_id     pls_integer;
     begin
        for i in 1..p_obracun_zatezne_tab.count
        loop
             if nvl(p_za_glavnicu_id, p_obracun_zatezne_tab(i).glavnica_id) = p_obracun_zatezne_tab(i).glavnica_id
             then
                zatezna_po_glavnici_tab(p_obracun_zatezne_tab(i).glavnica_id) := p_obracun_zatezne_tab(i).ukupna_zatezna_kamata;
             end if;
        end loop;

        if zatezna_po_glavnici_tab.count = 0
        then
          return 0;
        end if;
        
        glavnica_id := zatezna_po_glavnici_tab.first;
             
        loop
           v_suma_kamate := nvl(v_suma_kamate, 0) + nvl(zatezna_po_glavnici_tab(glavnica_id), 0);
          
           exit when glavnica_id = zatezna_po_glavnici_tab.last;
           glavnica_id := zatezna_po_glavnici_tab.next(glavnica_id);
        end loop;
         
--        for glavnica_id in 1..zatezna_po_glavnici_tab.count
--        loop
--          v_suma_kamate := nvl(v_suma_kamate, 0) + nvl(zatezna_po_glavnici_tab(glavnica_id), 0);
--        end loop;

        return nvl(v_suma_kamate, 0);
     end;


end ju_obracun_kamate_pkg;
/
