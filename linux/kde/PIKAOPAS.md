# KDE Plasma Pikaopas (Finnish Quick Guide)

## 🚀 Pika-asennus

Suorita tämä komento dotfiles-hakemistossa:

```bash
cd ~/dotfiles/linux/kde
./quick-setup.sh
```

Skripti kysyy vaiheittain mitä haluat asentaa ja konfiguroida.

**Kun kaikki on valmis: Kirjaudu ulos ja takaisin sisään!**

## 📋 Mitä skripti tekee?

✅ **Automaattisesti:**
- Luo 4 virtuaalityöpöytää
- Asettaa näppäimistön toiston (200ms, 35 merkkiä/s)
- Muuttaa CapsLockin Escapeksi
- Asettaa Kittyn oletusnäöitteeksi
- Konfiguroi peruspikanäppäimet
- Asentaa autostart-asetukset
- Asettaa hiiren herkkyyden (-0.3)

📝 **Manuaalisesti (skripti näyttää ohjeet):**
- OneDark-teeman asennus
- Panelin kustomointi
- Fonttien asetus
- Valinnainen: Bismuth-tiling asennus (jos haluat tiling-ominaisuuden)
- Valinnainen: Rofi-pikanäppäinten lisäys (KDE:ssä on KRunner, joka on parempi)

## 🎨 Manuaaliset vaiheet (skriptin jälkeen)

### 1. OneDark-teema

```bash
System Settings → Appearance → Colors → Get New Color Schemes...
Etsi: "OneDark" tai "Atom One Dark"
```

### 2. Fontit

```bash
System Settings → Appearance → Fonts
Aseta kaikki: FiraCode Nerd Font (10pt)
```

### 3. Paneeli

```bash
Oikealla hiiren painikkeella paneelia → Enter Edit Mode
- Siirrä ylös
- Säädä korkeus ~24-28px
- Lisää widgettejä: Task Manager, System Tray, Clock
```

### 4. Bismuth Tiling (valinnainen)

**Huom:** Tätä ei tarvita, jos olet tyytyväinen KDE:n oletusikkunanhallintaan!

```bash
cd ~/dotfiles/linux/kde
./install-bismuth.sh
```

Tai manuaalisesti:
```bash
sudo apt install kwin-bismuth
System Settings → Window Management → KWin Scripts → Bismuth (ruksaa päälle)
```

### 5. KRunner (suositeltu) tai Rofi

**KDE:ssä on KRunner, joka on parempi kuin Rofi!**

Käytä **KRunner** painamalla `Alt + Space` tai `Alt + F2`:
- Käynnistä sovelluksia
- Laske laskuja
- Muunna yksiköitä
- Hae tiedostoja
- Paljon muuta!

**Jos haluat silti käyttää Rofita:**

```bash
System Settings → Shortcuts → Custom Shortcuts → Edit → New → Command/URL

Lisää:
- Name: Rofi Application Launcher
  Trigger: Super+P
  Command: rofi -show drun -config ~/dotfiles/linux/rofi/config.rasi

- Name: Rofi Window Switcher
  Trigger: Super+Z
  Command: rofi -show window -config ~/dotfiles/linux/rofi/config.rasi
```

## ⌨️ Tärkeimmät pikanäppäimet

| Näppäin | Toiminto |
|---------|----------|
| `Super + Return` | Avaa Kitty-terminaali |
| `Super + Q` | Sulje ikkuna |
| `Super + M` | Maksimoi ikkuna |
| `Super + F` | Koko näyttö |
| `Super + 1/2/3/4` | Vaihda työpöytään 1/2/3/4 |
| `Super + A` tai `Left` | Edellinen työpöytä |
| `Super + D` tai `Right` | Seuraava työpöytä |
| `Super + Shift + 1/2/3/4` | Siirrä ikkuna työpöydälle |
| `Alt + Tab` | Vaihda ikkunaa |
| `Super + P` | Rofi-käynnistin (kun konfiguroitu) |
| `Super + Z` | Rofi-ikkunavaihdin (kun konfiguroitu) |

## 💾 Varmuuskopiointi

### Varmuuskopioi asetukset

Kun olet konfiguroinut KDE:n mieleiseksesi:

```bash
cd ~/dotfiles/linux/kde
./backup_kde.sh

# Commitoi gitiin
cd ~/dotfiles
git add linux/kde/configs/
git commit -m "Update KDE configuration"
git push
```

### Palauta asetukset

Uudella koneella tai uudelleenasennuksen jälkeen:

```bash
cd ~/dotfiles/linux/kde
./quick-setup.sh  # Perusasetukset
./restore_kde.sh  # Palauta varmuuskopioidut asetukset
# Kirjaudu ulos ja takaisin sisään
```

## 🔧 Ongelmanratkaisu

### Muutokset eivät tule voimaan?

```bash
# Käynnistä KWin uudelleen
kwin_x11 --replace &

# TAI kirjaudu ulos ja sisään (varmempi)
```

### Autostart ei toimi?

```bash
# Testaa manuaalisesti
bash ~/dotfiles/linux/kde/autostart-settings.sh

# Tarkista että on olemassa
ls -la ~/.config/autostart/autostart-settings.desktop
```

### Bismuth ei toimi?

```bash
# Tarkista asennus
dpkg -l | grep bismuth

# Ota käyttöön
System Settings → Window Management → KWin Scripts → Bismuth (ruksaa)
```

## 📚 Lisätiedot

- **README.md** - Täydellinen englanninkielinen opas
- **migration-plan.md** - Yksityiskohtainen migraatio-ohje
- **SCRIPTS.md** - Kaikkien skriptien kuvaukset

## 🎮 Pelaaminen (RTX 4060)

KDE:n compositor sammuu automaattisesti, kun käynnistät pelin koko näytön tilassa. Ei tarvitse erillisiä asetuksia!

NVIDIA-ajurit pitää olla asennettuna:
```bash
nvidia-smi  # Tarkista
```

## ✅ Tarkistuslista

- [ ] Ajoin `./quick-setup.sh`
- [ ] Kirjauduin ulos ja sisään
- [ ] Asensin OneDark-teeman
- [ ] Asetin fontit (FiraCode)
- [ ] Konfiguroidun panelin
- [ ] Asensin Bismuthin
- [ ] Lisäsin Rofi-pikanäppäimet
- [ ] Tein varmuuskopion (`./backup_kde.sh`)
- [ ] Commitoin asetukset gitiin

---

**Onnea KDE:n käyttöön! 🎉**

Kysyttävää? Katso README.md tai migration-plan.md.

