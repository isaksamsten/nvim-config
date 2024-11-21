-- fix_colors.lua

-- Helper function to convert a hex color (e.g., "#FFFFFF") to RGB
local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end

-- Helper function to convert RGB values to hex
local function rgb_to_hex(r, g, b)
  return string.format("#%02X%02X%02X", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
end

-- Function to clamp a value between 0 and 1
local function clamp(value, min, max)
  return math.max(min, math.min(value, max))
end

-- Function to lighten a color
local function lighten_color(r, g, b, factor)
  return clamp(r + factor, 0, 1), clamp(g + factor, 0, 1), clamp(b + factor, 0, 1)
end

-- Function to darken a color
local function darken_color(r, g, b, factor)
  return clamp(r - factor, 0, 1), clamp(g - factor, 0, 1), clamp(b - factor, 0, 1)
end

-- Function to calculate relative luminance of a color
local function relative_luminance(r, g, b)
  local function channel_luminance(channel)
    if channel <= 0.03928 then
      return channel / 12.92
    else
      return ((channel + 0.055) / 1.055) ^ 2.4
    end
  end
  return 0.2126 * channel_luminance(r) + 0.7152 * channel_luminance(g) + 0.0722 * channel_luminance(b)
end

-- Function to calculate contrast ratio between two colors
local function contrast_ratio(hex1, hex2)
  local r1, g1, b1 = hex_to_rgb(hex1)
  local r2, g2, b2 = hex_to_rgb(hex2)
  local lum1 = relative_luminance(r1, g1, b1)
  local lum2 = relative_luminance(r2, g2, b2)
  if lum1 > lum2 then
    return (lum1 + 0.05) / (lum2 + 0.05)
  else
    return (lum2 + 0.05) / (lum1 + 0.05)
  end
end

-- Main function to adjust a foreground color
local function adjust_foreground_to_contrast(foreground, background, target_ratio)
  local fg_r, fg_g, fg_b = hex_to_rgb(foreground)
  local bg_r, bg_g, bg_b = hex_to_rgb(background)
  local fg_luminance = relative_luminance(fg_r, fg_g, fg_b)
  local bg_luminance = relative_luminance(bg_r, bg_g, bg_b)

  local adjust_function
  if fg_luminance < bg_luminance then
    adjust_function = darken_color
  else
    adjust_function = lighten_color
  end

  local factor = 0.005 -- Incremental adjustment factor
  while true do
    local ratio = contrast_ratio(rgb_to_hex(fg_r, fg_g, fg_b), background)
    if ratio >= target_ratio then
      return rgb_to_hex(fg_r, fg_g, fg_b)
    end

    -- Adjust the foreground color
    fg_r, fg_g, fg_b = adjust_function(fg_r, fg_g, fg_b, factor)

    -- Break if fully adjusted (either white or black)
    if fg_r == 0 and fg_g == 0 and fg_b == 0 then
      return "#000000" -- Fully darkened (black)
    elseif fg_r == 1 and fg_g == 1 and fg_b == 1 then
      return "#FFFFFF" -- Fully lightened (white)
    end
  end
end

-- Main function to iterate over highlight groups
local function analyze_highlight_contrast()
  local results = {} -- Store color pairs and scores
  local unique_pairs = {}

  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  local normal_bg = normal.bg and string.format("#%06x", normal.bg) or nil
  local normal_fg = normal.fg and string.format("#%06x", normal.fg) or nil
  -- Get all highlight groups
  for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
    local bg = hl.bg and string.format("#%06x", hl.bg) or normal_bg
    local fg = hl.fg and string.format("#%06x", hl.fg) or normal_fg

    if bg and fg and bg ~= fg and bg == normal_bg then
      local pair_key = bg .. ":" .. fg
      if unique_pairs[pair_key] == nil then
        unique_pairs[pair_key] = { group }
        local ratio = contrast_ratio(fg, bg)
        local suggested_fg = nil
        if ratio < 6 and ratio > 1.5 then
          suggested_fg = adjust_foreground_to_contrast(fg, bg, 6)
          table.insert(results, {
            group = group,
            bg = bg,
            fg = fg,
            ratio = ratio,
            suggested_fg = suggested_fg,
            suggested_ratio = contrast_ratio(suggested_fg, bg),
          })
        end
      else
        table.insert(unique_pairs[pair_key], group)
      end
    end
  end

  -- Sort results by contrast ratio
  table.sort(results, function(a, b)
    return a.ratio < b.ratio
  end)

  -- Write results to a new buffer
  local buf = vim.api.nvim_create_buf(false, true) -- Create a new scratch buffer
  vim.bo[buf].ft = "markdown"
  vim.cmd("split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  local lines = { "Highlight Group Analysis (Contrast Ratios):", "" }
  for _, result in ipairs(results) do
    table.insert(lines, "# " .. table.concat(unique_pairs[result.bg .. ":" .. result.fg], ", "))
    table.insert(
      lines,
      string.format(
        "bg: %s, fg: %s (%.2f -> %.2f) %%s/%s/%s/",
        result.bg,
        result.fg,
        result.ratio,
        result.suggested_ratio,
        result.fg,
        result.suggested_fg
      )
    )
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

-- Command to trigger the function
vim.api.nvim_create_user_command("AnalyzeHighlights", analyze_highlight_contrast, {})
-- -- Example usage
-- local background = "#181816" -- White background
-- local foreground = "#777777" -- Mid-gray foreground
-- local target_ratio = 7 -- Target WCAG contrast ratio
--
-- local adjusted_foreground = adjust_foreground_to_contrast(foreground, background, target_ratio)
-- print("Adjusted Foreground Color:", adjusted_foreground)
