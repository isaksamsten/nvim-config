return {
  {
    "VonHeikemen/project-settings.nvim",
    cmd = "ProjectSettingsRegister",
    opts = {
      allow = {
        conda = function(opts)
          print("hello")
          if opts["env"] ~= nil then
            require("toggleterm.config").set({
              on_create = function(term)
                term:send("conda activate " .. opts.env)
              end,
            })
          end
        end,
      },
    },
  },
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
