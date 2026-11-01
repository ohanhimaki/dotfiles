# Väriteemat

## Tavoite ja rajaus

Arjen työkalujen tavoite on Tokyo Night. Lähtövariantti on **night**, jota
`nvim-v2` jo käyttää. Gruvbox säilytetään vaihtoehtona myöhempää paluuta varten.
Kartoituksen jälkeen WezTerm ja Starship on vaihdettu night-palettiin; Herdrin
teeman käyttäjä vaihtoi asetuksista. Editorien käynnistystapaa ei ole muutettu.

- `nvim/` pysyy Gruvboxissa ja säilyy palautumisvaihtoehtona.
- `nvim-v2/` otetaan myöhemmin ensisijaiseksi kokeilujaksolle.
- Muut työkalut siirretään valittavissa erissä. Molempien palettien tulee säilyä.
- Yhteistä teemakytkintä ei tällä hetkellä ole.

Kartoitus tehtiin 1.11.2026 repositorion tiedostoista. Taulukon nykytila tarkoittaa
tallennettua konfiguraatiota; koneiden aktiivisia asetuksia tai asennettuja
teemapaketteja ei tarkistettu. Ulkoisten Tokyo Night -teemojen saatavuutta tai
tarkkoja valintanimiä ei ole vielä varmennettu.

## Yhteiset arjen työkalut

| Kohde | Teeman määritys ja nykytila | Gruvbox ↔ Tokyo Night nyt | Tarvittava muutos |
| --- | --- | --- | --- |
| Neovim default | [00-theme.lua](../nvim/plugin/00-theme.lua): `gruvbox.nvim`, `colorscheme gruvbox`. Myös [mini.lua](../nvim/plugin/mini.lua) sisältää statuslinen Gruvbox-värejä. | Ei saman konffin sisällä; v2 tarjoaa erillisen Tokyo Night -ympäristön. | Ei värimuutoksia. |
| Neovim v2 | [ui.lua](../nvim-v2/lua/plugins/ui.lua): `tokyonight.nvim`, `style = "night"`. | Tokyo Night valmis; Gruvboxiin palataan default-konffin kautta. | Ensisijaisen käynnistystavan valinta, ks. alla. |
| WezTerm | [config.lua](../wezterm/config.lua): `M.theme = "tokyonight_night"`. Mukana paikallinen night-skeema; tabit ja statusalueet seuraavat valintaa. | Kyllä: `M.theme = "gruvbox"` palauttaa alkuperäiset värit. | Konffin lataus tarkistettu molemmilla valinnoilla; visuaalinen tarkistus vielä tekemättä. |
| Starship (Bash ja PowerShell) | [starship.toml](../starship/starship.toml): `palette = 'tokyonight_night'`. Molemmat paletit mukana. | Kyllä: `palette = 'gruvbox_dark'` palauttaa alkuperäisen pehmennetyn paletin. | Promptin muodostus tarkistettu molemmilla paleteilla; visuaalinen tarkistus vielä tekemättä. |
| Herdr | [config.toml](../herdr/config.toml): `name = "tokyo-night"`, `auto_switch = false`. Käyttäjä vaihtoi teeman asetuksista. | Nimivalinta: aiempi arvo `gruvbox`. | Vaihto käyttäjän tekemä; Herdrin variantin tarkkaa vastaavuutta night-palettiin ei varmennettu. |
| Yazi | [theme.toml](../yazi/config/theme.toml): paikallinen Tokyo Night (night). Syntaksiesikatselu: `theme.tmTheme`. | Molemmat käyttöliittymäteemat tallessa `config/themes/`-kansiossa; vaihto kopioimalla. | [Vaihto-ohje ja alkuperä](../yazi/README.md). TOML/XML tarkistettu; visuaalinen tarkistus vielä tekemättä. |
| LazyGit | [config.yml](../lazygit/config.yml): ANSI-nimet `green`/`white`, valitun rivin tausta `#444444`. | Osittain terminaalista; oma tausta ei vaihdu. | Sovita oma tausta ja muut tarvittavat roolit molempiin paletteihin. |
| Bash / fzf / zoxide-valitsin | [.bash_aliases](../bash/.bash_aliases): `FZF_DEFAULT_OPTS` sisältää Gruvbox-hex-värit; myös `zz` käyttää interaktiivista valitsinta. | Ei. | Siirrä fzf-värit kahdeksi valittavaksi paletiksi. |
| bat ja fzf-esikatselu | [.bash_aliases](../bash/.bash_aliases) kutsuu `bat --color=always`; reposta ei löytynyt bat-teeman valintaa. | Ei repoon määriteltyä vaihtoa. | Tarkista käytössä oleva bat-teema; lisää molemmat vaihtoehdot tarvittaessa. |
| ls / eza / Git / Fastfetch | [.bashrc](../bash/.bashrc) käyttää `dircolors`:ia; [PowerShell-aliakset](../powershell/aliases.ps1) käyttävät ezaa. [Fastfetch](../linux/fastfetch/config.jsonc) käyttää mm. `blue`/`green`-värinimiä. | ANSI-värit seuraavat terminaalin palettia; mahdollisia konekohtaisia yliajoja ei tarkistettu. | Tarkista ulkoasu terminaalin vaihdon jälkeen ennen erillisten teemojen lisäämistä. |

## Windows

| Kohde | Teeman määritys ja nykytila | Gruvbox ↔ Tokyo Night nyt | Tarvittava muutos |
| --- | --- | --- | --- |
| Windows Terminal | [settings.json](../windowsterminal/settings.json): useissa profiileissa `colorScheme = "Gruvbox"`; mukana Gruvbox- ja OneDark-skeemat. | Skeeman vaihto valmis mekanismi; Tokyo Night puuttuu tiedostosta. | Lisää night-skeema ja päivitä tarvittavat profiilit; säilytä Gruvbox. |
| PowerShell / PSReadLine | [profiili](../powershell/Microsoft.PowerShell_profile.ps1): syntaksin ConsoleColor-nimet ja hakemistojen ANSI bright cyan. Promptin värit Starshipissa. | Pääosin terminaalista periytyvä. | Tarkista kontrasti uudella terminaalipaletilla; omat roolipalettinsa vain tarvittaessa. PSFzf:n väripalettia ei määritellä tässä profiilissa. |
| GlazeWM | [config.yaml](../glazewm/config.yaml): aktiivinen reunus `#d79921`; epäaktiivisen reunuksen väri määritelty, reunus pois käytöstä. | Ei. | Säilytä reunusvärit molemmille teemoille ja lisää valintatapa. |
| Zebar | [settings.json](../glazewm/zebar/settings.json) valitsee `starter/glazewm`; [glazewm.html](../glazewm/zebar/glzr-io.starter@0.0.0/glazewm.html) lataa [gruvbox-styles.css](../glazewm/zebar/glzr-io.starter@0.0.0/gruvbox-styles.css). Myös `full.html` lataa sen. | CSS-tiedoston vaihto mahdollinen; Tokyo Night puuttuu. | Lisää night-CSS ja yhteinen valintatapa. Nykyisen Gruvbox-CSS:n muuttujat ovat historiallisesti `--onedark-*`. |

## Linuxin työpöydät ja muut terminaalit

Kaikkia näitä ei tarvitse muuttaa samalla kertaa. Käytössä olevat työpöydät
valitaan erikseen; repossa oleva konffi ei yksin osoita aktiivista työpöytää.

| Kohde | Teeman määritys ja nykytila | Gruvbox ↔ Tokyo Night nyt | Tarvittava muutos |
| --- | --- | --- | --- |
| AwesomeWM | [rc.lua](../linux/awesome/rc.lua) lataa [gruvbox.lua](../linux/awesome/themes/gruvbox.lua). Myös [audio.lua](../linux/awesome/widgets/audio.lua) sisältää oman Gruvbox-värin. OneDark-vaihtoehto löytyy. | Teematiedoston valinta on, Tokyo Night puuttuu; widgetin oma väri jää erilliseksi. | Lisää night-teema ja johda widgettien värit valitusta teemasta. |
| Rofi | [config.rasi](../linux/rofi/config.rasi): `@theme "onedark"`. Myös [gruvbox-dark.rasi](../linux/rofi/gruvbox-dark.rasi) löytyy. | Teemavalitsin on, Tokyo Night puuttuu. | Lisää night-rasi; säilytä Gruvbox. |
| MangoWM / Waybar | [config.conf](../linux/mango/config.conf) ja [waybar.css](../linux/mango/waybar.css): Tokyo Night (night), myös tausta ja lukitus. | Kyllä: `python3 linux/mango/theme.py gruvbox` tai `tokyo-night`. Alkuperäinen Gruvbox säilytetty. | [Vaihto-ohje](../linux/mango/README.md). Molempien palettien konffit tarkistettu; visuaalinen tarkistus tekemättä. |
| MangoWM / fuzzel ja mako | [config.conf](../linux/mango/config.conf) käynnistää nämä; omia teemakonffeja ei löytynyt reposta. | Ei repoon määriteltyä vaihtoa. | Tarkista nykyiset konekohtaiset asetukset ja lisää paletit, jos nämä kuuluvat kokeiluun. |
| Kitty (valinnainen) | [kitty.conf](../linux/kitty/kitty.conf): Gruvbox Dark Hard sekä omat tabivärit. | Ei. | Valittavat include-paletit tarvittaessa. Kitty ei kuulu oletusasennukseen. |
| GNOME Terminal | [dconf-tiedosto](../linux/gnome-terminal-settings.dconf) määrittää fontin, ei väripalettia. | Ei repoon määriteltyä vaihtoa. | Tarkista tarve ja aktiivinen profiili ennen paletteja. |
| GNOME / GTK | [gnome-settings.dconf](../linux/gnome/gnome-settings.dconf): `Mint-Y-Dark`, Mint-kuvakkeet ja LinuxMint-shell-teema. | Ei. | Erillinen työpöytäpäätös; teemapakettien saatavuus tarkistettava. |
| Cinnamon / GTK | [cinnamon-settings.dconf](../linux/cinnamon/cinnamon-settings.dconf): `Mint-Y-Dark` GTK- ja Cinnamon-teemana. | Ei. | Erillinen työpöytäpäätös. |
| KDE Plasma | [linux/kde](../linux/kde/README.md) sisältää OneDark-ohjeita; `configs/` ei sisällä tallennettua väriskeemaa. | Ei repoon toteutettua vaihtoa. | Tarkista käyttö ja aktiiviset asetukset ennen muutoksia. |
| MangoHud (valinnainen) | [MangoHud.conf](../linux/MangoHud/MangoHud.conf): omat tausta- ja FPS-värit. | Ei. | Sovita tarvittaessa; suorituskykymittarin tilavärien erottuvuus säilytetään. |

## Editorit ja repositorion ulkopuoliset asetukset

| Kohde | Havainto | Jatkotoimi |
| --- | --- | --- |
| VS Code | [settings.json](../vscode/settings.json) ei määritä `workbench.colorTheme`:a. Mukana OneDarkPro-asetuksia, omat kursori-/rivinumerovärit ja Vim Easymotion -värit. | Selvitä aktiivinen teema ja laajennukset; säilytä molemmat teemavalinnat ja sovita yliajot. Tiedostossa oli kartoituksen alussa käyttäjän paikallisia muutoksia. |
| VS Coden Markdown | [github-markdown.css](../vscode/github-markdown.css) sisältää oman GitHub-palettinsa. | Tarkista käytössä oleva esikatselu ja CSS:n kytkentä ennen muutosta. |
| Rider / JetBrains | Repossa IdeaVim/Intellimacs; IDE:n käyttöliittymän ja editorin aktiivista väriskeemaa ei tallennettu tähän kartoitukseen. | Tarkista IDE:stä teema, editoriskeema ja palautusvalinta. |
| Muut sovellukset | Selainten, Obsidianin, Spotify-asiakkaan tai muiden ulkoisten sovellusten teemoja ei kartoitettu koneilta. | Lisää listaan käytön mukaan; nykyisestä teemasta ei oletusta. |

## Nvim v2 ensisijaiseksi kokeiluun

Nykyiset käynnistysreitit on huomioitava yhdessä:

- Bash: `v` ja `vim` avaavat default-konffin, `v2` käyttää
  `NVIM_APPNAME=nvim-v2 nvim`. `fv` kutsuu suoraan `nvim`:iä.
- PowerShell: `v` avaa default-konffin, `v2` asettaa `NVIM_APPNAME`:n ja poistaa
  sen ajon jälkeen. Se ei säilytä mahdollista aiempaa muuttujan arvoa.
  Myös `oo` kutsuu suoraan `nvim`:iä.
- Git-konffit määrittävät editoriksi `nvim`:in tai `vim`:in.
- Yazin Unix-editori käyttää `${EDITOR:-vi}`:tä; Windows-editori kutsuu `nvim`:iä.
- Bootstrap ja Windowsin linkitysskripti linkittävät molemmat konffit erikseen.

Ehdotettu toteutus: yhteinen käynnistysratkaisu molemmille shelleille, v2
arkikäyttöön ja nimetty komento vanhaan konffiin. `EDITOR`/`VISUAL`, Git ja Yazi
sovitetaan samaan valintaan. Pelkkä `v`-alias ei kata kaikkia reittejä.
`nvim/`-hakemistoa ei korvata v2:lla. PowerShellissä ympäristömuuttujan aiempi
arvo palautetaan myös virhetilanteessa.

## Toteutuksen seuranta

Valitse seuraavista eristä ensin tarvittavat. Valmiit muutokset on merkitty erikseen.

- [ ] Nvim v2:n ensisijainen käynnistys ja default-konffin palautuskomento.
- [x] WezTerm: night ja Gruvbox-valinta terminaalille, tabeille ja statusalueille; konffin lataus tarkistettu.
- [x] Starship: night ja alkuperäinen Gruvbox-paletti; promptin muodostus tarkistettu.
- [x] Herdr: käyttäjä vaihtoi teeman asetuksista (`tokyo-night`).
- [ ] fzf, bat, Yazi ja LazyGit.
- [ ] Windows Terminal, PowerShell, GlazeWM ja Zebar.
- [ ] Käytössä olevat Linux-työpöydät, paneelit, käynnistimet ja ilmoitukset.
- [ ] VS Code, Rider ja muut erikseen valittavat sovellukset.

Jokaisessa toteutuserässä säilytetään nykyinen Gruvbox-paletti, dokumentoidaan
molemmat valinnat ja tarkistetaan myös paluu. Sovelluskohtainen valitsin riittää
aluksi; mahdollista yhteistä kytkintä arvioidaan toteutuksen yhteydessä.
Toisella koneella tehtävät tarkistukset kirjataan [BACKLOG.md](../BACKLOG.md):hen
toteutuserän yhteydessä. Konffien lataustarkistukset eivät korvaa visuaalista tarkistusta.

Vanhojen README-tiedostojen OneDark-maininnat eivät aina vastaa nykyistä konffia:
esimerkiksi WezTermin ja Zebarin teema tarkistettiin varsinaisista asetuksista.
