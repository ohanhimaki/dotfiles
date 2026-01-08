/**
 * Minimizes all windows in the current workspace except the focused one
 */
import { WmClient } from 'glazewm';
import { promiseTimeout } from './helper.functions.js';

const client = new WmClient();
client.onConnect(async () => {
  const { workspaces } = await client.queryWorkspaces();
  const focusedWorkspace = workspaces.find(w => w.hasFocus);

  if (!focusedWorkspace) {
    console.log('No focused workspace found');
    process.exit(0);
  }

  // Get all windows in the workspace (not minimized)
  const windows = focusedWorkspace.children.filter(w => 'state' in w && w.state.type !== 'minimized');

  console.log(`Found ${windows.length} visible windows in focused workspace.`);

  // Find the focused window
  let focusedWindow = null;
  for (const win of windows) {
    if ('hasFocus' in win && win.hasFocus) {
      focusedWindow = win;
      if ('appId' in win) {
        console.log(`Keeping focused window: ${win.id} (${win.appId})`);
      } else {
        console.log(`Keeping focused window: ${win.id}`);
      }
      break;
    }
  }

  if (!focusedWindow) {
    console.log('No focused window found');
    process.exit(0);
  }

  // Minimize all other windows
  for (const win of windows) {
    if (win.id !== focusedWindow.id) {
      if ('appId' in win) {
        console.log(`Minimizing window: ${win.id} (${win.appId})`);
      } else {
        console.log(`Minimizing window: ${win.id}`);
      }
      await client.runCommand(`focus --container-id ${win.id}`);
      await client.runCommand(`toggle-minimized`);
      await promiseTimeout(50);
    }
  }

  // Restore focus to the original window
  await client.runCommand(`focus --container-id ${focusedWindow.id}`);

  console.log('Done minimizing all except focused window.');
  await promiseTimeout(100);
  process.exit(0);
});

