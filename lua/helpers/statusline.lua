local windline = require("windline")
local b_components = require("windline.components.basic")
local vim_components = require("windline.components.vim")
local git_rev_components = require("windline.components.git_rev")
local virtualenv = require("windline.components.virtualenv")

local state = _G.WindLine.state
local utils = require("windline.utils")

local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")
local icons = require("config.icons")

local hl_list = {
  Inactive = { "InactiveFg", "InactiveBg" },
  Active = { "ActiveFg", "ActiveBg" },
  default = { "StatusFg", "StatusBg" },
}
local basic = {}
local small_width = 40
local medium_width = 88
local large_width = 100
local ignore_filetypes = { "neo-tree", "neotest-summary", "OverseerList", "Trouble" }
basic.divider = { b_components.divider, "" }

-- stylua: ignore
utils.change_mode_name({
    ['n']    = { ' -- Normal -- '   , 'Normal'  } ,
    ['no']   = { ' -- Visual -- '   , 'Visual'  } ,
    ['nov']  = { ' -- Visual -- '   , 'Visual'  } ,
    ['noV']  = { ' -- Visual -- '   , 'Visual'  } ,
    ['no'] = { ' -- Visual -- '   , 'Visual'  } ,
    ['niI']  = { ' -- Normal -- '   , 'Normal'  } ,
    ['niR']  = { ' -- Normal -- '   , 'Normal'  } ,
    ['niV']  = { ' -- Normal -- '   , 'Normal'  } ,
    ['v']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['V']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['']   = { ' -- Visual -- '   , 'Visual'  } ,
    ['s']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['S']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['']   = { ' -- Visual -- '   , 'Visual'  } ,
    ['i']    = { ' -- Insert -- '   , 'Insert'  } ,
    ['ic']   = { ' -- Insert -- '   , 'Insert'  } ,
    ['ix']   = { ' -- Insert -- '   , 'Insert'  } ,
    ['R']    = { ' -- Replace -- '  , 'Replace' } ,
    ['Rc']   = { ' -- Replace -- '  , 'Replace' } ,
    ['Rv']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['Rx']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['c']    = { ' -- Commmand -- ' , 'Command' } ,
    ['cv']   = { ' -- Commmand -- ' , 'Command' } ,
    ['ce']   = { ' -- Commmand -- ' , 'Command' } ,
    ['r']    = { ' -- Replace -- '  , 'Replace' } ,
    ['rm']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['r?']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['!']    = { ' -- Normal -- '   , 'Normal'  } ,
    ['t']    = { ' -- Normal -- '   , 'Command' } ,
    ['nt']   = { ' -- Terminal -- ' , 'Command' } ,
})

basic.vi_mode = {
  name = "vi_mode",
  hl_colors = hl_list.default,
  text = function()
    return state.mode[1]
  end,
}

basic.lsp_diagnos = {
  name = "diagnostic",
  hl_colors = hl_list.default,
  width = large_width,
  text = function(bufnr)
    if lsp_comps.check_lsp(bufnr) then
            -- stylua: ignore
            return {
                { lsp_comps.lsp_error({ format = " " .. icons.diagnostics.error .." %s", show_zero = true }), '' },
                { lsp_comps.lsp_warning({ format = " " .. icons.diagnostics.warn .. " %s", show_zero = true }), '' },
            }
    end
    return ""
  end,
}
local function toggle(name, icon)
  local Toggle = require("helpers.toggle")
  return function()
    local is_active = Toggle["is_" .. name .. "_active"]
    if is_active then
      return icon .. " "
    else
      return ""
    end
  end
end
basic.file = {
  name = "file_name",
  text = function()
    return {
      { b_components.cache_file_name("", "unique"), "" },
      { b_components.file_modified(icons.file.modified) },
    }
  end,
}

local line_col = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  return string.format(" Ln %3s, Col %-2s ", row, col + 1)
end

local spaces = function()
  return "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth") .. " "
end

local line_format = function()
  local format_icons = {
    unix = "LF",
    dos = "CRLF",
    mac = "LF",
  }
  return function()
    return format_icons[vim.bo.fileformat] or vim.bo.fileformat
  end
end

basic.line_col_right = {
  hl_colors = hl_list.default,
  text = function(_, _, width)
    if vim.api.nvim_buf_get_option(0, "filetype") == "" and vim.fn.wordcount().bytes < 1 then
      return ""
    end
    if width > large_width then
      return {
        { line_col },
        { spaces },
        { b_components.file_encoding() },
        { " " },
        { line_format() },
        { " " },
      }
    elseif width < small_width then
      return {}
    else
      return {
        { line_col, "" },
      }
    end
  end,
}

basic.git_branch = {
  name = "git_branch",
  hl_colors = hl_list.default,
  width = medium_width,
  text = function(bufnr)
    if git_comps.is_git(bufnr) then
      return {
        { git_comps.git_branch(), hl_list.default, large_width },
        {
          git_rev_components.git_rev({ format = " %s⇣ %s⇡ " }),
          hl_list.default,
          large_width,
        },
      }
    end
    return ""
  end,
}

basic.macro = {
  name = "macro",
  hl_colors = hl_list.default,
  width = small_width,
  text = function(bufnr)
    if package.loaded["noice"] and require("noice").api.status.mode.has then
      return require("noice").api.status.mode.get()
    end
  end,
}

basic.command = {
  name = "command",
  hl_colors = hl_list.default,
  width = medium_width,
  text = function(bufnr)
    if package.loaded["noice"] and require("noice").api.status.command.has then
      return require("noice").api.status.command.get()
    end
  end,
}

basic.icons = {
  hl_colors = hl_list.icons,
  text = function(_, _, width)
    if vim.api.nvim_buf_get_option(0, "filetype") == "" and vim.fn.wordcount().bytes < 1 then
      return ""
    end
    if width > large_width then
      return {
        { toggle("format", icons.ui.auto_format .. " ") },
        { toggle("conceal", icons.ui.conceal .. " ") }, -- TODO: improve
      }
    else
      return {}
    end
  end,
}

basic.file_name = function(bufnr)
  local ft = b_components.file_type({ default = "" })
  return function(bufnr)
    local name = ft(bufnr)
    if vim.tbl_contains(ignore_filetypes, name) or name == "alpha" then
      return ""
    end
    return name:sub(1, 1):upper() .. name:sub(2)
  end
end
local default = {
  filetypes = { "default" },
  active = {
    basic.git_branch,
    basic.lsp_diagnos,
    { " " },
    basic.vi_mode,
    basic.macro,
    { " " },
    basic.divider,
    { " " },
    basic.command,
    { vim_components.search_count() },
    { " " },
    basic.file,
    basic.icons,
    basic.line_col_right,
    {
      basic.file_name(),
    },
    { virtualenv.virtualenv({ format = " [%s]" }) },
    { " " },
  },
  inactive = {
    { b_components.full_file_name, hl_list.Inactive },
    basic.divider,
    { b_components.line_col, hl_list.Inactive },
    { b_components.progress, hl_list.Inactive },
  },
}
local explorer = {
  filetypes = ignore_filetypes,
  active = {},
  always_active = true,
  show_last_status = true,
}

local M = {}
M.setup = function()
  windline.setup({
    colors_name = function(colors)
      colors.StatusFg = colors.ActiveFg
      colors.StatusBg = colors.ActiveBg
      return colors
    end,
    statuslines = {
      default,
      explorer,
    },
    -- tabline = {}, TODO: ENABLE ME
  })
end

M.setup()

M.change_color = function(bgcolor, fgcolor)
  local colors = windline.get_colors()
  colors.StatusFg = fgcolor or colors.StatusFg
  colors.StatusBg = bgcolor or colors.StatusBg
  windline.on_colorscheme(colors)
end

return M
