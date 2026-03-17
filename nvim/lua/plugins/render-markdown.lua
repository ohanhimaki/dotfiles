return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    enabled = true,
    -- Moved highlight creation out of opts as suggested by plugin maintainer
    -- There was no issue, but it was creating unnecessary noise when ran
    -- :checkhealth render-markdown
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
    opts = {
      heading = {
        sign = false,
      },
      completions = {
        lsp = { enabled = true },
      },
    },
  },
  -- nvim images  for wezterm
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = "images", -- kuvat tähän kansioon
        file_name = "%Y%m%d-%H%M%S",
        use_absolute_path = false,
      },
    },
    keys = {
      {
        "<leader>p",
        function()
          require("img-clip").paste_image()
        end,
        desc = "Paste image from clipboard",
      },
    },
  },
}
