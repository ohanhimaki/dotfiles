# VS Coden asetukset ja laajennukset

Tässä hakemistossa ylläpidetään VS Coden yhteisiä asetuksia:

- `settings.json`: editorin ja laajennusten asetukset.
- `keybindings.json`: omat näppäinsidonnat.
- `github-markdown.css`: Markdown PDF -laajennuksen tyylitiedosto.

Linuxin työpöytäskriptit linkittävät asetukset ja näppäinsidonnat
`~/.config/Code/User/`-hakemistoon. VS Codessa näihin tiedostoihin tehdyt
muutokset näkyvät siis suoraan dotfiles-repossa. Nimetyt VS Code -profiilit
voivat käyttää omia asetuksiaan.

## Laajennuslista dotfilesiin

Pidä asetusten rinnalla `vscode/extensions.txt`, jossa on yksi laajennuksen
tunniste rivillä. Listaa ei vielä ole tässä repossa, eikä bootstrap tällä
hetkellä asenna VS Coden laajennuksia.

Kokoa ensin haluamasi laajennukset VS Codessa. Aja sitten repon juuressa
Bashissa:

```bash
code --list-extensions | sort > vscode/extensions.txt
git diff -- vscode/extensions.txt
git status --short -- vscode/extensions.txt
```

Komento korvaa aiemman listan tämän koneen laajennuksilla. Tarkista tiedosto
ennen tallentamista Gitiin: etenkin uudella koneella lista voi olla vajaa.
Uusi, vielä seuraamaton tiedosto ei näy tavallisessa `git diff` -tulosteessa.

Asenna tallennetun listan laajennukset toisella koneella repon juuresta:

```bash
while IFS= read -r extension || [[ -n "$extension" ]]; do
    [[ -z "$extension" ]] && continue
    code --install-extension "$extension" || break
done < vscode/extensions.txt
```

Asennus vaatii `code`-komennon ja verkkoyhteyden. Lista sisältää tunnisteet,
ei lukittuja versioita. Komento ei poista koneella olevia ylimääräisiä
laajennuksia. Uusien laajennusten asentaminen tai poistaminen editorissa ei
päivitä listaa automaattisesti: vie lista uudelleen ja tarkista muutos.

## Nimetyt profiilit

VS Coden profiili voi sisältää omat asetukset, näppäinsidonnat, snippetit ja
laajennukset. Profiileista on hyötyä esimerkiksi C#-, frontend- ja
kirjoitustyön erottamiseen. VS Code muistaa valitun profiilin projektin
kansioon tai työtilaan liitettynä.

Avaa profiilien hallinta valikosta **File > Preferences > Profiles**.
Nykyinen tavallinen kokoonpano on **Default Profile**.

Voit hallita nimetyn profiilin laajennuksia myös Bashista:

```bash
code --list-extensions --profile "CSharp" | sort > vscode/extensions-csharp.txt
code --install-extension vscodevim.vim --profile "CSharp"
code --profile "CSharp" .
```

Käytä haluamaasi profiilinimeä. Jos käynnistyksessä annettua profiilia ei
ole, VS Code luo uuden tyhjän profiilin.

### Koko profiilin vienti tiedostoon

1. Avaa profiilien hallinta ja valitse haluamasi profiili.
2. Valitse profiilin valikosta **Export…** ja tarkista vietävä sisältö.
3. Tallenna paikalliseksi tiedostoksi esimerkiksi
   `vscode/profiles/csharp.code-profile` (luo hakemisto tarvittaessa).
4. Tarkista sisältö ennen Gitiin lisäämistä. Jätä tunnukset, tokenit ja
   konekohtaiset tai yksityiset asetukset pois.
5. Tuo tiedosto toisella koneella profiilien hallinnan **Import Profile…**
   -toiminnolla.

`.code-profile` on vientihetken tilannekuva. Editorissa myöhemmin tehdyt
muutokset eivät päivity vientitiedostoon automaattisesti; vie profiili
uudelleen, kun haluat päivittää repossa olevan kopion.

## Settings Sync vaihtoehtona

VS Coden sisäänrakennettu **Settings Sync** synkronoi esimerkiksi asetukset,
näppäinsidonnat, laajennukset ja profiilit GitHub- tai Microsoft-tilin kautta.
Se sopii automaattiseen synkronointiin koneiden välillä. Tarkista
synkronoinnin asetuksista, mitä sisältöä haluat jakaa.

Tämän repon lähtökohta on pitää yhteiset asetukset ja laajennuslista Gitissä.
Jos käytät myös Settings Synciä, huomioi, että synkronoinnin muuttamat
linkitetyt asetustiedostot muuttavat samalla repon tiedostoja.

Settings Sync ei synkronoi laajennuksia SSH-, WSL- tai devcontainer-etäympäristöön
tai sieltä takaisin. Niiden laajennukset hallitaan erikseen.

## Lisätietoa

- [VS Coden komentorivi](https://code.visualstudio.com/docs/configure/command-line)
- [Profiilit, vienti ja tuonti](https://code.visualstudio.com/docs/configure/profiles)
- [Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)
