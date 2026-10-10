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

## Sovellustarpeet

- [ ] Arvioi DBeaver vasta, kun konkreettinen tietokantatyö sitä edellyttää. Selvitä silloin käyttötarve ja sopiva asennustapa.
- [ ] Arvioi GIMP vasta, kun kuvankäsittelytehtävä sitä edellyttää. Tarkista silloin myös vanhojen `linux/gimp`-asetusten soveltuvuus.

Nämä sovellukset eivät kuulu nykyiseen oletusasennukseen.
