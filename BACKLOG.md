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

## MangoHudin mittaukset Mintissä (15.10.2026)

Oikean Mint-koneen glxgears-testissä jakelun MangoHud 0.6.9.1 lataa
repositorion konffin. CPU-kuormitus, lämpötila ja kellotaajuus näkyvät,
mutta NVIDIA RTX 4060:n mittarit ovat nollassa. Paketin README.Debian
vahvistaa NVML-tuen puuttumisen; XNVCtrl-alustus epäonnistuu Wayland-istunnossa.

Virallista MangoHud 0.8.4 -julkaisua kokeiltiin /tmp-hakemistosta ilman
asennusta: GPU-kuormitus, lämpötila, kellotaajuudet ja VRAM näkyvät.
CPU- ja GPU-teho jäivät nollaan; CPU-tehon alustus raportoi virheen.

- [x] Oikean koneen glxgears-testit: CSV-lokit ja kummankin version testi-ikkunasta otetut kuvat.
- [x] Asennettu virallinen MangoHud 0.8.4 käyttäjäkohtaisesti: `~/.local/share/MangoHud/0.8.4`, käynnistin `~/.local/bin/mangohud` ja käyttäjän Vulkan-layerit. Järjestelmäpaketti ja konffi säilytettiin. Asennus testattiin ensin väliaikaisella kotihakemistolla (varmuuskopiot, kirjastopolut ja shell-syntaksi).
- [x] Asennettu komento raportoi v0.8.4; oikean koneen glxgears/CSV-testi vahvistaa CPU- ja GPU-mittaukset tehoa lukuun ottamatta. Vulkan-instanssin lataustesti vahvistaa käyttäjäkohtaisen 0.8.4-kirjaston valinnan vanhan järjestelmäkirjaston sijaan; pelitesti on erikseen tekemättä.
- [ ] Arvioi käyttäjäkohtaisen natiiviasennuksen päivitystapa. Tämä virallinen julkaisu asennettiin käsin eikä päivity APT:n kautta; bootstrapin gaming-haara käyttää edelleen Flatpak-laajennusta.
- [ ] Varmista Dota 2:ssa CPU- ja GPU-mittarit käyttäjän käynnistysasetuksilla.
  - 16.10.2026 oikean koneen käynnissä olevasta Dotasta luettu `/proc/<pid>/maps`: 0.8.4:n `libMangoHud_shim.so` latautuu, mutta varsinainen Vulkanin `libMangoHud.so` tulee vanhasta järjestelmäpaketista (`/run/host/usr/lib/x86_64-linux-gnu/mangohud/`). Steam pressure-vesselin layer-luettelossa on sekä käyttäjän uusi että järjestelmän vanha 64-bittinen MangoHud samalla layer-nimellä. Käynnistysasetus on `mangohud gamemoderun %command% -novid -prewarm -map dota -processheap -sdlaudiodriver pulse`. Korjaa Vulkan-layerin valinta ja varmista lämpötila pelin uudelleenkäynnistyksen jälkeen; käynnissä olevaan peliin ei tehty muutoksia.
- [ ] Selvitä tarvittaessa erikseen CPU- ja GPU-tehon puuttuvat mittaukset.

## MangoWM-kokeilu Mintissä (15.10.2026)

Vain luku -tarkistus: Mint 22.2 / Ubuntu noble, nykyinen istunto GNOME/Wayland.
Paikallisen APT-indeksin kehityspakettien ehdokkaat: wlroots 0.17.1,
Wayland 1.22.0 ja libinput 1.25.0. MangoWM:n tarkistettu main-haara
(0.18.1) vaatii wlroots 0.20, Wayland >= 1.23.1, libinput >= 1.27.1
ja SceneFX >= 0.5.0. Mitään ei asennettu tai käynnistetty.

- [ ] Selvitä ja testaa erilliseen asennuspolkuun rakennettu, versiolukittu riippuvuusketju Mintille; älä korvaa jakelun Wayland-kirjastoja.
- [ ] Kokeile ensin sisäkkäistä Wayland-ajoa; tarkista terminaali, näppäinsidonnat ja poistuminen ennen erillistä kirjautumisistuntoa.
- [ ] Tarkista näytönohjaimen oikea ajuritila ennen natiivia istuntoa: tämän ympäristön `nvidia-smi` ei saanut yhteyttä ajuriin; syytä ei selvitetty.

## Sovellustarpeet

- [ ] Arvioi DBeaver vasta, kun konkreettinen tietokantatyö sitä edellyttää. Selvitä silloin käyttötarve ja sopiva asennustapa.
- [ ] Arvioi GIMP vasta, kun kuvankäsittelytehtävä sitä edellyttää. Tarkista silloin myös vanhojen `linux/gimp`-asetusten soveltuvuus.

Nämä sovellukset eivät kuulu nykyiseen oletusasennukseen.
