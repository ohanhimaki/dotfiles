require "nvchad.options"

-- add yours here!

local o = vim.o

-- Terminal key handling fixes
o.ttimeout = true
o.ttimeoutlen = 50
o.timeoutlen = 500

o.cursorlineopt ='both' -- to enable cursorline!

-- Window title configuration
o.title = true
o.titlestring = "nvim - %{fnamemodify(getcwd(), ':t')}"

o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- Enhanced keyboard protocol for better key handling
vim.api.nvim_create_autocmd("VimEnter", {
callback = function()
io.stdout:write("\027[>1u")
end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
callback = function()
io.stdout:write("\027[<1u")
end,
})
