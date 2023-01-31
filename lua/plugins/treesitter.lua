return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
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
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<c-backspace>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select function" },
            ["if"] = { query = "@function.inner", desc = "Select function implementation" },
            ["ac"] = { query = "@class.outer", desc = "Select class" },
          },
          include_surrounding_whitespace = false,
        },
        swap = {
          enable = true,
          swap_next = {
            ["]ep"] = { query = "@parameter.inner", desc = "Swap next parameter" },
            ["]em"] = { query = "@function.outer", desc = "Swap next function" },
          },
          swap_previous = {
            ["[ep"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
            ["[em"] = { query = "@function.outer", desc = "Swap previous function" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function" },
            ["]c"] = { query = "@class.outer", desc = "Next class" },
            ["]o"] = { query = "@loop.*", desc = "Next loop" },
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Next function" },
            ["[c"] = { query = "@class.outer", desc = "Next class" },
            ["[o"] = { query = "@loop.*", desc = "Next loop" },
            ["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next = {
            ["]d"] = { query = "@conditional.outer", desc = "Next conditional" },
          },
          goto_previous = {
            ["[d"] = { query = "@conditional.outer", desc = "Previous conditional" },
          },
        },
      },
    },
  },
}
