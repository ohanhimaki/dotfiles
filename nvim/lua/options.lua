require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!


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