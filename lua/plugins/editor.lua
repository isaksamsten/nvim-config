return { -- TODO
  { "romainl/vim-cool", event = { "BufReadPre", "BufNewFile" } },
  {
    "echasnovski/mini.comment",
    version = false,
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
  {
    "idanarye/nvim-impairative",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("impairative.replicate-unimpaired")()
    end,
  },
  -- { "tpope/vim-unimpaired", event = { "BufReadPre", "BufNewFile" } },
  {
    "echasnovski/mini.surround",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = { -- Module mappings. Use `''` (empty string) to disable one.
      custom_surroundings = {
        ["("] = { output = { left = "( ", right = " )" } },
        ["["] = { output = { left = "[ ", right = " ]" } },
        ["{"] = { output = { left = "{ ", right = " }" } },
        ["<"] = { output = { left = "< ", right = " >" } },
      },
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
      },
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.api.nvim_set_keymap("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = true })
      vim.api.nvim_set_keymap("n", "yss", "ys_", { noremap = false })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
