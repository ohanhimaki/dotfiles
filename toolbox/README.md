# Toolbox

Itsenäisiä apuskriptejä selvityksiin ja ylläpitoon, esimerkiksi palvelimille,
joilla dotfilesia ei ole. Jokainen tiedosto toimii yksinään ilman muita
dotfiles-tiedostoja.

Funktioiden tarkemmat ohjeet löytyvät PowerShellistä: `Get-Help <Funktio> -Full`.

## Käyttö palvelimella


Kopioi tiedosto palvelimelle ja dot-sourcea se:

```powershell
. .\ServerDiagnostics.ps1
```

Tai kopioi koodi leikepöydälle, pasteta powershelliin ja suorita.

## Sisältö

### ServerDiagnostics.ps1

| Funktio | Kuvaus |
| --- | --- |
| `Get-FolderSizes [-Path]` | Alikansioiden koot (GB/MB) suurimmasta pienimpään, mukana kansion omat tiedostot. |
