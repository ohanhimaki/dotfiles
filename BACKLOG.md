# Myöhemmin tarkistettavat asiat

## Linux Mint -koneella

`fd`/`fdfind`-yhteensopivuus on toteutettu, mutta oikean Mint-koneen tarkistus on vielä tekemättä.

- [ ] Aja haluamasi profiilin bootstrap ja avaa uusi Bash-istunto.
- [ ] Tarkista `command -v fdfind`, `command -v fd` ja `fd --version`. Jos erillistä `fd`:tä ei ollut, `readlink ~/.local/bin/fd` osoittaa paketista löytyvään `fdfind`:iin.
- [ ] Tarkista `echo "$FZF_DEFAULT_COMMAND"` sekä Ctrl+T, Alt+C ja `fcd` testihakemistossa: tiedosto- ja hakemistohaku toimivat.
- [ ] Tarkista myös `--symlinks-only`-asetukset koneella, jolla on vain `fdfind`: fzf käyttää sitä ilman `fd`-linkkiä.
- [ ] Tarkista Neovimin tiedostohaku ja tree-sitterin toiminta.
- [ ] Tarkista WezTermin asennus, fontti, Spotify sekä kehitys-SDK:t Mintin työpöytäskriptin jälkeen.
- [ ] Tarkista profiilit: `-home` asentaa puuttuvan Codexin, `-work` ohittaa asennuksen. Jo asennettua Codexia ei poisteta.

Kirjaa tähän Mintin versio, käytetty profiili ja tarkistusten tulokset ennen kohtien kuittaamista.

## Bootstrapin päivitystila (10.10.2026)

Mint 22.2:n nykytila luettiin ilman asennuksia. Neovim 0.12.6 ja Codex 0.162.1
löytyvät; WezTerm, sen Nerd Font, Rustup/Cargo, Tree-sitter CLI, Yazi/ya,
wl-clipboard ja jq puuttuvat tarkistetusta ympäristöstä. Spotify löytyy natiivina.
Tarkempi arvio: [linux/BOOTSTRAP-REVIEW.md](linux/BOOTSTRAP-REVIEW.md).

- [x] Simuloitu testi väliaikaisella HOMElla: normaalit ja `--update`-ajot,
  APT/DNF-haarat, x86_64/arm64-latausnimet, home/work-Codex, vanhan Neovimin
  korvaus ja Neovimin puun vaihto sekä palautus kopiointivirheestä.
- [ ] Käyttäjän hyväksymän Mint-asennusajon jälkeen tarkista WezTermin
  käynnistys GNOME Waylandissa / RTX 4060:llä, WebGPU, Nerd Font ja leikepöytä.
- [ ] Tarkista Mintillä `type -a nvim lazygit starship yazi ya codex`,
  versiot ja PATH uudessa Bash-istunnossa; vanhat järjestelmäkopiot säilyvät.
- [ ] Tarkista Mintillä `--update` kahdesti: Neovim käynnistyy, `/opt`-varmuuskopiot
  säilyvät ja .NET 10, Rust ja Tree-sitter toimivat.
- [ ] Käynnistä pääkonfiguraatio ja `NVIM_APPNAME=nvim-v2 nvim`; tarkista
  `:checkhealth`, Tree-sitter, Mason/LSP ja `vim.pack`in lukitustiedostot.
- [ ] Tarkista Fedora-koneella paketit sekä WezTermin nightly-Copr ja päivitys.
- [ ] Tarkista WSL:ssä Linux-työkalujen etusija Windowsin PATHiin nähden,
  SDK:t ja Codex; WezTerm toimii Windowsin puolella.
- [ ] Tarkista oikealla arm64-koneella Neovim, LazyGit, Yazi, Rust ja .NET 10.

## Mintin NodeSource-yhteensopivuus (11.10.2026)

Käyttäjän oikea Mint 22.2 -ajo `-home --update` pysähtyi APT-vaiheessa:
NodeSourcen `nodejs` oli ristiriidassa erikseen pyydetyn `npm`-paketin kanssa.
Bootstrap asentaa nyt APT-haarassa ensin Node.js:n ja pyytää npm-paketin
vain, jos toimivaa Linux-npm:ää ei tämän jälkeen löydy.

- [x] Simuloitu NodeSource-ristiriita: toimiva npm ohittaa erillisen paketin.
- [x] Simuloitu jakelun Node-asennus ilman toimivaa npm:ää: erillinen npm asennetaan.
- [ ] Uusi oikea Mint-ajo `bash linux/go-mint.sh -home --update` ja Node/npm-versioiden tarkistus.

## Mintin työpöytäpaketit (11.10.2026)

Oikea `-home --update` -ajo pääsi yhteisen bootstrapin loppuun, mutta pysähtyi
työpöytäpakettiin `dconf`, jolla ei ole Mintissä asennusehdokasta.
Mint-skriptin pakettinimi korjattiin `dconf-cli`:ksi; Fedora käyttää edelleen `dconf`:ia.

Paikallisista APT-tiedoista todennettu: `dconf-cli` 0.40.0-4ubuntu0.1 on
jo asennettu ja sillä on asennusehdokas. Työpöytäasennusta ei ajettu tässä tarkistuksessa.

- [ ] Tarkista uusintajossa työpöytäpakettien ja WezTermin asennuksen valmistuminen.

## Yhteiset AI-ohjeet (12.10.2026)

- [x] Simuloitu Linux/WSL-linkitys väliaikaisella HOMElla: kolme ohjetiedostoa, home/work-profiilit, varmuuskopiot, uusinta-ajot ja muiden asetusten säilyminen. Bootstrapin offline-testit ja Bash-syntaksitarkistus läpäisty.
- [ ] Tarkista Windowsissa `makesymlinks.ps1`: kaikkien kolmen AI-ohjetiedoston linkit ja olemassa olevien tiedostojen varmuuskopiot. PowerShell ei ole käytettävissä ylläpitokoneella.
- [ ] Tarkista Codexissa, Copilot CLI:ssä ja Claude Codessa ohjeiden lataus uudessa keskustelussa sekä caveman-tyylin säilyminen resume- ja compaction-tilanteissa. Tarkista myös käyttäjän valitseman `normal mode` -tyylin säilyminen.

## Sovellustarpeet

- [ ] Arvioi DBeaver vasta, kun konkreettinen tietokantatyö sitä edellyttää. Selvitä silloin käyttötarve ja sopiva asennustapa.
- [ ] Arvioi GIMP vasta, kun kuvankäsittelytehtävä sitä edellyttää. Tarkista silloin myös vanhojen `linux/gimp`-asetusten soveltuvuus.

Nämä sovellukset eivät kuulu nykyiseen oletusasennukseen.
