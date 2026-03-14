# Neovim Configuration

Personal Neovim setup optimized for .NET/C# development with modern LSP, completion, and debugging tools.


![overview](images/overview.png)

## Requirements

- **Neovim** >= 0.10
- **Git**
- **ripgrep** (for grep)
- **fd** (for file finding)
- **Node.js** (for Copilot)
- **A Nerd Font** (for icons)

## Core Features

### 🚀 Plugin Highlights

- **LSP**: `roslyn.nvim` (C#), `nvim-lspconfig` (multi-language)
- **Completion**: `blink.cmp` (fast completion engine)
- **AI**: `copilot.lua` + `avante.nvim` (code suggestions + AI chat)
- **Debugging**: `nvim-dap` with .NET support
- **Fuzzy Finder**: `telescope.nvim` with frecency
- **Git**: `gitsigns`, `lazygit`
- **File Explorer**: `oil.nvim` (primary), `nvim-tree`
- **Testing**: `easy-dotnet.nvim`, `neotest`
- **Formatting**: `conform.nvim`, `none-ls`
- **UI**: `gruvbox` theme, `alpha.nvim` dashboard

### 🎯 Language Support

- **C# / .NET**: Full LSP (Roslyn), debugging (netcoredbg), testing
- **Lua**: LSP, formatting (stylua)
- **Python**: LSP, formatting (ruff)
- **JavaScript/TypeScript**: LSP, formatting (prettier, eslint)
- **HTML/CSS**: LSP support

---

## ⌨️ Key Bindings Cheat Sheet

**Leader key**: `Space`

### General

| Key | Action | Context |
|-----|--------|---------|
| `;` | Enter command mode | Normal |
| `jk` | Exit insert mode | Insert |
| `<leader><leader>` | Previous buffer | Normal |
| `<C-n>` | Toggle snacks explorer | Normal |
| `<leader>e` | Focus snacks explorer | Normal |
| `<leader>o` | Open Oil (file manager) | Normal |

### LSP & Code

| Key | Action |
|-----|--------|
| `gD` | Go to declaration |
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `gr` | Show references |
| `K` / `<C-k>` | Hover documentation |
| `<C-.>` | Code actions |
| `<leader>ra` | Rename symbol |
| `<leader>ds` | Diagnostic loclist |
| `<leader>fm` | Format file/selection |
| `<leader>tih` | Toggle inlay hints |
| `gp` | Go to previous (remapped `[`) |
| `gn` | Go to next (remapped `]`) |

### Snacks Picker (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>fa` | Find all files (seeker) |
| `<leader>ff` | Find git files (seeker) |
| `<leader>fw` | Live grep (seeker) |
| `<leader>fp` | Recent files (cwd) |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fo` | Recent files (all) |
| `<leader>fz` | Current buffer fuzzy find |
| `<leader>cm` | Git commits |
| `<leader>gt` | Git status |
| `<leader>fgg` | Git status |
| `<leader>fgr` | Git log (current file) |
| `<leader>fc` | Find in config |
| `<leader>fl` | Find in lazy plugins |
| `<leader>ma` | Marks |

#### Seeker — tiedostohaku + grep samassa pickerissä

Seeker yhdistää tiedostohaun ja greppauksen: voit siirtyä niiden välillä lennossa.

| Toiminto | Näppäin | Selite |
|----------|---------|--------|
| Vaihda tiedostohaun ja grepin välillä | `<C-e>` | Siirtyy tiedostohausta grep-moodiin tai takaisin |
| Valitse useita tiedostoja | `<Tab>` | Valitaan tiedostot joista haetaan |
| Hae sana kursorin kohdalta | `:Seeker grep_word` | Avaa grepin esitäytettynä |

**Tyypillinen käyttö:**
1. `<leader>ff` → avaa git-tiedostohaku
2. Valitse `<Tab>`:lla tiedostoja joita haluat hakea
3. Paina `<C-e>` → siirtyy grep-moodiin, hakee vain valituista tiedostoista

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit |
| `<leader>gc` | LazyGit current file |
| `<leader>gd` | Toggle git diff overlay |
| `<leader>gn` | Next git hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gl` | Blame line |
| `<leader>gb` | Full file blame |

### Testing & .NET (C# files only)

| Key | Action |
|-----|--------|
| `<leader>tr` | Run test (from buffer or selected) |
| `<leader>ta` | Run all tests from buffer |
| `<leader>tR` | Run all tests (test runner) |
| `<leader>td` | Debug test |
| `<leader>tp` | Peek stack trace |
| `<leader>tf` | Filter failed tests |
| `<C-p>` | Run .NET project |

### HTTP/REST (.http files only)

| Key | Action |
|-----|--------|
| `<leader>R` | Run HTTP request |
| `<leader>Rr` | Replay last request |
| `<leader>Rc` | Copy as cURL |
| `<leader>Rt` | Toggle view |
| `[r` / `]r` | Navigate requests |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<F5>` | Continue / Start debugging |
| `<F6>` | Debug test with DAP |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<S-F11>` | Step out |
| `<S-F5>` | Terminate debug session |
| `<F9>` | Toggle breakpoint |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Run last debug session |
| `<leader>dt` | Terminate DAP |
| `<leader>dv` | Evaluate expression |

### Navigation & Motion

| Key | Action |
|-----|--------|
| `s` | Flash jump (quick motion) |
| `S` | Flash treesitter jump |
| `<C-d>` / `<C-u>` | Half-page down/up |
| `<leader>q` | Toggle quickfix |
| `<leader>l` | Toggle loclist |

### Terminal

| Key | Action |
|-----|--------|
| `<C-g>` | Toggle terminal |
| `<C-x>` | Exit terminal mode (in terminal) |
| `<Esc><Esc>` | Exit terminal mode (alternative) |

### Comments

| Key | Action |
|-----|--------|
| `<leader>/` | Toggle comment (line/selection) |
| `gcc` | Toggle line comment |
| `gc` | Comment selection (visual) |

### AI Tools

| Key | Action |
|-----|--------|
| `<C-w>` | Accept Copilot suggestion |
| `<C-d>` | Dismiss Copilot |
| `<leader>aa` | Ask Avante (AI chat) |
| `<leader>ae` | Edit with Avante |
| `<leader>ar` | Refresh Avante |

### Which-Key

| Key | Action |
|-----|--------|
| `<leader>wK` | Show all keymaps |
| `<leader>wk` | Query specific keymap |

---

## 🔧 Configuration Structure

```
nvim/
├── init.lua              # Entry point, lazy.nvim bootstrap
├── lua/
│   ├── options.lua       # Vim options & settings
│   ├── mappings.lua      # Global key mappings
│   ├── autocmds.lua      # Autocommands
│   └── plugins/          # Plugin configurations
│       ├── lsp.lua       # LSP, treesitter, roslyn, easy-dotnet
│       ├── completions.lua   # blink.cmp, snippets
│       ├── debugging.lua     # DAP, neotest
│       ├── telescope.lua     # Fuzzy finder
│       ├── git-tools.lua     # Git integrations
│       ├── ai-tools.lua      # Copilot, Avante
│       ├── kulala.lua        # HTTP client
│       └── ...               # Other plugin configs
└── lazy-lock.json        # Plugin version lock
```

## 🎨 Customization

- **Change theme**: Edit `lua/plugins/init.lua` and modify the gruvbox config
- **Add LSP servers**: Edit `lua/plugins/lsp.lua` in the lspconfig section
- **Modify keybindings**: Edit `lua/mappings.lua` for global, or plugin files for plugin-specific
- **Add plugins**: Create new file in `lua/plugins/` that returns a lazy.nvim spec

## 🐛 Troubleshooting

**LSP not working?**
```vim
:LspInfo          " Check attached servers
:Mason            " Install missing LSP servers
```

**Plugins not loading?**
```vim
:Lazy sync        " Update all plugins
:Lazy clean       " Remove unused plugins
```

**Performance issues?**
```vim
:Lazy profile     " Check plugin load times
```

**Treesitter error: `Invalid node type "except*"` (tai vastaava) Python-tiedostoa avattaessa?**

Tämä johtuu siitä, että Neovim pitää vanhaa parseria lukossa, joten `:TSUpdate python` ei pysty ylikirjoittamaan sitä. Sulje Neovim ja kopioi kompilloitu parseri manuaalisesti:

```powershell
Copy-Item -Force "$env:LOCALAPPDATA\nvim-data\tree-sitter-python\parser.so" `
                 "$env:LOCALAPPDATA\nvim-data\lazy\nvim-treesitter\parser\python.so"
```

Avaa Neovim uudelleen — virheen pitäisi olla poissa.

## 📝 Notes

- **Swap files disabled** to avoid Windows Defender issues
- **CursorHold** used for LSP highlight (not CursorMoved) for performance
- **Filetype-specific keybindings** prevent conflicts (e.g., `<leader>R` works differently in .http vs .cs files)
- **updatetime** set to 250ms for responsive feedback

---

## 🔗 Useful Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/tool installer |
| `:TSUpdate` | Update treesitter parsers |
| `:Seeker` | Open seeker picker |
| `:DotnetUI` | Open .NET project UI |
| `:LspRestart` | Restart LSP servers |
| `:MessagesToBuffer` | Copy messages to new buffer |

## License

Personal configuration - feel free to use/modify as needed.

---

## 🗄️ Dadbod — SQL-yhteydet Neovimissa

Dadbod on kevyt SQL-client suoraan Neovimissa. Avaa UI:n `<leader>db`.

### Microsoft Fabric SQL endpoint (Azure AD SSO)

Fabric Warehouse ja Lakehouse -endpointit käyttävät Azure AD / Entra ID -autentikaatiota.

#### Vaatimukset

```powershell
# 1. Asenna go-sqlcmd (ei vanha sqlcmd!)
winget install Microsoft.Sqlcmd

# 2. Kirjaudu Azure AD:hen
az login
```

#### Yhteyden lisääminen

Muokkaa `dadbod.lua` ja poista `vim.g.dbs`-lohkon kommentit:

```lua
vim.g.dbs = {
  {
    name = "Fabric - MyWarehouse",
    url = "sqlserver://tyopaikkasi.datawarehouse.fabric.microsoft.com/TietokantaNimi?authentication=ActiveDirectoryDefault",
  },
}
```

Fabric SQL endpoint -osoite löytyy Fabric-portaalista:
**Workspace → Warehouse/Lakehouse → Settings → SQL connection string**

#### Authentication-vaihtoehdot

| Arvo | Käyttötilanne |
|------|--------------|
| `ActiveDirectoryDefault` | Käyttää `az login` -sessiotasi automaattisesti (suositeltu) |
| `ActiveDirectoryInteractive` | Avaa browser-SSO-ikkunan jos token vanhentunut |

#### Testaa ennen Neovimia

```powershell
sqlcmd -S tyopaikkasi.datawarehouse.fabric.microsoft.com `
       -d TietokantaNimi `
       --authentication-method ActiveDirectoryDefault `
       -Q "SELECT 1"
```

Jos tämä toimii terminaalissa → toimii myös dadbodissa.

#### Completion (taulut, kolumnit)

`vim-dadbod-completion` on asennettu. Lisää `blink.cmp`-sourceksi `completions.lua`:han jos haluat autocompletion SQL-kyselyihin:

```lua
sources = {
  default = { "lsp", "path", "snippets", "buffer", "dadbod" },
  providers = {
    dadbod = {
      name = "Dadbod",
      module = "vim_dadbod_completion.blink",
    },
  },
},
```

---

## 🎨 Highlight-ryhmien konfigurointi

Highlight-ryhmiä (hl groups) käytetään kaikkialla Neovimissa määrittämään miltä teksti näyttää. Niitä voi tutkia ja muokata lennossa tai asettaa pysyvästi.

### Tutki olemassaolevia ryhmiä

```vim
" Katso miltä ryhmä näyttää (värit, bold, italic jne.)
:hi SnacksIndent1
:hi SnacksDashboardDir

" Listaa kaikki ryhmät jotka sisältävät hakusanan
:hi | grep Snacks
:hi | grep Indent
```

### Aseta highlight-ryhmä Lua-konfigissa

Laita `vim.api.nvim_set_hl` kutsu esim. `autocmds.lua`-tiedostoon tai pluginin `config`-funktion sisälle:

```lua
-- Perusmuoto: nvim_set_hl(0, "RyhmanNimi", { ... })
-- 0 = globaali namespace (käytä aina 0)

vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#504945" })
vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#665c54" })
vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#7c6f64" })

-- Muita optioita:
vim.api.nvim_set_hl(0, "EsimerkkiRyhma", {
  fg = "#ebdbb2",      -- tekstin väri (hex)
  bg = "#3c3836",      -- taustaväri
  bold = true,
  italic = true,
  underline = true,
  sp = "#fabd2f",      -- underline-väri (special)
  link = "Normal",     -- linkitä toiseen ryhmään
})
```

### Tärkeä huomio: ColorScheme-autocommand

Teeman vaihto ylikirjoittaa kaikki `set_hl`-kutsut. Kääri ne autocommandiin niin ne pysyvät:

```lua
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#504945" })
    vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#665c54" })
    vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#7c6f64" })
  end,
})
```

### Snacks indent — värikierron konfigurointi

`snacks.nvim` kiertää automaattisesti `hl`-taulukossa olevat ryhmät sisennystason mukaan:

```lua
-- snacks.lua
indent = {
  enabled = true,
  hl = {
    "SnacksIndent1",  -- taso 1, 5, 9...
    "SnacksIndent2",  -- taso 2, 6, 10...
    "SnacksIndent3",  -- taso 3, 7, 11...
    -- lisää ryhmiä = enemmän värivaihtelua
  },
},
```

### Nopea testaus lennossa

```vim
" Testaa väriä suoraan ilman tiedostoon tallentamista:
:lua vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#ff0000" })

" Selvitä mikä hl-ryhmä on kursorin alla:
:Inspect

" Katso kaikki aktiiviset ryhmät ja niiden arvot:
:InspectTree
```



## 🔀 CodeDiff — Visuaalinen diff-työkalu

CodeDiff tarjoaa VSCode-tyylisen diff-näkymän suoraan Neovimiin: koko muuttunut rivi korostuu vaaleasti ja täsmälliset merkkimuutokset tummemmalla.

### Peruskomennot

| Komento | Toiminto |
|---------|----------|
| `:CodeDiff` | Vertaa nykyistä tiedostoa HEAD:iin |
| `:CodeDiff HEAD~3` | Vertaa 3 committia taaksepäin |
| `:CodeDiff main HEAD` | Vertaa kahta branchia |
| `:CodeDiff main...HEAD` | PR-tyylinen merge-base diff |
| `:CodeDiff tiedosto1.lua tiedosto2.lua` | Vertaa kahta tiedostoa |
| `:CodeDiff history` | Selaa nykyisen tiedoston commit-historia |
| `:CodeDiff history HEAD~10` | Rajaa historia viimeiseen 10 committiin |

### Näkymässä

| Näppäin | Toiminto |
|---------|----------|
| `t` | Vaihda side-by-side / inline-näkymän välillä |

### Esimerkkejä

```vim
" Katso mitä muuttui tässä tiedostossa viime PR:ssä
:CodeDiff main...HEAD

" Vertaa kahta eri versiota samasta tiedostosta
:CodeDiff HEAD~5 HEAD

" Selaa tiedoston koko historia
:CodeDiff history --reverse
```

---

# Tips and tricks 

## Norm :norm :normal



### Lisää jotain sanan loppuun kaikilla riveillä

```vim
:%norm A;
```
Lisää ; jokaisen rivin loppuun.

### Lähetä esc painallus

(^[ = ESC, helpoin tapa on <C-v><Esc>)

Jos halutaan ajaa vain tietyille:

```vim

```


## substitute :s :substitute

:[range]s[ubstitute]/{pattern}/{string}/[flags] [count]

```vim
:%s/vanhateksti/uusiteksti/g
```
-> vaihtaa kaikki vanhateeksti esiintymät uusiteksti 

### Hyväksy yksitellen (c loppuun)

```vim
'<,'>s/vaihtaa/uusiteksti/gc
```
-> tekee valitulle alueelle, kysyy jokaisen esiintymisen kohdalla

### Erotin merkkinä voi käytätä myös vaikka . (case: pitää vaihtaa / merkit %)

```vim
'<,'>s./.%.g

```

-> Erottimena voi käyttää muitakin kuin / merkkiä, tässä erottimena . koska / vaihdetaan % merkiksi.
Oikeita caseja esim kansio polkujen korvaaminen


### RegEx patternissa

```vim
-- rivin loppuun , merkki
:%s/$/,/g

```


```vim
-- John Smith

:%s/\(\w\+\) \(\w\+\)/\2 \1/

-- Smith John

```


```vim
--apple
--banana
--carrot

:%s/\(\w\+\)/\1 AS \1,/

--apple AS apple,
--banana AS banana,
--carrot AS carrot

```


