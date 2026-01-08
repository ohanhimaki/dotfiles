# GlazeWM Helper Scripts

Scripts for managing workspaces in GlazeWM window manager.

## Setup

1. Install dependencies:
   ```powershell
   npm install
   ```

## Running the Scripts

### Option 1: Run directly with tsx (Development - Easiest)
This runs TypeScript files directly without compilation:

```powershell
npm run dev
```

Or manually:
```powershell
npx tsx displayAllInCurrentMonitor.ts
```

### Option 2: Build to JavaScript (Production - Better Performance)
This compiles TypeScript to JavaScript for better performance:

1. Build the project:
   ```powershell
   npx tsc
   ```

2. Run the compiled JavaScript:
   ```powershell
   npm start
   ```
   Or manually:
   ```powershell
   node build/displayAllInCurrentMonitor.js
   ```

## Which Method to Use?

- **Development**: Use `npm run dev` (tsx) - faster iteration, no build step needed
- **Production/Daily Use**: Use `npm start` (compiled JS) - better performance, more reliable

The compiled JavaScript version is recommended for scripts you run frequently or want to bind to keyboard shortcuts in GlazeWM.

## Files

- `displayAllInCurrentMonitor.ts` - Main script to display windows in current monitor
- `helper.functions.ts` - Helper functions for GlazeWM operations
- `tsconfig.json` - TypeScript configuration
- `build/` - Compiled JavaScript output (created after running `npx tsc`)

## Performance Notes

Compiled JavaScript runs slightly faster because:
- No transpilation overhead at runtime
- Node.js can optimize the code better
- More reliable for production use

For scripts that run on keyboard shortcuts or frequently, always use the compiled version.

