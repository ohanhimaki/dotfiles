# Neovim v2

Pääkonfiguraation rinnalla kehitettävä pienempi oma konfiguraatio.
Käyttää Neovim 0.12:ta, lazy.nvim:iä, Tokyo Nightia, Snacksia, Mini-moduuleja,
Treesitteriä, Blink-täydennystä, Conformia ja Mason/LSP:tä.
.NET-pino on roslyn.nvim, nvim-dap, netcoredbg ja nvim-dap-view.
EasyDotnet ja Sidekick eivät kuulu tähän konfiguraatioon; AI-CLI toimii erillisessä ikkunassa.

## Käynnistys ja ylläpito

Bootstrap ja Windowsin linkitysskripti linkittävät molemmat konfiguraatiot.
Pääkonfiguraatio säilyy oletuksena.

```bash
NVIM_APPNAME=nvim-v2 nvim
# Bash-alias:
v2
```

PowerShellissä vastaava funktio on `v2`. `NVIM_APPNAME` erottaa myös data-,
state- ja cache-hakemistot pääkonfiguraatiosta.

- `:Lazy`: pluginien hallinta ja päivitykset; tarkista `lazy-lock.json` Gitissä.
- `:Mason`: ulkoisten työkalujen hallinta.
- `:checkhealth`: ympäristön tarkistus.
- `:Roslyn target`: solutionin valinta.
- Leader on välilyönti. Which-key näyttää määritetyt näppäimet.

Yleiset asetukset ja omat viitetoiminnot: `lua/config/`.
Pluginien asetukset: `lua/plugins/`. Laajat projektiesimerkit kuuluvat
[profiilirepoon](https://github.com/ohanhimaki/ohanhimaki).

## Debuggaus


| Mapping | Toiminto |
| --- | --- |
| `<F5>` | Käynnistä tai jatka |
| `<F9>` | Lisää tai poista breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<S-F11>` tai `<F8>` | Step out |
| `<S-F5>` | Pysäytä |
| `<leader>du` | Avaa tai sulje DAP-näkymä |
| `<leader>dr` | Avaa tai sulje REPL |
| `<leader>dl` | Aja edellinen debug-konfiguraatio |
| `<leader>db` | Lisää ehdollinen breakpoint |

C#-sovellus: aja ensin `dotnet build`, aseta breakpoint ja paina `<F5>`.
Valitse `Launch .NET DLL`. Konfiguraatio ehdottaa nykyisen projektin uusinta
`bin/Debug`-DLL:ää, mutta polun voi tarvittaessa vaihtaa.

Testi: siirrä kursori Roslynin test-CodeLensille, paina `<leader>tr` ja valitse
`Debug Test`. Roslyn käynnistää testin ja liittyy siihen DAPin `coreclr`-adapterilla.

## Usean repon käyttö


Oma `git_repos`-moduuli kokoaa nykyisen hakemiston alla olevat Git-repositoryt
Snacks-pickeriin ja näyttää niiden branchin, työpuun tilan sekä upstream-erot.

| Mapping | Toiminto |
| --- | --- |
| `<leader>gr` | Avaa repository-dashboardin |
| `<leader>gg` | Avaa Lazygitin nykyiselle repositorylle |
| `<leader>gG` | Valitse repository ja avaa Lazygit |
| `<leader>fgg` | Näytä nykyisen repositoryn muuttuneet tiedostot |
| `<leader>fgG` | Valitse repository ja näytä muuttuneet tiedostot |

Dashboardissa `g`, `f`, `o` ja `p` avaavat Lazygitin, muuttuneet tiedostot,
tiedostohaun ja turvallisen fast-forward-pullin. `P` tekee pull-suunnitelman
valituille repositoryille tai kaikille, ja `r` pakottaa fetchin.

## Todennuksen rajat

Windowsissa on aiemmin tehty pluginikerroksen headless-testi muuttujalla
`NVIM_V2_SKIP_INSTALL=1`. Se ohitti parserien ja Mason-työkalujen asennukset;
se ei todista kielipalvelimen, debuggaimen tai oikean projektin toimintaa.
Avoimet kone- ja projektikohtaiset tarkistukset ovat [BACKLOGissa](../BACKLOG.md).
