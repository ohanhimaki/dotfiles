---
name: razorconsole-skill
description: Guide how to use RazorConsole effectively
---

# RazorConsole – AI Skill / Custom Instructions

RazorConsole is a .NET library that lets you build terminal UIs using Razor component syntax (familiar from Blazor) backed by Spectre.Console rendering. Version: **0.4.0** (stable). NuGet: `RazorConsole.Core`.

---

## Project Setup

### .csproj – must use Razor SDK
```xml
<Project Sdk="Microsoft.NET.Sdk.Razor">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
    <Nullable>enable</Nullable>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="RazorConsole.Core" Version="0.4.0" />
  </ItemGroup>
</Project>
```

### _Imports.razor – required global usings
```razor
@using Microsoft.AspNetCore.Components
@using Microsoft.AspNetCore.Components.Web
@using Microsoft.Extensions.Hosting
@using RazorConsole.Components
```

### Program.cs – minimal host
```csharp
using Microsoft.Extensions.Hosting;
using RazorConsole.Core;

var host = Host.CreateDefaultBuilder(args)
    .UseRazorConsole<MyComponent>()
    .Build();
await host.RunAsync();
```

---

## Component Reference

### Layout
| Component | Purpose | Key Parameters |
|-----------|---------|---------------|
| `<Rows>` | Stack children vertically | — |
| `<Columns>` | Place children side by side | — |
| `<Grid>` | Multi-row multi-column layout | — |
| `<Align>` | Position content in a fixed box | `Horizontal`, `Vertical` |
| `<Padder>` | Add outer padding | `Left`, `Right`, `Top`, `Bottom` |
| `<Scrollable>` | Keyboard-scrollable region | — |

### Display
| Component | Purpose | Key Parameters |
|-----------|---------|---------------|
| `<Markup>` | Styled text | `Content`, `Foreground`, `Background`, `Decoration` |
| `<Newline>` | Blank line spacer | — |
| `<Panel>` | Framed container with title | `Header` |
| `<Border>` | Spectre border style | `BorderStyle` |
| `<Figlet>` | Big ASCII art text | `Content`, `Color` |
| `<Markdown>` | Render markdown string | `Content` |
| `<Table>` | Structured table | `Columns`, child `<TableRow>` |
| `<BarChart>` | Horizontal bar chart | — |
| `<SyntaxHighlighter>` | Colored code | `Content`, `Language` |
| `<ModalWindow>` | Overlay window | `ZIndex` |

### Input / Interactive
| Component | Purpose | Key Parameters |
|-----------|---------|---------------|
| `<TextButton>` | Clickable button | `Content`, `OnClick`, `BackgroundColor`, `FocusedColor` |
| `<TextInput>` | Text field | `Value`, `OnChange`, `MaskInput` (for passwords) |
| `<Select>` | Option list | `Items`, `OnSelect` |

### Utilities
| Component | Purpose |
|-----------|---------|
| `<Spinner>` | Animated progress indicator |

---

## ⚠️ Critical Gotchas

### 1. `<Markup>` does NOT support Spectre markup syntax
❌ Wrong:
```razor
<Markup Content="[bold cyan]Hello[/]" />
```
✅ Correct – use attribute-based styling:
```razor
<Markup Content="Hello"
        Decoration="@Spectre.Console.Decoration.Bold"
        Foreground="@Spectre.Console.Color.Cyan" />
```

### 2. Decoration flags can be combined
```razor
<Markup Content="Hello"
        Decoration="@(Spectre.Console.Decoration.Bold | Spectre.Console.Decoration.Underline)" />
```

### 3. The app keeps running until `IHostApplicationLifetime.StopApplication()` is called
RazorConsole is designed for interactive TUI apps. If you want a "run once and exit" pattern, you must trigger `StopApplication()` yourself.

---

## Patterns

### Pattern 1: Run-and-exit (show output, then quit)
Load data **before** the host starts. Call `StopApplication()` in `OnAfterRender` with a small delay.

```csharp
// Program.cs
var data = await LoadDataAsync();  // load BEFORE host

var host = Host.CreateDefaultBuilder(args)
    .UseRazorConsole<MyComponent>()
    .ConfigureServices(s => s.AddSingleton(data))
    .Build();
await host.RunAsync();
```

```razor
@* MyComponent.razor *@
@inject IHostApplicationLifetime AppLifetime
@inject MyData Data

<Rows>
    <Markup Content="@Data.SomeValue" />
</Rows>

@code {
    protected override void OnAfterRender(bool firstRender)
    {
        if (firstRender)
            // Delay prevents OperationCanceledException during startup
            _ = Task.Delay(200).ContinueWith(_ => AppLifetime.StopApplication());
    }
}
```

> **Why the delay?** Calling `StopApplication()` synchronously or immediately in `OnAfterRender` throws `OperationCanceledException` because the host is still initializing. `Task.Delay(200)` gives it time to settle.

### Pattern 2: Interactive keyboard navigation (j/k/q vim-style)

```razor
@inject IHostApplicationLifetime AppLifetime

@{
    var current = _items[_index];
}

<Rows>
    <Columns>
        <Rows>
            @* Left column: list with ▶ cursor *@
            @foreach (var (item, i) in _items.Select((x, i) => (x, i)))
            {
                if (i == _index)
                    { <Markup Content="@($"▶ {item.Name}")" Decoration="@Spectre.Console.Decoration.Bold" Foreground="@Spectre.Console.Color.Cyan" /> }
                else
                    { <Markup Content="@($"  {item.Name}")" /> }
            }
        </Rows>
        <Rows>
            @* Right column: detail view *@
            <Markup Content="@current.Name" Decoration="@Spectre.Console.Decoration.Bold" />
            <Markup Content="@current.Description" Decoration="@Spectre.Console.Decoration.Dim" />
        </Rows>
    </Columns>
</Rows>

@code {
    private int _index = 0;
    private List<MyItem> _items = new();

    protected override void OnAfterRender(bool firstRender)
    {
        if (firstRender)
        {
            _items = /* inject and assign data */;
            _ = Task.Run(ReadKeysAsync);
        }
    }

    private async Task ReadKeysAsync()
    {
        while (true)
        {
            var key = await Task.Run(() => Console.ReadKey(intercept: true));
            switch (key.Key)
            {
                case ConsoleKey.Q:
                    AppLifetime.StopApplication();
                    return;
                case ConsoleKey.J:
                case ConsoleKey.DownArrow:
                    if (_index < _items.Count - 1) { _index++; await InvokeAsync(StateHasChanged); }
                    break;
                case ConsoleKey.K:
                case ConsoleKey.UpArrow:
                    if (_index > 0) { _index--; await InvokeAsync(StateHasChanged); }
                    break;
            }
        }
    }
}
```

> **Key points:**
> - `Console.ReadKey(intercept: true)` hides the keypress from terminal output
> - `await Task.Run(...)` prevents blocking the render thread
> - `await InvokeAsync(StateHasChanged)` is required to trigger re-render from a background thread

### Pattern 3: Dependency injection with pre-loaded data

```csharp
// Program.cs
var myService = new MyService();
await myService.InitializeAsync();  // fetch/load before host

var host = Host.CreateDefaultBuilder(args)
    .UseRazorConsole<MyComponent>()
    .ConfigureServices(services =>
    {
        services.AddSingleton(myService);       // pre-loaded instance
        services.AddSingleton(new MyOptions()); // parsed CLI options etc.
    })
    .ConfigureLogging(l => l.ClearProviders()) // suppress framework noise
    .Build();
await host.RunAsync();
```

```razor
@inject MyService Service
@inject MyOptions Options
```

### Pattern 4: Custom translator (extend with Spectre.Console features)

```csharp
public sealed class MyTranslator : IVdomElementTranslator
{
    public int Priority => 85; // lower = earlier (1-1000)

    public bool TryTranslate(VNode node, TranslationContext context, out IRenderable? renderable)
    {
        renderable = null;
        if (node.Kind != VNodeKind.Element || node.TagName != "div") return false;
        if (!node.Attributes.TryGetValue("data-my-attr", out var value)) return false;

        // build renderable...
        renderable = new Markup(value);
        return true;
    }
}

// Register in host:
Host.CreateDefaultBuilder(args)
    .UseRazorConsole<MyComponent>(configure: config =>
        config.ConfigureServices(s => s.AddVdomTranslator<MyTranslator>()))
    .Build();
```

---

## Component Gallery (explore all components interactively)

```bash
dotnet tool install --global RazorConsole.Gallery --version 0.0.3-alpha.4657e6
razorconsole-gallery
```

---

## Spectre.Console Quick Reference (used in RazorConsole attributes)

### Colors (`Spectre.Console.Color.*`)
`Black`, `White`, `Grey`, `Red`, `Green`, `Blue`, `Yellow`, `Cyan`, `Magenta`, `Orange1`, `DeepSkyBlue1`, etc.
Full list: https://spectreconsole.net/appendix/colors

### Decorations (`Spectre.Console.Decoration.*`)
`Bold`, `Dim`, `Italic`, `Underline`, `Blink`, `Invert`, `Strikethrough`, `None`
Can be combined with `|`: `Decoration.Bold | Decoration.Underline`

---

## Real-world example: lunch list CLI (mts command)

Full working project at: https://github.com/your-org/mita-tanaan-syotaisiin-web (src/MTS.Cli)

Features implemented:
- Weekly local cache at `~/.mts/cache_YYYY-WNN.json`
- `--ma`/`--ti`/`--ke`/`--to`/`--pe` day selection flags
- `--refresh` to clear cache
- Two-column layout: left = restaurant list with `▶` cursor, right = menu detail
- vim-style navigation: j/↓ next, k/↑ previous, q quit
- Embedded `restaurants.json` resource via `<EmbeddedResource LogicalName="...">`
