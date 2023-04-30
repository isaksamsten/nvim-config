--Color Library
--Taken from the excellent work of @EdenEast for nightfox.nvim
--https://github.com/EdenEast/nightfox.nvim/blob/main/lua/nightfox/lib/color.lua

---Round float to nearest int
---@param x number Float
---@return number
local function round(x)
  return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

---Clamp value between the min and max values.
---@param value number
---@param min number
---@param max number
local function clamp(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  end
  return value
end

local bitop = bit or bit32 or require("helpers.bit")

local function calc_hue(r, g, b)
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local delta = max - min
  local h = 0

  if max == min then
    h = 0
  elseif max == r then
    h = 60 * ((g - b) / delta)
  elseif max == g then
    h = 60 * ((b - r) / delta + 2)
  elseif max == b then
    h = 60 * ((r - g) / delta + 4)
  end

  if h < 0 then
    h = h + 360
  end

  return { hue = h, max = max, min = min, delta = delta }
end

--#endregion

local Color = setmetatable({}, {})
Color.__index = Color

function Color.__tostring(self)
  return self:to_css()
end

function Color.new(opts)
  if type(opts) == "string" or type(opts) == "number" then
    return Color.from_hex(opts)
  end
  if opts.red then
    return Color.from_rgba(opts.red, opts.green, opts.blue, opts.alpha)
  end
  if opts.value then
    return Color.from_hsv(opts.hue, opts.saturation, opts.value)
  end
  if opts.lightness then
    return Color.from_hsv(opts.hue, opts.saturation, opts.lightness)
  end
end

function Color.init(r, g, b, a)
  local self = setmetatable({}, Color)
  self.red = clamp(r, 0, 1)
  self.green = clamp(g, 0, 1)
  self.blue = clamp(b, 0, 1)
  self.alpha = clamp(a or 1, 0, 1)

  return self
end

--#region from_* ---------------------------------------------------------------

---Create color from RGBA 0,255
---@param r number Integer [0,255]
---@param g number Integer [0,255]
---@param b number Integer [0,255]
---@param a number Float [0,1]
---@return table Color
function Color.from_rgba(r, g, b, a)
  return Color.init(r / 0xff, g / 0xff, b / 0xff, a or 1)
end

---Create a color from a hex number
---@param c number|string Either a literal number or a css-style hex string ('#RRGGBB[AA]')
---@return table Color
function Color.from_hex(c)
  local n = c
  if type(c) == "string" then
    local s = c:lower():match("#?([a-f0-9]+)")
    n = tonumber(s, 16)
    if #s <= 6 then
      n = bitop.lshift(n, 8) + 0xff
    end
  end

  return Color.init(
    bitop.rshift(n, 24) / 0xff,
    bitop.band(bitop.rshift(n, 16), 0xff) / 0xff,
    bitop.band(bitop.rshift(n, 8), 0xff) / 0xff,
    bitop.band(n, 0xff) / 0xff
  )
end

---Create a Color from HSV value
---@param h number Hue. Float [0,360]
---@param s number Saturation. Float [0,100]
---@param v number Value. Float [0,100]
---@param a number? Alpha. Float [0,1]
---@return table Color
function Color.from_hsv(h, s, v, a)
  h = h % 360
  s = clamp(s, 0, 100) / 100
  v = clamp(v, 0, 100) / 100
  a = clamp(a or 1, 0, 1)

  local function f(n)
    local k = (n + h / 60) % 6
    return v - v * s * math.max(math.min(k, 4 - k, 1), 0)
  end

  return Color.init(f(5), f(3), f(1), a)
end

---Create a Color from HSL value
---@param h number Hue. Float [0,360]
---@param s number Saturation. Float [0,100]
---@param l number Lightness. Float [0,100]
---@param a number? Alpha. Float [0,1]
---@return table Color
function Color.from_hsl(h, s, l, a)
  h = h % 360
  s = clamp(s, 0, 100) / 100
  l = clamp(l, 0, 100) / 100
  a = clamp(a or 1, 0, 1)
  local _a = s * math.min(l, 1 - l)

  local function f(n)
    local k = (n + h / 30) % 12
    return l - _a * math.max(math.min(k - 3, 9 - k, 1), -1)
  end

  return Color.init(f(0), f(8), f(4), a)
end

--#endregion

--#region to_* -----------------------------------------------------------------

---Convert Color to RGBA
---@return table RGBA
function Color:to_rgba()
  return {
    red = round(self.red * 0xff),
    green = round(self.green * 0xff),
    blue = round(self.blue * 0xff),
    alpha = self.alpha,
  }
end

---Convert Color to HSV
---@return table HSV
function Color:to_hsv()
  local res = calc_hue(self.red, self.green, self.blue)
  local h, min, max = res.hue, res.min, res.max
  local s, v = 0, max

  if max ~= 0 then
    s = (max - min) / max
  end

  return { hue = h, saturation = s * 100, value = v * 100 }
end

---Convert the color to HSL.
---@return table HSL
function Color:to_hsl()
  local res = calc_hue(self.red, self.green, self.blue)
  local h, min, max = res.hue, res.min, res.max
  local s, l = 0, (max + min) / 2

  if max ~= 0 and min ~= 1 then
    s = (max - l) / math.min(l, 1 - l)
  end

  return { hue = h, saturation = s * 100, lightness = l * 100 }
end

---Convert the color to a hex number representation (`0xRRGGBB[AA]`).
---@param with_alpha? boolean Include the alpha component.
---@return integer
function Color:to_hex(with_alpha)
  local ls, bor, fl = bitop.lshift, bitop.bor, math.floor
  local n =
    bor(bor(ls(fl((self.red * 0xff) + 0.5), 16), ls(fl((self.green * 0xff) + 0.5), 8)), fl((self.blue * 0xff) + 0.5))
  return with_alpha and bitop.lshift(n, 8) + (self.alpha * 0xff) or n
end

---Convert the color to a css hex color (`#RRGGBB[AA]`).
---@param with_alpha? boolean Include the alpha component.
---@return string
function Color:to_css(with_alpha)
  local n = self:to_hex(with_alpha)
  local l = with_alpha and 8 or 6
  return string.format("#%0" .. l .. "x", n)
end

--#endregion

--#region Manipulate -----------------------------------------------------------

---Returns a new color that a linear blend between two colors
---@param other table
---@param f number Float [0,1]. 0 being this and 1 being other
---@return table Color
function Color:blend(other, f)
  return Color.init(
    (other.red - self.red) * f + self.red,
    (other.green - self.green) * f + self.green,
    (other.blue - self.blue) * f + self.blue,
    self.alpha
  )
end

---Returns a new shaded color.
---@param f number Amount. Float [-1,1]. -1 is black, 1 is white
---@return table Color
function Color:shade(f)
  local t = f < 0 and 0 or 1.0
  local p = f < 0 and f * -1.0 or f

  return Color.init(
    (t - self.red) * p + self.red,
    (t - self.green) * p + self.green,
    (t - self.blue) * p + self.blue,
    self.alpha
  )
end

---Adds value of `v` to the `value` of the current color. This returns either
---a brighter version if +v and darker if -v.
---@param v number Value. Float [-100,100].
---@return table Color
function Color:brighter(v)
  local hsv = self:to_hsv()
  local value = clamp(hsv.value + v, 0, 100)
  return Color.from_hsv(hsv.hue, hsv.saturation, value)
end

---Adds value of `v` to the `lightness` of the current color. This returns
---either a lighter version if +v and darker if -v.
---@param v number Lightness. Float [-100,100].
---@return table Color
function Color:lighter(v)
  local hsl = self:to_hsl()
  local lightness = clamp(hsl.lightness + v, 0, 100)
  return Color.from_hsl(hsl.hue, hsl.saturation, lightness)
end

---Syntactic sugar to make a given color, darker
---@param v number Lightness. Float [-100,100].
---@return table Color
function Color:darker(v)
  local hsl = self:to_hsl()
  local darkness = clamp(hsl.lightness - v, 0, 100)
  return Color.from_hsl(hsl.hue, hsl.saturation, darkness)
end

---Adds value of `v` to the `saturation` of the current color. This returns
---either a more or less saturated version depending of +/- v.
---@param v number Saturation. Float [-100,100].
---@return table Color
function Color:saturate(v)
  local hsv = self:to_hsv()
  local saturation = clamp(hsv.saturation + v, 0, 100)
  return Color.from_hsv(hsv.hue, saturation, hsv.value)
end

---Adds value of `v` to the `hue` of the current color. This returns a rotation of
---hue based on +/- of v. Resulting `hue` is wrapped [0,360]
---@return table Color
function Color:rotate(v)
  local hsv = self:to_hsv()
  local hue = (hsv.hue + v) % 360
  return Color.from_hsv(hue, hsv.saturation, hsv.value)
end

--#endregion

function Color.lighten(color, amount)
  return Color.from_hex(color):lighter(amount):to_css()
end

function Color.darken(color, amount)
  return Color.from_hex(color):darker(amount):to_css()
end

function Color.mix(a, b, amount)
  return Color.from_hex(a):blend(Color.from_hex(b), amount):to_css()
end

--#region Constants ------------------------------------------------------------

Color.WHITE = Color.init(1, 1, 1, 1)
Color.BLACK = Color.init(0, 0, 0, 1)

--#endregion

local mt = getmetatable(Color)
function mt.__call(_, opts)
  if type(opts) == "string" or type(opts) == "number" then
    return Color.from_hex(opts)
  end
  if opts.red then
    return Color.from_rgba(opts.red, opts.green, opts.blue, opts.alpha)
  end
  if opts.value then
    return Color.from_hsv(opts.hue, opts.saturation, opts.value)
  end
  if opts.lightness then
    return Color.from_hsl(opts.hue, opts.saturation, opts.lightness)
  end
end

return Color
