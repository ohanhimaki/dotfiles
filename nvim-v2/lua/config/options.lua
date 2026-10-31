local opt = vim.opt

-- UI
opt.laststatus = 3
opt.showmode = false
opt.splitkeep = "screen"
opt.confirm = true
opt.cursorline = true
opt.cursorlineopt = "both"
opt.fillchars = { eob = " " }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.termguicolors = true
opt.winborder = "single"
opt.title = true
opt.titlestring = "nvim - %{fnamemodify(getcwd(), ':t')}"
opt.shortmess:append("sI")

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = true

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true
opt.wrap = false
opt.formatoptions:remove({ "c", "r", "o" })
opt.whichwrap:append("<>[]hl")

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Windows
opt.signcolumn = "yes:1"
opt.splitbelow = true
opt.splitright = true
opt.mouse = "a"
opt.scrolloff = 2

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.writebackup = false
opt.backupcopy = "yes"
opt.updatetime = 250

-- Key sequence timing
opt.timeoutlen = 500
opt.ttimeout = true
opt.ttimeoutlen = 50

-- Clipboard
opt.clipboard = "unnamedplus"

-- Use PowerShell 7 for :terminal on Windows.
if vim.fn.has("win32") == 1 then
  opt.shell = "pwsh"
  opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
})

vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
})

-- Disable host providers that this config does not use.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
