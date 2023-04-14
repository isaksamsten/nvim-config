local curl = require("plenary.curl")

local M = {}
local function handle_callback(response, callback)
  local status = response.status
  local body = response.body

  if status ~= 200 then
    vim.notify("Error, with code (" .. status .. ")")
    vim.notify(body)
    return
  end

  if body == nil or body == "" then
    vim.notify("OpenAI gave no response.")
    return
  end

  vim.schedule_wrap(function(msg)
    callback(vim.fn.json_decode(msg))
  end)(body)
end

function M.make_header()
  local token = vim.env.OPENAI_API_KEY
  if not token then
    return nil
  end
  return { Content_Type = "application/json", Authorization = "Bearer " .. token }
end

function M.edit(opts)
  local headers = M.make_header()
  if not headers then
    vim.notify("OPENAI_API_KEY is not set")
    return
  end
  curl.post("https://api.openai.com/v1/edits", {
    body = vim.fn.json_encode({
      model = opts.model,
      input = opts.input or "",
      n = 1,
      temperature = opts.temperature or 0.8,
      instruction = opts.instruction,
    }),
    headers = headers,
    callback = function(response)
      handle_callback(response, opts.callback)
    end,
  })
end

function M.fix_grammar()
  M.edit({
    model = "text-davinci-edit-001",
    input = [[
We define the \emph{counterfactual explanations for time series forecasting} problem as follows: 
given a black-box time series forecasting model $f(\cdot)$ that predicts
outcome $\hat{y} = f(x)$ for a univariate time series sample $x$, the
counterfactual $x'$ determines which of the previous steps could have been
modified in order to optimize the trajectory of the forecasting values
    ]],
    instruction = "Fix the grammar, punctuation, spelling errors. Leave LaTeX markup in place.",
    callback = function(data)
      vim.notify(data.choices[1].text)
    end,
  })
end

function M.get_visual_selection()
  local start_line, start_col = table.unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_line, end_col = table.unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local text
  if start_col == vim.v.maxcol or end_col == vim.v.maxcol then
    text = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  else
    text = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})
  end
  print(vim.inspect(text))
  return table.concat(text, "\n")
end

return M
