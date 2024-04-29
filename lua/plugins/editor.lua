return { -- TODO
  { "romainl/vim-cool", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-surround", event = { "ModeChanged" } },
  { "tpope/vim-commentary", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-repeat", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-unimpaired", event = { "BufReadPre", "BufNewFile" } },
  {
    "echasnovski/mini.move",
    event = { "BufReadPost", "BufNewFile" },
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
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
