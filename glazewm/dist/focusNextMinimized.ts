/**
 * Focuses the next minimized window in the current workspace
 * This allows you to cycle through minimized windows and toggle-minimize them
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

  // Get all minimized windows in the workspace
  const minimizedWindows = focusedWorkspace.children.filter(w => 'state' in w && w.state.type === 'minimized');

  console.log(`Found ${minimizedWindows.length} minimized windows in focused workspace.`);

  if (minimizedWindows.length === 0) {
    console.log('No minimized windows to focus');
    process.exit(0);
  }

  // Focus the first minimized window
  const nextWindow = minimizedWindows[0];
  if ('appId' in nextWindow) {
    console.log(`Focusing minimized window: ${nextWindow.id} (${nextWindow.appId})`);
  } else {
    console.log(`Focusing minimized window: ${nextWindow.id}`);
  }

  await client.runCommand(`focus --container-id ${nextWindow.id}`);

  console.log('Focused minimized window. You can now toggle-minimize it with Alt+M');
  await promiseTimeout(100);
  process.exit(0);
});

