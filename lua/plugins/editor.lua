-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "stevearc/aerial.nvim",
    config = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      placement = "edge",
    },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Symbol outline" },
    },
  },

  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
}
