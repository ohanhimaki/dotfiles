# Dotfiles

Omat Windowsin, Fedoran, Mint/Ubuntun ja WSL:n asetukset sekä asennusskriptit.

## Dokumentaatio

| Tarve | Ohje |
| --- | --- |
| Työkalujen kuvaukset ja komentomuistio | [Työkalut](docs/tools.md) |
| Linuxin ja WSL:n asennus, profiilit ja valitsimet | [Linux](linux/README.md) |
| Pakettien, SDK:iden ja editorin päivitykset | [Huolto](linux/MAINTENANCE.md) |
| Väriteemojen valinta | [Väriteemat](docs/colorschemes.md) |
| Selvitysskriptit palvelimille | [Toolbox](toolbox/README.md) |
| Koneilla vielä tarkistettavat asiat | [Backlog](BACKLOG.md) |

Tähän repoon kuuluvat dotfiles-asetukset, työkalujen kuvaukset, lyhyet
cheatsheetit ja apuskriptit (`toolbox/`). Laajemmat esimerkit, oppaat ja projektikohtaiset työnkulut kuuluvat
[ohanhimaki/ohanhimaki](https://github.com/ohanhimaki/ohanhimaki)-repoon.
Linkitä sisältö repoista toiseen sen sijaan, että ylläpitäisit samoja ohjeita kahdesti.
Työkalukohtaiset ohjeet ovat asetusten vieressä; `docs/tools.md` toimii hakemistona.

## Käyttöönotto

Asenna ensin Git oman käyttöjärjestelmäsi paketinhallinnalla. Kloonaa repo:

```bash
git clone https://github.com/ohanhimaki/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Linux ja WSL

Valitse täsmälleen yksi profiili: `-work` tai `-home`, myös pelkkään linkitykseen.
Profiili valitsee Linuxin Git-asetukset. Molemmat asentavat kehitys-SDK:t;
Codex asentuu automaattisesti vain home-profiilissa. Profiilin vaihto ei poista ohjelmia.

```bash
# Yhteiset CLI-työkalut ja asetukset, myös WSL:ssä
bash bootstrap.sh -home

# Tai koko natiivi työpöytä: valitse oman jakelusi komento
bash linux/go-fedora.sh -home
bash linux/go-mint.sh -home

# Pelkät yhteiset asetukset ilman asennuksia
bash bootstrap.sh -work --symlinks-only
```

Aja tavallisena käyttäjänä; paketit asennetaan tarvittaessa sudolla.
Olemassa olevat tavalliset asetustiedostot ja hakemistot varmuuskopioidaan ennen
linkitystä. Symlinkit korvataan. WSL:n työpöytäsovellukset asennetaan Windowsiin.
Lisävalinnat ja asennusten sisältö: [Linux-ohje](linux/README.md).

### Windows

Skriptit olettavat repon sijaitsevan hakemistossa `$HOME\dotfiles`.
`install.ps1` asentaa puuttuvat Winget-listansa sovellukset; tarkista lista ennen ajoa.
Windows-skriptit eivät käytä work/home-profiileja.

```powershell
.\install.ps1
```

**Aja linkitys itse järjestelmänvalvojan PowerShellissä tai Developer Mode päällä.**
Skripti poistaa vanhan symlinkin ennen uuden luontia. Ilman tarvittavia oikeuksia
uuden linkin luonti voi epäonnistua ja asetuksen linkki jäädä puuttumaan.

```powershell
.\makesymlinks.ps1
```

Tavalliset olemassa olevat asetukset nimetään varmuuskopioiksi. Skripti luo myös
`~/projects`-junctionin kohteeseen `C:\projects`. Tarkista Gitin käyttäjätiedot
ja konekohtaiset polut ennen käyttöönottoa. Windows-asennuksen testaamattomat
kohdat ovat [backlogissa](BACKLOG.md).

## Omat muutokset

Muokkaa asetuksia niiden omissa hakemistoissa. Linkitetyn asetuksen muutos
sovelluksessa näkyy myös tässä repossa. `nvim/` on pääkonfiguraatio;
[nvim-v2/](nvim-v2/README.md) on erillinen kokeilu.

Yhteiset AI-ohjeet ovat [ai-hommat/shared-instructions.md](ai-hommat/shared-instructions.md).
Linkitysskriptit käyttävät samaa tiedostoa Codexin `~/.codex/AGENTS.md`-,
Copilot CLI:n `~/.copilot/copilot-instructions.md`- ja Claude Coden
`~/.claude/CLAUDE.md`-poluissa. Tarkista varmuuskopioista säilytettävät omat ohjeet.
Ohjeiden lataus eri työkaluissa on erillinen [tarkistuskohde](BACKLOG.md).

Kirjautumiset tehdään konekohtaisesti. Pidä tokenit, salasanat ja muut
kirjautumistiedot Gitin ulkopuolella.

Ylläpitokäytännöt: [AGENTS.md](AGENTS.md). Bootstrapin simuloidut tarkistukset:
`bash scripts/test-bootstrap.sh`; älä aja täyttä asennusta pelkkää testausta varten.
