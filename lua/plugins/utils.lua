return {
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function(_, keys)
      local neogit = require("neogit")
      return {
        { "<leader>hh", neogit.open, desc = "Open neogit" },
      }
    end,
    config = true,
  },
}
