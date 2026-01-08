import { ContainerType } from 'glazewm';
export function promiseTimeout(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
export async function attemptMoveWindow(client, windowId, targetX, targetY, maxAttempts = 20) {
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
export async function attemptFocusWindow(client, windowId, workspace, maxAttempts = 20) {
    console.log('attemptFocusWindow:', windowId);
    if (!windowId)
        return;
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
export function getWindow(windowId, workspace) {
    return getFlattenWindows(workspace.children).find(w => w.id === windowId);
}
/** @returns all windows from children, no splitcontainers */
export function getFlattenWindows(children) {
    return getFlattenChildren(children).filter(v => v.type === ContainerType.WINDOW);
}
/** @returns all children recursively */
export function getFlattenChildren(children) {
    const result = [];
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
export function monitorHasWindow(monitor, window) {
    const ws = monitor.children;
    const allWindows = ws.map(w => getFlattenWindows(w.children))
        .reduce((a, b) => a.concat(b), []);
    return !!allWindows.find(w => w.id === window.id);
}
export function getFocusedWorkspace(focused, workspaces) {
    if (focused.type === ContainerType.WORKSPACE)
        return focused;
    else {
        return workspaces.find(w => {
            return !!getFlattenWindows(w.children).find(w => w.id === focused.id);
        });
    }
}
/** Finds the Window/Split/Workspace by Id */
export function findById(workspace, id) {
    if (workspace.id === id)
        return workspace;
    return getFlattenChildren(workspace.children).find(c => c.id === id);
}
export function getFocusedMonitor(focused, monitors) {
    return focused.type === ContainerType.WORKSPACE
        ? monitors.find(m => m.id === focused.parentId)
        : monitors.find(m => monitorHasWindow(m, focused));
}
export async function moveWindowsToWorkspace(client, windows, workspaceName) {
    for (let i = 0; i < windows.length; i++) {
        await moveWindowToWorkspace(client, windows[i], workspaceName);
    }
}
export function moveWindowToWorkspace(client, window, workspaceName) {
    return client.runCommand(`move --workspace ${workspaceName}`, window.id);
}
