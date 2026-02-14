local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "both"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2
o.autoindent = true

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = true
o.relativenumber = true

-- disable nvim intro
opt.shortmess:append "sI"

opt.wrap = false

o.signcolumn = "yes:2"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

o.updatetime = 250
opt.swapfile = false -- Estää .swp-tiedostojen luomisen, jotka kyykyttävät Defenderin

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- LSP diagnostics configuration
vim.diagnostic.config {
  virtual_text = true, -- Show diagnostics as virtual text at end of line
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- Terminal key handling fixes
o.ttimeout = true
o.ttimeoutlen = 50
o.timeoutlen = 500

-- show rows after end of file
o.scrolloff = 8

-- Window title configuration
o.title = true
o.titlestring = "nvim - %{fnamemodify(getcwd(), ':t')}"

o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

opt.termguicolors = true
