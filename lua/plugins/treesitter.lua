return {
  { "lambdalisue/vim-cython-syntax", lazy = false },
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
      indent = {
        enable = true,
        disable = { "python" },
        incremental_selection = {
          enable = false,
        },
      },
    },
  },
}
