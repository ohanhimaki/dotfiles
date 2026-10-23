# Dotfiles-repositorion ylläpito

- Juuren `bootstrap.sh` asentaa yhteiset CLI-työkalut Fedoraan, Mint/Ubuntuun ja WSL:ään.
- `linux/go-fedora.sh` ja `linux/go-mint.sh` täydentävät yhteisen bootstrapin työpöytäsovelluksilla. WSL:ssä työpöytäsovellukset asennetaan Windowsiin.
- Vaadi täsmälleen yksi profiili: `-work` tai `-home`, myös `--symlinks-only`-ajossa.
- Molempiin profiileihin kuuluvat kehitys-SDK:t, Rust/tree-sitter ja työpöytäajossa Spotify. Codex asentuu automaattisesti vain `-home`-profiilissa.
- Kitty, screen, tmux, GIMP ja DBeaver eivät kuulu oletusasennuksiin. Älä lisää niitä takaisin ilman käyttäjän pyyntöä.
- Älä poista koneelta jo asennettuja ohjelmia profiilin vaihtuessa. Varmuuskopioi olemassa olevat asetukset ennen symlinkitystä.
- Pidä kirjautumistiedot ja tokenit Gitin ulkopuolella.
- Tarkista Bash-syntaksi ja muuttuneiden toimintojen käyttäytyminen väliaikaisella kotihakemistolla tai simuloiduilla komennoilla. Älä aja täyttä bootstrapia ylläpitokoneella pelkkää testausta varten.
- Kirjaa toisella koneella tehtävät tarkistukset ja myöhemmin arvioitavat tarpeet [BACKLOG.md](BACKLOG.md)-tiedostoon. Lue se tehtävän liittyessä asennuksiin tai distroeroihin; käsittele vain nykyiseen tehtävään liittyviä kohtia.
- Merkitse tarkistus tehdyksi vasta, kun sen tulos on todennettu. Erota simuloitu testi oikealla koneella tehdystä tarkistuksesta.
- Älä aja `makesymlinks.ps1` itse: se poistaa ensin vanhat symlinkit, ja `New-Item -ItemType SymbolicLink` kaatuu ilman admin-oikeuksia tai Developer Modea, jolloin kaikki symlinkit jäävät poistetuksi eikä niitä luoda uudelleen. Pyydä käyttäjää ajamaan se itse elevated PowerShellistä (tai Developer Mode päällä).
