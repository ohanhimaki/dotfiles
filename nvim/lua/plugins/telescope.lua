return {

  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },

  {
    "2kabhishek/seeker.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "Seeker" },
    opts = {
      picker_provider = "snacks",
    },
  },
}