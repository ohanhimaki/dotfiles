import { ContainerType, Window, SplitContainer, WmClient, Workspace, Monitor } from 'glazewm';

export function promiseTimeout(ms: number): Promise<void> {
  return new Promise<void>(resolve => setTimeout(resolve, ms));
}

export async function attemptMoveWindow(client: WmClient, windowId: string,
    targetX: number, targetY: number, maxAttempts = 20) {
  let attempts = 0;
  let done = false;
  while (!done && attempts < maxAttempts) {
    const { windows } = await client.queryWindows();
    const w = windows.find(w => w.id === windowId);
    if (!w) {
      console.log('Window not found:', windowId);
      break;
    }
    if (w.x === targetX && w.y === targetY)
      done = true;
    else {
      if (w.x > targetX)
        await client.runCommand('move --direction left', windowId);
      else if (w.x < targetX)
        await client.runCommand('move --direction right', windowId);
      else if (w.y > targetY)
        await client.runCommand('move --direction up', windowId);
      else if (w.y < targetY)
        await client.runCommand('move --direction down', windowId);
      attempts += 1;
    }
  }
}

export async function attemptFocusWindow(client: WmClient,
    windowId: string, workspace: Workspace, maxAttempts = 20) {
  console.log('attemptFocusWindow:', windowId);
  if (!windowId) return;

  const targetWindow = getWindow(windowId, workspace);
  let attempts = 0;
  let done = false;
  while (!done && attempts < maxAttempts) {
    const { focused } = await client.queryFocused();
    if (focused.id === windowId)
      done = true;
    else {
      if (focused.x > targetWindow.x)
        await client.runCommand('focus --direction left');
      else if (focused.x < targetWindow.x)
        await client.runCommand('focus --direction right');
      else if (focused.y > targetWindow.y)
        await client.runCommand('focus --direction up');
      else if (focused.y < targetWindow.y)
        await client.runCommand('focus --direction down');
      attempts += 1;
    }
  }
}

export function getWindow(windowId: string, workspace: Workspace): Window {
  return getFlattenWindows(workspace.children).find(w => w.id === windowId)!;
}

/** @returns all windows from children, no splitcontainers */
export function getFlattenWindows(children: (SplitContainer | Window)[]): Window[] {
  return getFlattenChildren(children).filter(v => v.type === ContainerType.WINDOW);
}

/** @returns all children recursively */
export function getFlattenChildren(children: (SplitContainer | Window)[]): (SplitContainer | Window)[] {
  const result: (SplitContainer | Window)[] = [];
  for (let i = 0; i < children.length; i++) {
    const c = children[i];
    result.push(c);
    if (c.type === ContainerType.SPLIT) {
      const moreChildren = getFlattenChildren(c.children);
      result.push(...moreChildren);
    }
  }
  return result;
}

export function monitorHasWindow(monitor: Monitor, window: Window): boolean {
  const ws = monitor.children;
  const allWindows = ws.map(w => getFlattenWindows(w.children))
    .reduce((a, b) => a.concat(b), []);
  return !!allWindows.find(w => w.id === window.id);
}

export function getFocusedWorkspace(focused: Window | Workspace, workspaces: Workspace[]): Workspace {
  if (focused.type === ContainerType.WORKSPACE)
    return focused;
  else {
    return workspaces.find(w => {
      return !!getFlattenWindows(w.children).find(w => w.id === focused.id);
    })!;
  }
}

/** Finds the Window/Split/Workspace by Id */
export function findById(workspace: Workspace, id: string): Workspace | SplitContainer | Window | undefined {
  if (workspace.id === id)
    return workspace;
  return getFlattenChildren(workspace.children).find(c => c.id === id);
}

export function getFocusedMonitor(focused: Window | Workspace,monitors: Monitor[]): Monitor {
  return focused.type === ContainerType.WORKSPACE
    ? monitors.find(m => m.id === focused.parentId)!
    : monitors.find(m => monitorHasWindow(m, focused))!;
}

export async function moveWindowsToWorkspace(client: WmClient, windows: Window[], workspaceName: string) {
  for (let i = 0; i < windows.length; i++) {
    await moveWindowToWorkspace(client, windows[i], workspaceName);
  }
}

export function moveWindowToWorkspace(client: WmClient, window: Window, workspaceName: string) {
  return client.runCommand(`move --workspace ${workspaceName}`, window.id);
}
