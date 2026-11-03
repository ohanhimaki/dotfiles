# KDE Plasma: vanhat asetukset

Tämä hakemisto sisältää aiemman KDE-kokeilun skriptit. Se ei ole nykyisen
Fedora/Mint-asennuksen valmis käyttöönotto-ohje. Yhteinen työpöytäskripti
kutsuu `--desktop=kde`-valinnalla vanhaa `quick-setup.sh`:ta.

## Tunnetut rajoitteet

- `quick-setup.sh` kutsuu puuttuvaa `configure-shortcuts.sh`:ta ja viittaa puuttuvaan `install-bismuth.sh`:hon.
- `setup-kde.sh` käyttää `kwriteconfig5`:ttä ja asettaa Kittyn oletusterminaaliksi. Tämä ei vastaa nykyistä WezTerm-asennusta.
- Varmuuskopiointi ja palautus olettavat repon poluksi `~/dotfiles`.
- `restore_kde.sh` kopioi kaikki `configs/`-hakemiston tavalliset tiedostot, myös README:n, käyttäjän `~/.config/`-hakemistoon.

Älä käytä pika-asennusta nykyisen koneen käyttöönottoon ennen näiden korjaamista.
Korjaustarve ja oikean Plasma-version tarkistus ovat [BACKLOGissa](../../BACKLOG.md).

## Tiedostot

| Tiedosto | Tarkoitus |
| --- | --- |
| `setup-kde.sh` | Vanhojen työpöytä- ja näppäimistöasetusten kirjoitus |
| `quick-setup.sh` | Keskeneräinen interaktiivinen kutsuketju |
| `autostart-settings.sh`, `autostart-settings.desktop` | Istunnon näppäimistö- ja hiiriasetukset |
| `install-onedark-theme.sh` | Vanhan OneDark-teeman ohjeistus |
| `backup_kde.sh` | Kopioi nimetyt asetukset tähän repoon; korvaa aiemmat kopiot |
| `restore_kde.sh` | Palauttaa kopiot; varmuuskopioi aiemmat kohteet `~/.kde-config-backup-*`-hakemistoon |
| [configs/](configs/) | Tallennettujen asetusten paikka |

Tarkista konekohtaiset polut ja yksityiset tiedot ennen asetusten tallentamista Gitiin.
Aiemmat erilliset pika-, skripti- ja siirtymäohjeet on tiivistetty tähän.
