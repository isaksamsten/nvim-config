local Format = {}
Format.format_on_save = true

function Format.toggle()
  if vim.b.format_on_save == false then
    Format.format_on_save = true
    vim.b.format_on_save = nil
  else
    Format.format_on_save = not Format.format_on_save
  end
end

function Format.format(client_id, bufnr, async, on_save)
  -- Do not auto-format if it has been disabled and we are saving
  if vim.b.format_on_save == false or not Format.format_on_save and on_save then
    return
  end

  vim.lsp.buf.format({
    id = client_id,
    bufnr = bufnr,
    async = async,
    timeout_ms = 5000,
  })
end

return Format
