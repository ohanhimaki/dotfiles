/**
 * Focuses workspace based on current monitor
 * Required Argument: workspaceName_1 workspaceName_2 .. workspaceName_N
 */
import { WmClient } from 'glazewm';
import { promiseTimeout } from './helper.functions.js';

// const args = process.argv.slice(2);
// if (!args.length) {
//   console.log('No arguments provided');
//   process.exit(0);
// }

const client = new WmClient();
client.onConnect(async () => {
  const { monitors } = await client.queryMonitors();
  const index = monitors.findIndex(m => m.hasFocus);

  console.log('Current monitor index:', index);

  // find all windows in current workspace that are hidden
  const { workspaces } = await client.queryWorkspaces();
  const focusedWorkspace = workspaces.find(w => w.hasFocus);
  if (!focusedWorkspace) {
    console.log('No focused workspace found');
    process.exit(0);
  }
  const minimizedWindows = focusedWorkspace.children.filter(w => 'state' in w && w.state.type === 'minimized');

  console.log(`Found ${minimizedWindows.length} hidden windows in focused workspace.`);

  for (const win of minimizedWindows) {
    if ('appId' in win) {
      console.log(`Restoring window: ${win.id} (${win.appId})`);
    } else {
      console.log(`Restoring window: ${win.id}`);
    }
    await client.runCommand(`focus --container-id ${win.id}`);
    await client.runCommand(`toggle-minimized`);
  }
  await promiseTimeout(1000);
  process.exit(0);
});
