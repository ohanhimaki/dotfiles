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

### Native AOT versio (maksimaalinen suorituskyky)
```bash
dotnet publish -c Release /p:PublishAot=true
```

Native AOT käännös vie hieman pidempään (~1-2 minuuttia), mutta tuottaa natiivin .exe-tiedoston joka käynnistyy huomattavasti nopeammin.

## Suorituskykyoptimointeja

C#-toteutus on optimoitu suorituskyvyn maksimoimiseksi:

✅ **Ei turhia viiveitä** - Kaikki Task.Delay-kutsut poistettu
✅ **Logging pois päältä** - Console.WriteLine-kutsut eivät suoritu tuotannossa
✅ **PublishTrimmed** - Pienennetty binääri
✅ **ReadyToRun** - Esi-käännetty koodi nopeampaan käynnistykseen
✅ **Native AOT tuki** - Valinnainen natiivi käännös maksimaalista nopeutta varten

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
- **Logger.cs**: Optimoitu logger joka on oletuksena pois päältä
- **Commands/MinimizeAllExceptFocused.cs**: Minimoi kaikki paitsi aktiivinen
- **Commands/FocusNextMinimized.cs**: Fokusoi seuraava minimoitu ikkuna
- **Commands/DisplayAllInCurrentMonitor.cs**: Palauttaa kaikki minimoidut ikkunat

## Edut Node.js-versioon verrattuna

✅ Tyyppiturva ja IntelliSense
✅ Natiivi Windows-suoritus
✅ Yksittäinen .exe-tiedosto (ei node_modules)
✅ Optimoitu käynnistysnopeus
✅ Parempi debuggauskokemus Visual Studiossa/Riderissä
✅ Tuttu C#-syntaksi

