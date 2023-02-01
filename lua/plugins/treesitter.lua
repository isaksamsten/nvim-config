return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      ensure_installed = {
        "bash",
        "erlang",
        "help",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rst",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "c-space",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<c-backspace>",
        },
      },
    },
  },
}
