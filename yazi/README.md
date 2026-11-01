# Yazin paikalliset teemat

Aktiivinen käyttöliittymäteema on `config/theme.toml`. Teemat eivät tarvitse
`ya pkg` -asennusta. Molemmat vaihtoehdot säilytetään `config/themes/`-kansiossa.

Tokyo Night (night), repositorion juuresta:

```bash
cp yazi/config/themes/tokyo-night.toml yazi/config/theme.toml
```

Paluu alkuperäiseen Gruvboxiin:

```bash
cp yazi/config/themes/gruvbox.toml yazi/config/theme.toml
```

Käynnistä Yazi uudelleen vaihdon jälkeen. PowerShellissä vastaava kopiointi
onnistuu `Copy-Item`-komennolla.

`config/theme.tmTheme` on Tokyo Nightin tiedostoesikatselun syntaksiteema.
Se on erillinen käyttöliittymäteemasta. Gruvboxiin palatessa siirrä tämä tiedosto
pois `config/`-kansiosta, jolloin Yazi käyttää jälleen oletussyntaksiteemaansa.
Palauta tiedosto, kun otat Tokyo Nightin uudelleen käyttöön.

Tokyo Night kopioitiin paketista `BennyOe/tokyo-night`, revisio `8e6296f`
(`https://github.com/BennyOe/tokyo-night.yazi`). Alkuperäiset lisenssit ovat
`config/themes/tokyo-night.LICENSE` ja `config/themes/tokyo-night.LICENSE-tmtheme`.
Paketin README, esikatselukuva ja pakettirekisterin riippuvuudet poistettiin;
paikalliset kopiot eivät päivity `ya pkg` -komennolla.
