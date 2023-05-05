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
        "java",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rst",
        "yaml",
      },
      additional_vim_regex_highlighting = false,
      highlight = { enable = true, disable = { "latex" } },
      indent = { enable = true, disable = { "python" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          node_decremental = "<c-bs>",
        },
      },
    },
  },
}
