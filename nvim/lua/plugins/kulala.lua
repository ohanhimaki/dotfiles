return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    config = function()
      require("kulala").setup()

      -- Filetype-specific keybindings only for .http/.rest files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "http", "rest" },
        callback = function(args)
          local map = vim.keymap.set
          local opts = { buffer = args.buf }
          
          map("n", "<leader>R", require("kulala").run, vim.tbl_extend("force", opts, { desc = "Run request" }))
          map("n", "<leader>Rr", require("kulala").replay, vim.tbl_extend("force", opts, { desc = "Replay request" }))
          map("n", "<leader>Rc", require("kulala").copy, vim.tbl_extend("force", opts, { desc = "Copy as cURL" }))
          map("n", "<leader>Ri", require("kulala").inspect, vim.tbl_extend("force", opts, { desc = "Inspect request" }))
          map("n", "<leader>Rt", require("kulala").toggle_view, vim.tbl_extend("force", opts, { desc = "Toggle view" }))
          map("n", "<leader>Rs", require("kulala").search, vim.tbl_extend("force", opts, { desc = "Search requests" }))
          map("n", "[r", require("kulala").jump_prev, vim.tbl_extend("force", opts, { desc = "Jump to previous request" }))
          map("n", "]r", require("kulala").jump_next, vim.tbl_extend("force", opts, { desc = "Jump to next request" }))
        end,
      })
    end,
  },
}
