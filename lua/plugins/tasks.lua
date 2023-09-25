return {
  { "tpope/vim-dispatch", event = "VeryLazy" },
  {
    "stevearc/overseer.nvim",
    enabled = false,
    opts = {
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
          -- ["<C-q>"] = vim.NIL,
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
    cmd = { "OverseerOpen", "OverseerRun" },
    keys = {
      { "<leader>rb", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ro", "<cmd>OverseerToggle<cr>", desc = "Task status" },
    },
  },
}
