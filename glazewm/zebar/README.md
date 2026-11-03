# Zebar

Windowsin GlazeWM-paneeli. `settings.json` valitsee paketin `starter`,
widgetin `glazewm` ja presetin `default`.

- Widget: [glazewm.html](glzr-io.starter@0.0.0/glazewm.html).
- Aktiiviset värit: [gruvbox-styles.css](glzr-io.starter@0.0.0/gruvbox-styles.css).
- Ikkunan sijainti ja koko: [zpack.json](glzr-io.starter@0.0.0/zpack.json).
- Käynnistys: GlazeWM:n `startup_commands` ajaa `zebar`-komennon.

Windowsin asetusten linkitys: [juuren ohje](../../README.md#windows).
Zebarin pitää löytyä koneelta erikseen; `install.ps1` ei listaa sitä omana pakettinaan.
Käynnistä Zebar uudelleen muutosten jälkeen. Pelkkä GlazeWM-konffin lataus
uudelleen ei käynnistä paneelia, koska `config_reload_commands` on tyhjä.

Vanha `custom-bar/index.html`-polku ja `onedark-glazewm`-widget eivät kuulu
nykyiseen kokoonpanoon. OneDark-CSS on säilytetty vaihtoehtona, mutta aktiivinen
HTML lataa Gruvboxin. Muut teemat: [väriteemat](../../docs/colorschemes.md).
