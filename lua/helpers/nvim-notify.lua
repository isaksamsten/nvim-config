local api = vim.api
local base = require("notify.render.base")

local M = {}
function M.render(bufnr, notif, highlights, config)
  local left_icon = notif.icon .. " "
  local max_message_width = math.max(math.max(unpack(vim.tbl_map(function(line)
    return vim.fn.strchars(line)
  end, notif.message))))
  local right_title = notif.title[2]
  local left_title = notif.title[1]
  local title_accum = vim.str_utfindex(left_icon) + vim.str_utfindex(right_title) + vim.str_utfindex(left_title)

  local left_buffer = string.rep(" ", math.max(0, max_message_width - title_accum))

  local namespace = base.namespace()
  api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
  api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = {
      { " " },
      { left_icon, highlights.icon },
      { left_title .. left_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  api.nvim_buf_set_lines(bufnr, 2, -1, false, notif.message)

  api.nvim_buf_set_extmark(bufnr, namespace, 2, 0, {
    hl_group = highlights.body,
    end_line = 1 + #notif.message,
    end_col = #notif.message[#notif.message],
    priority = 50, -- Allow treesitter to override
  })
end

return M
