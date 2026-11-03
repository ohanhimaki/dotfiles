# Neovim

Pääkonfiguraatio on tässä hakemistossa. Bootstrap ja Windowsin linkitysskripti
linkittävät sen oletuskonfiguraatioksi. Rinnakkainen kokeilu:
[nvim-v2](../nvim-v2/README.md).

```bash
nvim
NVIM_APPNAME=nvim-v2 nvim
```

Bashissa `v` ja `vim` avaavat pääkonfiguraation, `v2` avaa kokeilun.
Molemmat tarvitsevat Neovim 0.12:n. Pääkonfiguraatio käyttää `vim.pack`ia ja
Gruvboxia; v2 käyttää lazy.nvim:iä ja Tokyo Nightia.

## Ylläpito

- Editorin binääri: `bash bootstrap.sh -home --update` (tai `-work`).
- Pääkonfiguraation pluginit: `:PackUpdateFromOnline`. Tarkista lukitustiedoston muutokset Gitissä.
- Parserit: `:TSInstallAll` asentaa puuttuvat määritetyt parserit, `:TSUpdate` päivittää.
- Terveystarkistus: `:checkhealth`. Pluginien ja parserien ensilataus vaatii verkon.

Asetukset ovat `init.lua`-, `lua/`- ja `plugin/`-tiedostoissa.
Oman usean repon valitsimen ohje: [git_repos](lua/git_repos/README.md).
C#/Razor-, LSP- ja parseritarkistusten rajat: [BACKLOG](../BACKLOG.md).
