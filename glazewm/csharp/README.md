# GlazeWM C# Scripts

C#-toteutus GlazeWM-scripteistä. Nopea, tyyppiturva, ja natiivi Windows-kokemus.

## Rakentaminen

### Kehitysversio (debug)
```bash
dotnet build
```

### Tuotantoversio (optimoitu, yksittäinen .exe)
```bash
dotnet publish -c Release
```

Tämä luo yhden .exe-tiedoston hakemistoon:
`bin/Release/net8.0/win-x64/publish/GlazeWM.Scripts.exe`

## Komennot

### 1. Minimize All Except Focused
Minimoi kaikki ikkunat paitsi aktiivisen:
```bash
GlazeWM.Scripts.exe minimize-all-except-focused
```

### 2. Focus Next Minimized
Fokusoi seuraavan minimoidun ikkunan:
```bash
GlazeWM.Scripts.exe focus-next-minimized
```

### 3. Display All In Current Monitor
Palauttaa kaikki minimoidut ikkunat nykyisessä workspacessa:
```bash
GlazeWM.Scripts.exe display-all-in-current-monitor
```

## GlazeWM Config

Lisää `config.yaml` tiedostoon:

```yaml
keybindings:
  # Minimize all except focused
  - commands: ['shell-exec --hide-window "C:\Users\kobbi\dotfiles\glazewm\csharp\bin\Release\net8.0\win-x64\publish\GlazeWM.Scripts.exe" minimize-all-except-focused']
    bindings: ['alt+shift+m']

  # Focus next minimized
  - commands: ['shell-exec --hide-window "C:\Users\kobbi\dotfiles\glazewm\csharp\bin\Release\net8.0\win-x64\publish\GlazeWM.Scripts.exe" focus-next-minimized']
    bindings: ['alt+shift+n']

  # Display all in current monitor
  - commands: ['shell-exec --hide-window "C:\Users\kobbi\dotfiles\glazewm\csharp\bin\Release\net8.0\win-x64\publish\GlazeWM.Scripts.exe" display-all-in-current-monitor']
    bindings: ['alt+n']
```

## Tekninen toteutus

- **GlazeWMClient.cs**: WebSocket-client GlazeWM IPC:lle (ws://localhost:6123)
- **Program.cs**: Pääohjelma joka kutsuu oikeaa scriptiä
- **MinimizeAllExceptFocused.cs**: Minimoi kaikki paitsi aktiivinen
- **FocusNextMinimized.cs**: Fokusoi seuraava minimoitu ikkuna
- **DisplayAllInCurrentMonitor.cs**: Palauttaa kaikki minimoidut ikkunat

## Edut Node.js-versioon verrattuna

✅ Tyyppiturva ja IntelliSense
✅ Natiivi Windows-suoritus
✅ Yksittäinen .exe-tiedosto (ei node_modules)
✅ Parempi debuggauskokemus Visual Studiossa/Riderissä
✅ Tuttu C#-syntaksi

