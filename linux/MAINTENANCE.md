# Linux-koneen kevyt huolto

Tee päivitykset sopivassa välissä, esimerkiksi parin viikon välein. Lue
päivitystyökalun ehdottamat muutokset ennen hyväksymistä.

## Mint / Ubuntu

Mintissä Päivitysten hallinta on helppo oletus: se näyttää myös
uudelleenkäynnistyksen tarpeen. Tavalliset pakettipäivitykset terminaalissa:

```bash
sudo apt update
apt list --upgradable
sudo apt upgrade
```

`update` hakee pakettilistat, `upgrade` asentaa päivitykset. Jos paketteja jää
päivittämättä, selvitä syy Päivitysten hallinnasta ennen jatkamista.
Mintin versiopäivitys tehdään erikseen sen omien ohjeiden mukaan.

## Fedora

```bash
sudo dnf upgrade --refresh
```

Tämä päivittää nykyisen Fedora-version paketit. Jakelun versiopäivitys on
erillinen toimenpide.

## Flatpak-sovellukset molemmissa

```bash
flatpak update
```

Päivittää Flatpak-sovellukset ja niiden ajoalustat. APT/DNF ei päivitä niitä.

## Tämän repon erikseen asentamat työkalut

Aja tarvittaessa repon juuressa ja valitse koneesi profiili: `-home` tai `-work`.

```bash
bash bootstrap.sh -home --update
```

Päivittää Neovimin, LazyGitin, Starshipin, Yazin, Rustin, tree-sitter CLI:n
ja .NET 10 SDK:n. Home-profiilissa päivitetään myös erikseen asennettu Codex;
npm- tai järjestelmäpakettina asennetun Codexin kohdalla skripti neuvoo käyttämään
sen omaa asennustapaa. Skripti myös asentaa puuttuvia työkaluja ja linkittää
asetukset uudelleen varmuuskopioiden olemassa olevat tavalliset asetustiedostot.
Se ei tee koko järjestelmän tai Flatpakin päivitystä.

Työpöytäskripti sisältää saman bootstrapin ja päivittää lisäksi paketoidun
WezTermin. Käytä sitä edellisen komennon sijaan, kun haluat mukaan myös
työpöytäasennuksen tarkistuksen:

```bash
# Valitse oman jakelusi komento ja oikea profiili
bash linux/go-mint.sh -home --update
# tai
bash linux/go-fedora.sh -home --update
```

Työpöytäskripti voi asentaa myös puuttuvia oletussovelluksia ja fontteja.
Älä lisää `--desktop`-valintaa rutiinipäivitykseen: se palauttaa tallennetut
työpöytäasetukset. Lisätiedot: [asennusohje](README.md).

Neovimin lisäosat päivitetään editorissa komennolla `:PackUpdateFromOnline`.

## Mint-koneen poikkeus: MangoHud

Käsin asennettu MangoHud 0.8.4 sijaitsee hakemistossa
`~/.local/share/MangoHud/0.8.4`, ja käynnistin on `~/.local/bin/mangohud`.
Se ei päivity APT:llä eikä bootstrapilla. Toimivaa asennusta ei tarvitse
päivittää joka huoltokerralla; uuden version asennustapa arvioidaan erikseen.
Flatpakin MangoHud-laajennus päivittyy `flatpak update` -komennolla.

## Päivitysten jälkeen

Avaa uusi terminaali ja kokeile normaalisti käyttämiäsi sovelluksia.
Käynnistä kone uudelleen, jos päivitystyökalu pyytää sitä, etenkin ytimen tai
näytönohjainajurin päivityksen jälkeen.

Kirjaa ongelmat ja tekemättömät konekohtaiset tarkistukset
[BACKLOG.md:hen](../BACKLOG.md). Tämä tiedosto on huoltomuistio;
komentojen listaaminen ei tarkoita, että päivitykset olisi ajettu koneilla.
