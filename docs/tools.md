# Työkalut ja cheatsheet

Tämä on oman ympäristön työkaluhakemisto. Komennot kuvaavat repossa olevia
asetuksia; ne eivät tarkoita, että kaikki työkalut olisi asennettu joka koneelle.
Asennukset: [Linux](../linux/README.md) ja [Windows](../README.md#windows).
Laajemmat esimerkit ja oppaat: [ohanhimaki/ohanhimaki](https://github.com/ohanhimaki/ohanhimaki).

## Työkalujen roolit

| Työkalu | Käyttö ja asetukset |
| --- | --- |
| Bash / PowerShell | Shellit, aliakset ja hakemistonavigointi: [Bash](../bash/), [PowerShell](../powershell/) |
| WezTerm | Terminaali, paneelit ja workspacet: [cheatsheet](../wezterm/README.md) |
| Starship | Molempien shellien prompt: [asetukset](../starship/starship.toml) |
| Neovim | Pääeditori: [ohje](../nvim/README.md); [v2-kokeilu](../nvim-v2/README.md) |
| LazyGit | Gitin terminaalikäyttöliittymä: [asetukset](../lazygit/config.yml) |
| Yazi | Tiedostonhallinta: [ohje ja teemat](../yazi/README.md) |
| ripgrep / fd | Sisältö- ja tiedostohaku: `rg`, `fd` (Mintissä myös `fdfind`) |
| fzf / zoxide | Interaktiiviset haut ja käytettyihin hakemistoihin siirtyminen |
| eza / bat | Hakemistolistaukset ja syntaksiväritetty tiedostojen luku |
| VS Code | Toinen editori: [asetukset ja laajennukset](../vscode/README.md) |
| IdeaVim | JetBrains-editorien Vim-asetukset: [idea](../idea/) |
| Herdr | Erillinen CLI-istuntojen työkalu; [asetukset](../herdr/config.toml), asennus erikseen |
| MangoWM | Valinnainen Fedora-työpöytä: [asennus ja näppäimet](../linux/mango/README.md) |
| GlazeWM / Zebar | Windowsin ikkunanhallinta ja paneeli: [asetukset](../glazewm/config.yaml) |
| PowerToys / Windows Terminal | Windows-apuohjelmat ja vaihtoehtoinen terminaali: [PowerToys](../powertoys/), [Terminal](../windowsterminal/) |

SDK:iden ja muiden asennettavien työkalujen lista on [Linux-ohjeessa](../linux/README.md).
Vanhan työkalun asetuskansio ei tarkoita oletusasennusta: esimerkiksi Kitty,
screen, tmux, GIMP ja DBeaver eivät kuulu nykyiseen Linux-oletusasennukseen.

## Bashin komentomuistio

Lähde: [.bash_aliases](../bash/.bash_aliases). PowerShellillä on
[omat aliaksensa](../powershell/aliases.ps1); taulukko koskee Bashia.

| Komento | Toiminto |
| --- | --- |
| `..`, `...` | Yksi tai kaksi hakemistoa ylöspäin |
| `dotf` | Siirry `~/dotfiles`-hakemistoon |
| `ls`, `l`, `ll`, `la` | eza-listaukset, kun eza löytyy; `ll` näyttää myös piilotetut |
| `lsd`, `lt` | Vain hakemistot / kahden tason puu, kun eza löytyy |
| `command ls` | Tavallinen ls aliasmäärityksen ohi |
| `bat tiedosto` | Lue tiedosto syntaksiväreillä; `cat` säilyy tavallisena |
| `rg "teksti"` | Hae tiedostojen sisällöstä |
| `fd nimi` | Hae tiedostoja nimellä |
| `fv` | Valitse tiedosto fzf:llä ja avaa pää-Neovimiin |
| `fcd` | Valitse hakemisto fzf:llä ja siirry siihen |
| `zz` | Valitse zoxiden muistama hakemisto |
| `lg`, `fgl` | LazyGit / Git-lokin fzf-selain |
| `y` | Avaa Yazi ja siirry poistuttaessa sen viimeiseen hakemistoon |
| `v`, `vim` | Avaa pää-Neovim |
| `v2` | Avaa erillinen nvim-v2-konfiguraatio |

Mintissä bootstrap tekee tarvittaessa käyttäjäkohtaiset `fd` → `fdfind`- ja
`bat` → `batcat`-linkit. Pelkkien asetusten kanssa Bash tukee myös näitä
jakelunimiä. fzf:n `Ctrl+/` vaihtaa esikatselun näkyvyyttä.

## Ylläpito

Päivityskomennot ovat [huolto-ohjeessa](../linux/MAINTENANCE.md).
Teemavalinnat ovat [väriteemaohjeessa](colorschemes.md).
Pidä cheatsheetissä vain käytetyt komennot; tarkat näppäimet määritellään
aina työkalun konfiguraatiossa.
