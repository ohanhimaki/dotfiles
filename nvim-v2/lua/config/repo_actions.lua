local M = {}

M.lazygit = {
  label = "Lazygit",
  key = "g",
  run = function(repo)
    Snacks.lazygit({ cwd = repo.root })
  end,
}

M.changes = {
  label = "Changed files",
  key = "f",
  run = function(repo)
    Snacks.picker.git_status({
      cwd = repo.root,
      on_show = function()
        vim.cmd.stopinsert()
      end,
    })
  end,
}

M.files = {
  label = "Find files",
  key = "o",
  run = function(repo)
    Snacks.picker.files({ cwd = repo.root })
  end,
}

M.pull = {
  label = "Pull (fast-forward only)",
  key = "p",
  keep_open = true,
  run = function(repo, context)
    context.pull({ repo })
  end,
}

M.defaults = { M.lazygit, M.changes, M.files, M.pull }

return M
