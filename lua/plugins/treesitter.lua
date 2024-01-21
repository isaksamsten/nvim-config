return {
  { "lambdalisue/vim-cython-syntax", lazy = false },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
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
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["am"] = "@function.outer",
            ["im"] = "@function.inner",
            ["ak"] = "@class.outer",
            ["ik"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["a/"] = "@comment.outer",
            ["ao"] = "@block.outer",
            ["io"] = "@block.inner",
            ["a?"] = "@conditional.outer",
            ["i?"] = "@conditional.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@function.outer",
            ["]k"] = "@class.outer",
            ["]a"] = "@parameter.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@function.outer",
            ["]K"] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]/"] = "@comment.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@function.outer",
            ["[k"] = "@class.outer",
            ["[a"] = "@parameter.outer",
            ["[/"] = "@comment.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@function.outer",
            ["[K"] = "@class.outer",
            ["[A"] = "@parameter.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<M-C-L>"] = "@parameter.inner",
          },
          swap_previous = {
            ["<M-C-H>"] = "@parameter.inner",
          },
        },
        lsp_interop = {
          enable = true,
          border = "solid",
          peek_definition_code = {
            ["<C-k>"] = "@function.outer",
          },
        },
      },
    },
  },
}
