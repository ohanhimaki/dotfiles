# DBeaver Configuration

DBeaver Community Edition database management tool.

## Installation

### Linux (Flatpak)
```bash
flatpak install -y flathub io.dbeaver.DBeaverCommunity
```

### Windows
```powershell
winget install dbeaver.dbeaver
```

## Configuration Location

### Linux (Flatpak)
- Config: `~/.var/app/io.dbeaver.DBeaverCommunity/data/DBeaverData/`
- Symlinked to: `~/dotfiles/dbeaver/`

### Windows
- Config: `%APPDATA%\DBeaverData\`
- Symlinked to: `~/dotfiles/dbeaver/`

## Workspace

DBeaver uses workspace concept. The main workspace folder is:
- `workspace6/` - Contains connections, preferences, and settings

## Important Files

- `workspace6/.metadata/.plugins/org.jkiss.dbeaver.core/credentials-config.json` - Encrypted credentials
- `workspace6/.metadata/.plugins/org.jkiss.dbeaver.core/General/` - Database drivers
- `workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings/` - UI preferences

## Supported Databases

- SQLite (built-in)
- Microsoft SQL Server (JDBC driver auto-download)
- Microsoft Fabric (Azure Synapse, Databricks)
- PostgreSQL, MySQL, Oracle, MongoDB, and 100+ more

## Launch

### Linux
```bash
flatpak run io.dbeaver.DBeaverCommunity
# or via rofi: Super+P -> "DBeaver"
```

### Windows
```powershell
dbeaver
```

