return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_complete_enabled = true
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- Conflict
      vim.g.vimtex_quickfix_ignore_filters = {
        "Marginpar on page",
        "Package hyperref Warning: Difference",
      }
    end,
  },
}
