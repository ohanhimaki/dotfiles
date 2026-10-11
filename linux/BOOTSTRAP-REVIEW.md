# Bootstrapin tarkistus 10.10.2026

## Rakenne ja ylläpito

`bootstrap.sh` linkittää yhteiset asetukset ja asentaa CLI-työkalut.
`scripts/bootstrap-common.sh` sisältää argumentit, linkkien varmuuskopioinnin,
WSL-tunnistuksen ja Neovimin asennuspuun vaihdon.
`scripts/install-codex.sh` hallitsee Codexin standalone-asennusta.
`linux/go-mint.sh` ja `linux/go-fedora.sh` kutsuvat bootstrapia ja lisäävät
`desktop-common.sh`:n sovellukset, fontit ja erikseen pyydetyt työpöytäasetukset.
`linux/go.sh` on Mint-skriptin yhteensopivuuskutsu. WSL käyttää vain yhteistä bootstrapia.

Tavallinen ajo asentaa puuttuvat työkalut. `--update` hakee uusimmat julkaisut
Neovimille, LazyGitille, Starshipille ja Yazi/ya:lle sekä päivittää Rustupin
hallinnoimat toolchainit, Tree-sitter CLI:n ja .NET 10 SDK:n. Home-profiili
päivittää myös standalone-Codexin. Profiili on aina pakollinen.
`--update --symlinks-only` hylätään ennen muutoksia.

APT/DNF asentaa nimetyt riippuvuudet; tämä voi päivittää kyseisiä paketteja
myös normaalissa ajossa. Koko jakelua tai Flatpak-sovelluksia ei päivitetä.
Työpöytäajon `--update` päivittää lisäksi paketinhallinnalla asennetun WezTermin.
Muulla tavalla asennetun WezTermin ylläpito pitää arvioida erikseen.

Neovimin valmis lataus tarkistetaan ilman käyttäjän konfiguraatiota.
Olemassa oleva `/opt/nvim-linux-<arch>` siirretään yksilölliseksi varmuuskopioksi,
uusi puu kopioidaan kokonaisena ja kopiointivirhe palauttaa vanhan puun.
Näin vanhat runtime-tiedostot eivät jää uuden julkaisun sekaan.
Varmuuskopioita ei siivota automaattisesti. Uusi ajo asentaa saman julkaisun
uudelleen, jos `--update` annetaan; versionvertailuun ei lisätty erillistä logiikkaa.

LazyGitin, Starshipin ja Yazin päivitys voi luoda käyttäjäkohtaisen kopion
vanhan järjestelmäasennuksen rinnalle. `~/.local/bin` valitsee uuden kopion,
vanhaa asennusta ei poisteta. Codexin oma skripti hylkää päivityksen, jos
löydetty asennus kuuluu toiselle asentimelle; bootstrap pysähtyy tähän virheeseen.

## Jakelut ja arkkitehtuurit

| Kohde | Toteutus | Todennuksen raja |
| --- | --- | --- |
| Mint 22.2 / Ubuntu | APT-riippuvuudet, paikalliset SDK:t, WezTermin APT-lähde | Mintin nykytila luettu; asennukset simuloitu |
| Fedora | DNF-riippuvuudet, samat CLI-lataukset, WezTermin nightly-Copr | Asennukset simuloitu; oikea Fedora-ajo tekemättä |
| WSL | Linux-CLI ja käyttäjäkohtaiset polut; työpöytäskriptit hylkäävät WSL:n | Windows-launcherin hylkäys simuloitu; oikea WSL-ajo tekemättä |
| x86_64 / arm64 | Neovim ja LazyGit käyttävät x86_64/arm64-nimiä, Yazi x86_64/aarch64-nimiä | Latausosoitteet simuloitu; ARM-binäärien ajo tekemättä |

Muut arkkitehtuurit hylätään. Chrome on työpöytäskriptissä vain x86_64:lle.
Rustup ja .NETin asentimet tunnistavat arkkitehtuurin itse.
Node/npm tulevat jakelupaketeista: uuden koneen versio voi erota nykyisestä koneesta.
APT:n GitHub CLI -lähteen ylläpito jää koneen pakettilähteiden vastuulle.
WezTermin jakelukohtaiset lähteet vastaavat sen virallista Linux-asennusohjetta:
<https://wezterm.org/install/linux.html>.

## Nykyinen Mint-kone: vain lukevat tarkistukset

- Mint 22.2, x86_64, Wayland; Neovim 0.12.6 `/opt/nvim-linux-x86_64/bin/nvim`.
- Codex CLI 0.162.1; `~/.local/bin/codex` osoittaa standalone-pakettiin.
  Asennus ei puutu. Kirjautumistietoja ei luettu eikä kirjautumista testattu.
- LazyGit 0.56.0 ja Starship 1.24.0 ovat `/usr/local/bin`:ssä.
- .NET SDK 10.0.101 on `~/.dotnet`:ssä; Node 24.21.0, npm 11.19.0.
- Rustup/Cargo, Tree-sitter CLI, Yazi/ya, WezTerm ja wl-copy eivät löytyneet
  PATHilta; myöskään tarkistetut `~/.cargo/bin`- ja `~/.local/bin`-asennukset eivät löytyneet.
- `jq` ja `fd` puuttuvat PATHilta; `fdfind` löytyy. Bootstrap asentaa jq:n
  ja luo fd-linkin, jos erillistä fd:tä ei löydy.
- WezTermin asetusten linkki ja sen fonttihakemisto eivät löytyneet.
  `fc-match 'JetBrainsMono Nerd Font'` palauttaa Noto Sansin.
- Spotify löytyy natiivina `/usr/bin/spotify`. Skripti ohittaa tällöin
  Spotify-Flatpakin, jotta uutta rinnakkaista asennusta ei synny.

GNOME/Wayland/NVIDIA-ajossa WezTermin ikkuna, fontti, leikepöytä ja WebGPU
pitää vielä tarkistaa oikeassa istunnossa. Ensimmäisen GPU:n pakotus poistettiin;
HighPerformance-valinta jätettiin WezTermille. Windowsin PowerShell-käynnistimet
näytetään vain Windowsissa. NVIDIA-ajureihin ei tehty muutoksia.

## Neovim ja lazy.nvim

Sekä `nvim` että `nvim-v2` käyttävät `vim.pack`ia ja omia lukitustiedostojaan.
Lazy.nvim-bootstrapia tai sen runtimepath-lisäystä ei löytynyt.
Tarkistetuista nykyisistä datahakemistoista ei löytynyt `lazy.nvim`-pakettia,
vanhaa `lazy`-hakemistoa tai automaattisesti ladattavaa `pack/*/start`-hakemistoa.
`lazydev.nvim` ja lisäosien lazy-nimiset sisäiset tiedostot eivät ole lazy.nvim-asennus.
Vanha `~/.config/nvim.backup` on aktiivisen linkin ulkopuolella.
Mitään data-, state-, cache- tai varmuuskopiohakemistoja ei poistettu.

Käytä `NVIM_APPNAME=nvim-v2 nvim` kokeilukonfiguraatioon: se erottaa myös
data-, state- ja cache-polut. Bootstrapin `--update` päivittää editorin binäärin,
ei lisäosia. Pääkonfiguraation `:PackUpdateFromOnline` päivittää lisäosat;
lukitustiedoston muutokset tarkistetaan Gitissä. Täyttä konfiguraation
käynnistystä tai lisäosien latausta ei tehty tässä tarkistuksessa.

## Testit

`bash scripts/test-bootstrap.sh` käyttää väliaikaista HOMEa ja simuloituja
asennuskomentoja. Se tarkistaa profiilit, ristiriitaiset valitsimet,
asetusten varmuuskopioinnin ja toistuvan linkityksen, Neovimin olemassa olevan
puun vaihdon, kopiointivirheen palautuksen ja virheellisen binäärin hylkäyksen.
Se ajaa normaalin ja päivitysbootstrapin simuloidusti, tarkistaa x86_64/arm64-
lataukset, APT/DNF-haarat, vanhan Neovimin korvauksen, puuttuvan ya:n,
home/work-Codex-käyttäytymisen ja Windows-launcherin hylkäyksen.
Bash-syntaksi, Bashin PATHin toistuva lataus väliaikaisella HOMElla ja
Neovim/WezTerm-Lua-tiedostojen syntaksi tarkistettiin erikseen.
Codexin standalone-asennustapa tarkistettiin myös [virallisesta OpenAI-ohjeesta](https://learn.chatgpt.com/docs/codex/cli).
Nämä eivät todista pakettilähteiden,
latausten tai binäärien toimivuutta toisella koneella; jatkotarkistukset ovat BACKLOGissa.
