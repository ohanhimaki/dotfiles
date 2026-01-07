/**
 * Focuses workspace based on current monitor
 * Required Argument: workspaceName_1 workspaceName_2 .. workspaceName_N
 */
import { WmClient } from 'glazewm';
import { promiseTimeout } from './helper.functions.js';

const args = process.argv.slice(2);
if (!args.length) {
  console.log('No arguments provided');
  process.exit(0);
}

const client = new WmClient();
client.onConnect(async () => {
  const { monitors } = await client.queryMonitors();
  const index = monitors.findIndex(m => m.hasFocus);
  if (index < 0 || index >= args.length)
    console.warn(`Index: [${index}] out of args.length(${args.length}) bounds.`);
  else // Valid
    await client.runCommand(`focus --workspace ${args[index]}`);

  await promiseTimeout(1000);
  process.exit(0);
});
