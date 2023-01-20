return {
  {
    "stevearc/overseer.nvim",
    opts = { strategy = "toggleterm", task_list = { direction = "right" } },
    keys = {
      { "<leader>r", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>g", "<cmd>OverseerToggle<cr>", desc = "Toggle tasklist" },
    },
  },
}
