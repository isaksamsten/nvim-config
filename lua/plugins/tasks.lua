return {
  -- TODO: Consider removing toggleterm
  {
    "stevearc/overseer.nvim",
    -- dependencies = { "akinsho/toggleterm.nvim" },
    opts = {
      -- strategy = {
      --   "toggleterm",
      --   use_shell = true,
      --   on_create = function(t)
      --     local Python = require("helpers.python")
      --     if not Python.is_activated then
      --       local activate_command = Python.activate_command()
      --       if activate_command then
      --         t:send(activate_command)
      --       end
      --     end
      --   end,
      form = {
        border = require("config.icons").borders.outer.all,
      },
      task_list = {
        direction = "right",

        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["e"] = "Edit",
          ["o"] = "Open",
          ["v"] = "OpenVsplit",
          ["s"] = "OpenSplit",
          ["f"] = "OpenFloat",
          -- ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["l"] = "IncreaseDetail",
          ["h"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["K"] = "ScrollOutputUp",
          ["J"] = "ScrollOutputDown",
        },
      },
    },
    keys = {
      { "<leader>rb", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ob", "<cmd>OverseerToggle<cr>", desc = "Build tasks" },
    },
  },
}
