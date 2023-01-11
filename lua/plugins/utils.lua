return {
  { 
    'TimUntersberger/neogit', dependencies = {'nvim-lua/plenary.nvim'},
    event = "VeryLazy",
    config = function (_, opts)
      local neogit = require("neogit")
      
      vim.keymap.set({"v", "n"}, "<leader>hh", neogit.open, { desc = "Open neogit" })
    end
  }
}
