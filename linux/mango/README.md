# MangoWM Fedoralla

Erillinen, valinnainen asennus GNOMEn rinnalle. Ei muuta yhteistä bootstrapia.
Profiili vaaditaan repositorion käytännön vuoksi; tämän lisäosan paketit ovat samat
molemmille profiileille. SDK:t ja muut yhteiset työkalut kuuluvat bootstrapille.

```bash
bash linux/mango/setup-fedora.sh -home
```

Asentaa MangoWM:n upstreamin suosittelemasta kolmannen osapuolen
[Terra-varastosta](https://mangowm.github.io/docs/installation/#fedora).
Terra-release-paketin ensiasennus käyttää upstreamin `--nogpgcheck`-komentoa.
Asetukset linkitetään tästä hakemistosta; korvattavat tiedostot varmuuskopioidaan.
Pelkkä asetusten linkitys: lisää `--symlinks-only`.

Kirjaudu ulos, valitse käyttäjä ja kirjautumisruudun rattaasta Mango-istunto.
GNOMEen voi palata samalla tavalla. Älä käynnistä Mangoa nykyisen istunnon
korvaamiseksi terminaalista.

| Pikanäppäin | Toiminto |
| --- | --- |
| Super+Enter | Kohdista olemassa oleva WezTerm tai avaa uusi |
| Super+Shift+Enter | Avaa aina uusi WezTerm-ikkuna |
| Super+D | Sovellukset |
| Super+Q | Sulje ikkuna |
| Super+nuolet | Vaihda aktiivista ikkunaa |
| Super+J / K | Seuraava / edellinen ikkuna (AwesomeWM/GlazeWM-tyyli) |
| Super+Ctrl+J / K | Kohdistus vasemmalle / oikealle (GlazeWM-tyyli) |
| Super+Shift+J / K | Vaihda paikkaa seuraavan / edellisen ikkunan kanssa |
| Super+Shift+nuolet | Vaihda ikkunoiden paikkoja |
| Super+1–9 | Vaihda tagia |
| Super+Shift+1–9 | Siirrä ikkuna tagiin |
| Super+T / S / M | Tile / scroller / monocle |
| Super+F | Kokoruutu |
| Super+Shift+Space | Kelluva ikkuna |
| Super+Space | Suomi / US näppäimistö |
| Super+L | Lukitse |
| Super+R | Lataa asetukset |
| Super+Shift+E | Poistu istunnosta |

Lukitus käynnistyy myös 10 minuutin joutoajan jälkeen ja ennen lepotilaa.
Caps Lock toimii Esc-näppäimenä sekä suomi- että US-asettelussa.
Waybar käyttää omaa asetustiedostoa; muiden työpöytien paneeliasetukset säilyvät.
Portaaliasetus koskee vain Mangoa. Näyttöjen resoluutio ja skaalaus käyttävät
automaattisia oletuksia; säädä tarvittaessa ensimmäisen kirjautumisen jälkeen.
