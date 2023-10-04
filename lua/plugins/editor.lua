return { -- TODO
  { "romainl/vim-cool", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-surround", event = { "ModeChanged" } },
  { "tpope/vim-commentary", event = { "BufReadPre", "BufNewFile" } },
  -- { "tpope/vim-vinegar", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },

  {
    "echasnovski/mini.move",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },

  {
    "echasnovski/mini.ai",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
