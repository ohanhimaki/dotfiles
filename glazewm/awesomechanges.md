# AwesomeWM-tyylinen värimaailma Zebarille

Tässä dokumentissa kuvataan muutokset, joilla Zebarin ulkoasu muutetaan vastaamaan AwesomeWM:n oranssia teemaa.

## Värikoodit

### AwesomeWM:n värit (gruvbox.lua)
- **Bright Orange (aktiivinen)**: `#fe8019`
- **Orange**: `#d65d0e`
- **Bright Yellow (fokus)**: `#fabd2f`
- **Background (dark)**: `#1d2021`
- **Background**: `#282828`
- **Background light**: `#3c3836`
- **Foreground**: `#ebdbb2`

## Muutokset Zebariin

### 1. Yläbarin värit

**Pohjaväri (tausta):**
- `#282828` (gruvbox bg0)
- Alareunan border: `#504945` (gruvbox bg2)

**Tekstit:**
- Normaali teksti: `#ebdbb2` (gruvbox fg1)

### 2. Workspace-indikaattorit

**Tyhjä workspace:**
- Tausta: `#504945` (bg2)
- Opacity: 0.3

**Aktiivinen workspace (nykyisellä monitorilla):**
- **Tausta: `#fe8019` (AwesomeWM bright_orange)**
- **Border: `#fe8019` (AwesomeWM bright_orange)**
- Teksti: `#282828` (tumma kontrasti)
- Opacity: 1.0
- Font-weight: bold
- **Border-width: 2px (ympyröity oranssilla)**

**Workspace toisella monitorilla:**
- Säilytetään eri värit eri monitoreille erottelun vuoksi:
  - Monitor 1: `#fabd2f` (bright yellow)
  - Monitor 2: `#b8bb26` (bright green)
  - Monitor 3: `#d3869b` (bright purple)
  - Monitor 4: `#8ec07c` (bright aqua)

**Hover-efekti:**
- Tausta: `#fe8019` (bright orange)
- Teksti: `#282828`
- Border: `#fe8019`

### 3. Ikkunaindikaattorit (workspace-windows)

**Normaali ikkuna:**
- Tausta: `#504945` (bg2)
- Border: `#504945`
- Ikonit: `#458588` (blue)

**Aktiivinen/fokuksessa oleva ikkuna:**
- **Tausta: `#fe8019` (AwesomeWM bright_orange)**
- **Border: `#fe8019` 2px (ympyröity oranssilla)**
- Teksti: `#282828` (tumma)
- Ikonit: `#282828` (tumma)
- Font-weight: bold

**Minimoitu ikkuna:**
- Tausta: `rgba(204, 36, 29, 0.2)` (punainen läpinäkyvä)
- Border: `#cc241d` (red)
- Ikonit: `#cc241d` (red)
- Opacity: 0.7

**Hover-efekti (normaali):**
- Tausta: `#fe8019` (bright orange)
- Border: `#fe8019`
- Teksti ja ikonit: `#282828`

### 4. Muut elementit

**Systeemi-indikaattorit (verkko, CPU, muisti, akku):**
- Säilytetään alkuperäiset värit selkeyden vuoksi:
  - Verkko: `#98971a` (green)
  - Muisti: `#b16286` (magenta)
  - CPU: `#689d6a` (cyan)
  - Akku: `#d79921` (yellow)

**Painikkeet (binding-mode, tiling-direction):**
- Normaali tausta: `#504945` (bg2)
- Hover: `#fe8019` (bright orange)

## Yhteenveto

Päämuutos on **bright orange (#fe8019)** värin käyttö:
1. **Aktiivisessa workspace-indikaattorissa** (nykyinen monitori)
2. **Aktiivisessa ikkuna-indikaattorissa** (fokuksessa oleva ikkuna)
3. **2px oranssissa borderissa** kummassakin (ympyröinti-efekti)
4. **Hover-efekteissä** kaikissa interaktiivisissa elementeissä

Tämä luo yhtenäisen oranssin aktiivisen elementin korostuksen, joka vastaa AwesomeWM:n tyyliä.

