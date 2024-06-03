return {
  {
    "tpope/vim-dispatch",
    version = false,
    event = "VeryLazy",
    config = function()
      local binds = {
        { "n", "`<Space>", "Dispatch" },
        { "n", "`!", "Dispatch!" },
        { "n", "`<CR>", "Make" },
        { "n", "'<CR>", "Start" },
        { "n", "'<Space>", "Start" },
        { "n", "'!", "Start!" },
      }
      require("helpers").add_clue(binds)
    end,
  },
}
