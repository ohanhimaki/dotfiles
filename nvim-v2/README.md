# nvim-v2

Uusi, oma Neovim-konfiguraatio, joka rakennetaan nykyisen `nvim/`-konfiguraation
pohjalta valikoiden. Tavoite ei ole kopioida kaikkea sellaisenaan eikä ottaa
LazyVimiä pohjaksi, vaan tehdä nykyisestä työnkulusta pienempi ja helpommin
ymmärrettävä versio.

Nykyinen `nvim/` säilyy toimivana vertailukohtana koko siirtymän ajan.

## Toteutustilanne

- [x] lazy.nvim-bootstrap ja lockfile
- [x] perusoptionit, autocmds ja keymapit
- [x] tiedosto- ja riviviitteiden kopiointi Git-repon juureen suhteutettuna
- [x] Tokyo Night, Snacks, valikoidut Mini-moduulit ja Which-key
- [x] Treesitter-konfiguraatio ja määritettyjen parserien asennuskomento
- [x] Blink completion ja Conform-formatointi
- [x] yleinen LSP-konfiguraatio, Mason ja työkalulista
- [x] `roslyn.nvim`-konfiguraatio C#-, Razor- ja test-CodeLenseille
- [ ] parserien ja Mason-työkalujen oikea ensiasennus Windowsissa ja WSL:ssä
- [ ] Roslynin todentaminen oikealla C#- ja Blazor-solutionilla
- [ ] nvim-dap, netcoredbg ja nvim-dap-view
- [ ] Roslynin test-CodeLensien ja mahdollisen Neotestin vertailu

Pluginikerroksen puhdas ja uudelleenkäynnistetty headless-testi on tehty
Windowsissa. Testissä automaattiset parseri- ja Mason-asennukset ohitettiin
`NVIM_V2_SKIP_INSTALL=1`-muuttujalla, joten sitä ei lasketa oikeiden työkalujen
asennuksen tai kielipalvelimen toiminnan todennukseksi.

## Lähtöpäätökset

- Pluginien hallintaan käytetään [lazy.nvim](https://github.com/folke/lazy.nvim):ää.
- Konfiguraatio tehdään itse; LazyVim-distribuutiota ei käytetä.
- Tavoiteversio on Neovim 0.12. Paikallinen versio suunnitelmaa tehtäessä on
  0.12.4, ja `roslyn.nvim` vaatii vähintään version 0.12.
- `easy-dotnet.nvim` jätetään pois ensimmäisestä versiosta.
- `sidekick.nvim` jätetään pois. Tekoäly-CLI ajetaan Herdrissä omassa ikkunassaan.
- Tiedosto- ja riviviitteiden kopiointi pidetään omana pienenä Lua-moduulina,
  joka ei riipu tekoälypluginista.
- Aluksi lisätään vain työnkulun kannalta tarpeelliset pluginit. Vanhan konffin
  plugin tuodaan mukaan vasta, kun sille on nimetty käyttötapaus.

### Miksi lazy.nvim eikä vim.pack?

`vim.pack` on houkuttelevan pieni ja Neovimin mukana tuleva ratkaisu, mutta se
hoitaa ennen kaikkea pluginien hankinnan ja päivityksen. Nykyisessä konffissa
latausajankohtia on jouduttu rakentamaan itse muun muassa `vim.schedule`-kutsuilla.

Lazy.nvim sopii tähän uudelleenrakennukseen paremmin, koska pluginin riippuvuudet,
`ft`-, `cmd`- ja `keys`-ehdot, asetukset, lockfile ja latausprofiili voidaan kuvata
samassa plugin-speksissä. Tavoite ei silti ole tehdä jokaisesta pluginista väkisin
lazy-loadattavaa: jos pluginin oma dokumentaatio suosittelee käynnistyksessä
lataamista, sitä suositusta noudatetaan.

## Suunniteltu rakenne

```text
nvim-v2/
├── init.lua
├── lazy-lock.json
└── lua/
    ├── config/
    │   ├── lazy.lua
    │   ├── options.lua
    │   ├── autocmds.lua
    │   ├── keymaps.lua
    │   └── references.lua
    └── plugins/
        ├── editor.lua
        ├── ui.lua
        ├── treesitter.lua
        ├── completion.lua
        ├── formatting.lua
        ├── lsp.lua
        ├── dotnet.lua
        ├── debugging.lua
        └── testing.lua
```

Jaottelu saa muuttua toteutuksen aikana. Olennaista on, että yleinen LSP,
.NET-erityislogiikka, debuggaus ja testaus eivät päädy yhteen suureen tiedostoon.

## .NET-kokeilu ilman EasyDotnetiä

### LSP: roslyn.nvim

Ensisijainen kokonaisuus:

- [seblyng/roslyn.nvim](https://github.com/seblyng/roslyn.nvim)
- Roslyn language server Masonin kautta
- Masonin rekisterit järjestyksessä `mason-org/mason-registry` ja
  `Crashdummyy/mason-registry`
- vakaa `roslyn`-paketti, ei aluksi `roslyn-nightly`
- C#-, Razor- ja CSHTML-tiedostot samalla Roslyn-kokonaisuudella; vanhaa
  `rzls.nvim`-ratkaisua ei tarvita

Nykyisestä Roslyn-konfiguraatiosta kopioidaan asetuksia vain tarpeen mukaan:

- inlay hintit
- reference- ja test-CodeLensit
- completion unimported namespaceista
- background analysis aluksi `openFiles`
- organize imports on format

Semanttisia tokeneita tai document highlightia ei poisteta automaattisesti kuten
vanhan konffin kommentoidussa kokeessa. Ensin tarkistetaan Roslynin ja Razorin
nykyinen toiminta oletuksilla.

Roslynin target-valinta (`:Roslyn target`) saa hoitaa usean solutionin tapaukset.
`broad_search` ja `lock_target` otetaan käyttöön vain, jos oikea projektirakenne
niitä tarvitsee.

### Debug: nvim-dap + netcoredbg + nvim-dap-view

Ensimmäinen debug-pino:

- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- `netcoredbg`, ensisijaisesti Masonin asentamana
- `coreclr`-adapteri pienellä omalla konfiguraatiolla tai
  `mason-nvim-dap.nvim`:llä
- [igorlfs/nvim-dap-view](https://github.com/igorlfs/nvim-dap-view) nykyisen
  `nvim-dap-ui`:n tilalle

Säilytettävät perustoiminnot ovat käynnistys/jatkaminen, breakpoint, step over,
step into, step out, pysäytys, REPL, muuttujien tarkastelu sekä arvon kopiointi.
Nykyiset funktionäppäimet voidaan kopioida ensin sellaisinaan, jotta kokeilu ei
samalla muuta lihasmuistia.

`nvim-dap-view` tarjoaa scopet, watchit, call stackin, breakpointit, REPL:n,
hoverin ja inline-arvot. Se kokeillaan ensin ilman `nvim-dap-ui`:ta, jotta kahta
päällekkäistä debug-UI:ta ei ylläpidetä.

### Testaus: kaksi vaihetta

1. **Roslynin omat test-CodeLensit.** Otetaan käyttöön
   `dotnet_enable_tests_code_lens` ja tehdään mapping CodeLensin ajamiseen.
   Roslyn osaa ajaa testin sekä käynnistää `Debug Test` -toiminnon DAPin
   `coreclr`-adapterilla. Tämä on pienin mahdollinen EasyDotnetistä riippumaton
   toteutus.
2. **Neotest-kokeilu tarvittaessa.** Jos tarvitaan testipuu, run-nearest,
   tiedosto-/solution-tason ajot ja pysyvä tulosnäkymä, kokeillaan
   [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest) +
   [Issafalcon/neotest-dotnet](https://github.com/Issafalcon/neotest-dotnet).
   Adapteri tukee myös testin debuggausta `netcoredbg`:llä.

Neotest-dotnet ilmoittaa etsivänsä uusia ylläpitäjiä ja dokumentoi rajoitteita
parametrisoiduissa testeissä. Siksi Roslynin oma testiajo arvioidaan ensin eikä
Neotestiä tehdä heti konffin välttämättömäksi perustaksi.

Arvioitavat testitapaukset:

- lähimmän xUnit-, NUnit- tai MSTest-testin ajo
- koko tiedoston ja projektin testit
- parametrisoitu testi
- epäonnistuneen testin output ja stack trace
- testin debuggaus breakpointtiin
- `.runsettings`, jos nykyiset projektit käyttävät sitä

## Tekoälytyönkulku ja viitteiden kopiointi

Sidekickin CLI-istuntoja, promptteja tai lähetysmappingeja ei kopioida.
Herdr ja tekoäly pysyvät Neovimin ulkopuolisessa ikkunassa.

Nykyisestä konffista säilytetään ainakin ajatus näistä omista toiminnoista:

- suhteellisen tiedostopolun kopiointi
- tiedostopolun ja visuaalisen rivialueen kopiointi muodossa
  `polku/tiedosto.lua:alku:loppu`
- tarvittaessa absoluuttisen polun ja pelkän tiedostonimen kopiointi

Toteutuksessa päätetään käytetäänkö suhteellisen polun juurena nykyistä
työhakemistoa vai Git-repon juurta. Tuloksen pitää toimia samalla tavalla
Windowsissa, WSL:ssä ja Linuxissa. Mappingit sijoitetaan omaan
`config/references.lua`-moduuliin.

Copilot käsitellään erillisenä päätöksenä. Sidekickin poistaminen ei pakota
poistamaan inline-completionia, mutta sitä ei oteta mukaan ennen kuin päätetään,
onko se osa tavoiteltua Herdr-työnkulkua.

## Mitä vanhasta konffista otetaan mukaan?

### Ensimmäiseen toimivaan versioon

- hyväksi havaitut optionit, diagnostiset asetukset ja perus-autocommandit
- nykyiset tärkeimmät omat keymapit
- Tokyo Night (`moon`), jotta v2 erottuu vanhasta Gruvbox-konffista
- valikoidut `mini.nvim`-moduulit
- Snacks picker, notifier ja lazygit-integraatio
- Treesitter ja C#/Razor-parserit
- `blink.cmp`
- `conform.nvim`
- `nvim-lspconfig`, Mason ja työkalujen hallinta
- Roslyn-, DAP- ja testauskokeilu yllä kuvatulla tavalla
- Which-key mappingien löydettävyyteen

### Ei ensimmäiseen versioon

- `easy-dotnet.nvim`
- `sidekick.nvim`
- `nvim-dap-ui` ja sen `nvim-nio`-riippuvuus, ellei Neotest tarvitse jälkimmäistä
- käsin tehty `User FilePost` -lataustapa ja pluginien `vim.schedule`-kiertotiet
- `vim.pack`-päivityskomennot
- yksityinen ja kokeellinen `vim._core.ui2`
- Python-DAP ja Yarepl ennen kuin niille on tässä konffissa selvä tarve

### Myöhemmin arvioitavat ja päällekkäiset ratkaisut

- Seeker jätetään aluksi pois. Snacksin oma grep kattaa todennäköisesti
  tarvittavan asteittaisen rajauksen ilman erillistä pluginia.
- MiniFiles vai Snacks explorer: valitaan käytön perusteella yksi pääpolku
- Quicker ja Trouble: pidetään molemmat vain, jos niillä on selvästi eri tehtävät
- Dropbar ja Treesitter Context: valitaan yksi oletus, ei vaihtokonetta heti
- dashboard, persistence, flash, todo-comments, render-markdown ja img-clip
- Dadbod
- nykyinen oma `git_repos`-moduuli
- LikeC4-tuki

Näitä ei hylätä lopullisesti. Ne lisätään yksi kerrallaan vasta peruskonffin
toimiessa, jolloin jokaisen vaikutus ja tarpeellisuus näkyy.

### Grep-haun asteittainen rajaus

`<leader>fw` avaa Snacksin grep-pickerin. Sisältöhaun jälkeen `<C-g>` vaihtaa
syötekentän matcher-tilaan, jossa tuloksia voi rajata tiedostonimen tai polun
perusteella, esimerkiksi:

- `file:cs$` vain C#-tiedostoihin
- `file:razor$` vain Razor-tiedostoihin
- `file:Features/Orders` tiettyyn hakemistoon
- `file:!Generated/` pois Generated-hakemistosta

Toinen `<C-g>` palaa sisältöhakuun ja säilyttää tiedostorajauksen. Seeker
arvioidaan uudelleen vain, jos käytössä ilmenee tarve muodostaa käsin valituista
tiedostoista erillinen hakujoukko.

## Toteutusjärjestys

1. Bootstrapataan lazy.nvim ja luodaan yllä oleva hakemistorakenne.
2. Kopioidaan optionit, perus-autocommandit ja tärkeimmät mappingit ilman
   plugineja.
3. Lisätään teema, Snacks, valikoidut Mini-moduulit ja Which-key.
4. Lisätään Treesitter, Blink, Conform, yleinen LSP ja Mason.
5. Otetaan `roslyn.nvim` käyttöön ja varmennetaan C# sekä Razor/Blazor.
6. Lisätään `nvim-dap`, `netcoredbg` ja `nvim-dap-view`.
7. Kokeillaan ensin Roslynin test-CodeLensejä, sitten tarvittaessa Neotestiä.
8. Siirretään omat viitemappingit ja testataan Herdr-työnkulku.
9. Tuodaan puuttuvia vanhoja ominaisuuksia takaisin yksi kerrallaan.
10. Vasta toimivan rinnakkaistestin jälkeen vaihdetaan symlinkki osoittamaan
    `nvim-v2`:een.

## Valmistumiskriteerit

- puhdas käynnistys ilman virheitä Windowsissa ja WSL:ssä/Linuxissa
- `:checkhealth` ei näytä olennaisia LSP-, Treesitter-, Mason- tai DAP-virheitä
- Lazy-lockfile tekee asennuksesta toistettavan
- C# completion, definition, references, rename, diagnostics, formatting ja
  CodeLens toimivat
- `.razor`-tiedostossa toimivat sekä C#- että HTML-puolen olennaiset ominaisuudet
- tavallinen .NET-projekti voidaan käynnistää ja breakpointiin pysähtyä
- vähintään lähimmän testin ajo ja debuggaus toimivat
- tiedosto- ja riviviite voidaan kopioida ja käyttää Herdrissä ilman käsin
  muokkaamista
- käynnistys ja ensimmäisen C#-tiedoston avaus profiloidaan; optimointi tehdään
  mitatun pullonkaulan, ei pelkän pluginimäärän perusteella

Symlinkkejä ei vaihdeta automaattisesti kehityksen aikana. Kun vaihto on
ajankohtainen, käyttäjä ajaa `makesymlinks.ps1`:n itse elevated PowerShellissä
tai Developer Mode päällä repositoryn ohjeiden mukaisesti.
