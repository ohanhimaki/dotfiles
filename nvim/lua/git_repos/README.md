# Repository dashboard

`<leader>gr` opens the repositories directly below the current working directory.
If none are found, it uses the current working directory's repository. The dashboard
always opens, including for a single repository. Discovery accepts a child only
when that directory is itself the repository root; ordinary directories inside
an enclosing repository do not add that enclosing repository to the list.
Symlink aliases are deduplicated by their real path, and worktrees are supported.
Discovery runs at most four Git queries concurrently per scan.

Existing shortcuts remain available:

| Mapping | Action |
| --- | --- |
| `<leader>gg` | Lazygit for the current repository, or choose a repository |
| `<leader>gG` | Choose a repository under the working directory, then Lazygit |
| `<leader>fgg` | Changed files for the current repository, or choose a repository |
| `<leader>fgG` | Choose a repository under the working directory, then changed files |

In the dashboard, `Enter` opens the action menu. Normal-mode keys `g`, `f`, `o`,
and `p` open Lazygit, changed files, file search, and fast-forward pull respectively.
Use `i` to type a search; action letters remain ordinary text in insert mode.
`Tab` marks repositories. `P` plans a pull for marked repositories, or all discovered
repositories if none are marked (including repositories hidden by the current search).
`r` forces a fetch for all repositories. `?` shows Snacks' available mappings.
The default `gg` navigation mapping is disabled here so `g` runs immediately.
Other Snacks pickers keep their own mappings.

Local status appears first. Fetch runs in the background with up to three concurrent
processes, a 15-second timeout, and a ten-minute cache. A row marked `fetching` shows
the previously known remote state. Completed fetches update rows in place without
replacing search text, cursor position, or marked repositories. A failed fetch stays
visible; `r` retries immediately. Status is also refreshed when returning to the
repository picker. Selecting an action closes the dashboard by default; pull keeps it open for status updates.

Pull always performs a fresh fetch and status check, then presents a confirmation
listing repositories to update and reasons for skipping the others. The complete
plan appears in a scrollable buffer: use `j`/`k`, `Ctrl-d`/`Ctrl-u`, or `G` to
review it, `y` to approve, and `q`/`Esc` to cancel. Closing the window also cancels.
Only clean
repositories with an upstream and behind-only history qualify. Dirty, detached,
diverged, ahead-only, and up-to-date repositories are skipped. Status, branch, and
upstream are checked again before each pull. Updates run sequentially using
`git pull --ff-only --no-rebase` with autostash disabled. No branch switches, stash,
push, or reset is performed. Batch updates are independent; a later failure does
not roll back earlier successful updates. Network operations disable interactive
credential prompts and report failures.

## Custom actions

User actions live in `nvim/lua/config/repo_actions.lua`, outside the reusable
`git_repos` module. Pass the action list explicitly with `open({ actions = ... })`;
the module has no built-in action list or dependency on user configuration.
Edit `nvim/lua/config/repo_actions.lua` to add, remove, reorder, or rebind actions.
Its `M.defaults` list determines the menu order and available action shortcuts.
Mappings in `nvim/plugin/snacks.lua` pass this list to the dashboard. Exported
objects such as `M.lazygit` can also be reused in direct mappings; action names
are not resolved from strings.

For example, add a search action before `return M` in the configuration file:

```lua
M.search = {
  label = "Search repository",
  key = "s",
  run = function(repo)
    Snacks.picker.grep({ cwd = repo.root })
  end,
}

M.defaults = { M.lazygit, M.changes, M.files, M.pull, M.search }
```

Removing an object from `M.defaults` removes it from the menu and dashboard
shortcuts. Change its `key` to rebind it, or omit `key` to make it menu-only.
The same object can still be supplied as a direct action independently of the list.

### Action fields

| Field | Meaning |
| --- | --- |
| `label` | Required title displayed in the action menu. |
| `run(repo, context)` | Required function that executes the action. |
| `key` | Optional dashboard shortcut, active only in normal mode. |
| `enabled(repo)` | Optional function returning `true`, or `false, reason` to prevent execution. Checked when the action is selected. |
| `keep_open` | Set to `true` to retain the dashboard during the action. Otherwise it closes before execution. |

Action keys must be unique and must not use reserved dashboard keys `r`, `P`,
`q`, `i`, `<CR>`, `<Esc>`, or `<Tab>`. Explicit action mappings may replace other
Snacks defaults in this picker. The default `g` action disables `gg` here to
avoid waiting for a second key. Insert-mode letters remain search text.

`repo` contains `root` (absolute path), `name`, `branch`, `upstream`, `dirty`,
`ahead`, `behind`, `summary`, `error`, `fetching`, and `fetch_error`. Upstream and
error fields can be absent. Remote counts reflect the last completed fetch;
they may be stale while a fetch is running. `enabled` prevents execution but
does not hide the action from the menu.

The supplied context exposes:

| Function | Meaning |
| --- | --- |
| `context.refresh(repo)` | Refresh local Git status asynchronously. |
| `context.pull({ repo, ... })` | Run the built-in fetch, confirmation, and fast-forward pull workflow. |

The configured pull action calls `context.pull({ repo })` and sets
`keep_open = true` so progress remains visible. Other custom actions that mutate
Git state can call `context.refresh(repo)` after their asynchronous work finishes.

### Opening the dashboard or running an action

Use the same configured objects in mappings:

```lua
local repos = require("git_repos")
local actions = require("config.repo_actions")

vim.keymap.set("n", "<leader>gr", function()
  repos.open({
    actions = actions.defaults,
    force_root = true,
    force_picker = true,
  })
end, { desc = "Git repositories" })

-- Example direct mapping using the search action defined above.
vim.keymap.set("n", "<leader>gs", function()
  repos.open({ actions = actions.defaults, action = actions.search })
end, { desc = "Search repository" })
```

Without `action`, selecting a repository with `Enter` opens its action menu.
With `action`, `Enter` executes that object directly. Configured normal-mode
action shortcuts remain available in either case.

With one repository and no `force_picker`, a supplied action runs directly;
without a supplied action, its action menu opens directly. Set `force_picker = true`
to show the repository list even for a single repository. `force_root = true`
searches the working directory's children even when the current buffer belongs
to a repository. An optional `cwd = "/path/to/project"` supplies the directory
explicitly instead of using Neovim's current working directory.

The compatibility `run(callback, force_root)` entry point still passes a repository
path to existing callers.

## Validation

From the dotfiles root:

```sh
nvim --headless -u NONE -i NONE -l nvim/tests/git_repos.lua
nvim --headless -u NONE -i NONE -l nvim/tests/git_repos_picker.lua
```

The integration test creates temporary local Git repositories and a bare remote.
It checks discovery, fetch-driven status changes, fast-forward updates, skipped
repositories, cancellation, and failed fetches without contacting external remotes.

The picker test uses the locally installed Snacks plugin and temporary repositories
to check normal-mode mappings, immediate redraw, preserved search and selections,
and a nested action menu. Interactive terminal appearance and Lazygit itself still
need a manual check in a normal Neovim session.
