return {
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function(_, keys)
      return {
        { "<leader>hh", require("neogit").open, desc = "Open neogit" },
      }
    end,
    config = true,
  },
}
