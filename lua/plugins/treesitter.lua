return {
  { "lambdalisue/vim-cython-syntax", lazy = false },
  -- { "anntzer/vim-cython", lazy = false },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    version = false,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      ensure_installed = {
        "bash",
        "erlang",
        "vimdoc",
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
        "bibtex",
        "latex",
      },
      additional_vim_regex_highlighting = false,
      highlight = { enable = true, disable = { "latex" } },
      indent = { enable = true },
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
