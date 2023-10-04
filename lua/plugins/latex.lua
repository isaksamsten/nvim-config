return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_complete_enabled = false
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- Conflict
    end,
  },
}
