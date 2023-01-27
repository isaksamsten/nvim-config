return {
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function(_, keys)
      return {
        {
          "<leader>hh",
          function()
            return require("neogit").open()
          end,
          desc = "Open neogit",
        },
      }
    end,
    config = true,
  },
}
