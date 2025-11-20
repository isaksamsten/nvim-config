return {
  { "lambdalisue/vim-cython-syntax", lazy = false },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    build = ":TSUpdate",
    event = "BufReadPost",
    lazy = vim.fn.argc(-1) == 0,
    version = false,
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      ensure_installed = {
        "typst",
        "bash",
        "bibtex",
        "erlang",
        "html",
        "java",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rst",
        "rust",
        "vimdoc",
        "yaml",
        "zig",
      },
      additional_vim_regex_highlighting = false,
      highlight = {
        enable = true,
        disable = function(ft, buf)
          return ft == "latex" or vim.b[buf].bigfile == true or vim.fn.win_gettype() == "command"
        end,
      },
      indent = {
        enable = true,
        disable = { "erlang" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
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
            ["<leader>k"] = "@function.outer",
          },
        },
      },
    },
  },
}
