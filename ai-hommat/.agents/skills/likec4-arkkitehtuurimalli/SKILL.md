---
name: likec4-arkkitehtuurimalli
description:
    Use this skill to create, update or fix LikeC4 architecture model files at docs\architecture\.
---

# LikeC4 Arkkitehtuurimalli

## Tarkoitus

Tata skillia kaytetaan, kun muokataan tai laajennetaan LikeC4-pohjaista arkkitehtuurimallia
hakemistossa `docs\architecture\`.

Skillin tavoite on:

- lisata uusia elementteja (systeemat, containerit, komponentit, aktorit)
- lisata tai paivittaa relaatioita systeemien valilla
- lisata tai paivittaa nakyma (views)
- korjata FQN-viittauksia tai muita syntaksivirheita

## Milloin kayttaa

Kayta tata, kun:

- lisataan uusi sovellus, tietokanta tai integraatio arkkitehtuuriin
- paivitetaan olemassa olevan elementin kuvausta tai yhteyksia
- korjataan LSP-virheilmoituksia (esim. "Could not resolve reference")
- luodaan uusi view (staattinen tai dynaaminen)

## Tiedostorakenne

Arkkitehtuurimalli on jaettu tiedostoihin vastuun mukaan:

| Tiedosto | Sisalto |
|---|---|
| `1spec.c4` | LikeC4 specification (elementtityypit, tyylisaannot) |
| `2sys-vanha-dw.c4` | Vanha DW -systeemi: PaivitysLomake, Tulosraportointi, dw-sovellus, Excel-raportit |
| `2sys-power-bi-dw.c4` | PowerBI DW -systeemi: tietokannat, SSIS-container, SSAS-kuutio, SQL Agent |
| `2sys-power-bi-service.c4` | Power BI Service SaaS -systeemi |
| `2sys-ulkoiset.c4` | Ulkoiset lahdejarjestelmat: IFS, Luja2000, Nettikoti, Hops |
| `2sys-uudet.c4` | Uudet sovellukset: Kiku-budjetointisovellus |
| `3relations.c4` | Kaikki systeemien valiset relaatiot |
| `9views.c4` | Kaikki nakymat (staattinen + dynaaminen) |

Uusi systeemi saa oman `2sys-<nimi>.c4` -tiedoston.

## Kriittiset syntaksisaannot

### 1. Ei extend-avainsanaa

LikeC4:ssa **ei ole** `extend`-avainsanaa. Sen sijaan sama systeemi maaritellaan
uudelleen omassa `2sys-xyz.c4`-tiedostossaan. LikeC4 yhdistaa kaikki `model {}`-lohkot
automaattisesti.

Oikea tapa:

```
// 2sys-vanha-dw.c4
model {
  vanha_dw = system 'Vanha DW' {
    paivityslomake = app 'PaivitysLomake' {
      ...
    }
  }
}
```

### 2. FQN pakollinen ulkopuolisissa viittauksissa

Nested-elementteihin (containerit, komponentit) viiitataan **taydella polulla** kaikissa
ulkopuolisissa yhteyksissä (3relations.c4, 9views.c4, toinen sys-tiedosto).

| Tilanne | Oikea viittaus |
|---|---|
| Relaatio 3relations.c4:ssa | `power_bi_dw.ssis.ssis_result` |
| Include view:ssa | `power_bi_dw.ssis.ssis_result` |
| Dynamic view -askel | `power_bi_dw.ssis.ssis_result` |

Lyhyt nimi toimii VAIN saman `{}`-lohkon sisalla (internal relaatiot sys-tiedostossa).

### 3. Validit varit

Kaytetaan vain naita: `primary, secondary, muted, slate, blue, indigo, sky, red, gray, green, amber`

**Ei** kayteta: `purple`, `yellow`, tai muita.

### 4. Identifikaattorit

- Vain ASCII-merkit: ei `a`, `o` tai muita erikoismerkkeja
- Piste `.`-notaatio sallittu viittauksissa (FQN)
- Esimerkki: `ssis_ifs` (ei `ssis_ifs`)

### 5. SSIS-hierarkia power_bi_dw-systeemissa

SSIS on maariteltava nain (container sisaltaa komponentit):

```
power_bi_dw = system 'PowerBI DW' {
  ssis = etl 'SSIS ETL' {
    ssis_kohde = component 'Ulkoiset → OldDW' { ... }
    ssis_ifs   = component 'IFS → Staging' { ... }
    ssis_olddw_staging = component 'OldDW → Staging' { ... }
    ssis_result        = component 'Result Staging → DW' { ... }
    ssis_staging_dw    = component 'Staging → DW' { ... }
  }
}
```

FQN-viittaukset naiden komponentteihin:
- `power_bi_dw.ssis.ssis_kohde`
- `power_bi_dw.ssis.ssis_ifs`
- `power_bi_dw.ssis.ssis_olddw_staging`
- `power_bi_dw.ssis.ssis_result`
- `power_bi_dw.ssis.ssis_staging_dw`

## Dynamic views

Dynamic view kuvaa tapahtumaketjun (flow tai sequence):

```
dynamic view kauden_vaihto {
  title '...'
  talouden_paakayttaja -> vanha_dw.paivityslomake 'Tallentaa uuden kauden'
  vanha_dw.paivityslomake -> power_bi_dw.lujaBI_control 'UPDATE ReportingPeriodCurrent'
  ...
  include talouden_paakayttaja
  include vanha_dw.dw_db
}
```

- `include` lisaa kontekstielementteja jotka eivat ole askelissa mutta halutaan nakyviin
- `dynamic view sequence <id>` tekee sekvenssidiagrammin tavallisen flow-diagrammin sijaan

## Tyotapa

1. **Lue nykyinen malli** tiedostoista `docs\architecture\` ennen muutoksia
2. **Maarita oikea tiedosto**: uusi systeemi → uusi `2sys-*.c4`; uusi relaatio → `3relations.c4`; uusi view → `9views.c4`
3. **Tarkista FQN**: jos elementti on nested (container/component sisalla systeemia), kayta taytta polkua kaikissa ulkopuolisissa viittauksissa
4. **Paivita README** (`docs\architecture\README.md`) jos lisaat uuden tiedoston tai nakyma-taulukon rivi puuttuu

## Playground-validointi

https://likec4.dev/playground/

Voit liittaa yksittaisen tiedoston sisallon sinne testataksesi syntaksia ennen tallennusta.

## Valmis lopputulos

Hyva muutos LikeC4-malliin:

- ei aiheuta LSP-virheita (puuttuvat viittaukset, vaarat identifikaattorit)
- kayttaa oikeita FQN-polkuja kaikissa ulkopuolisissa viittauksissa
- kayttaa vain valideja varia
- paivittaa README jos lisataan uusi tiedosto tai nakyma
- sailyttaa olemassa olevan rakenteen — ei poista dokumentoituja elementteja
