return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_complete_enabled = false
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- Conflict
      vim.g.vimtex_quickfix_ignore_filters = {
        "Marginpar on page",
        "Package hyperref Warning: Difference",
      }
      -- vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 0
    end,
  },
}
