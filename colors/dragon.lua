-- Name:         dragon
-- Description:  Colorscheme inspired by kanagawa-dragon @rebelot and mellifluous @ramojus
-- Author:       Bekaboo <kankefengjing@gmail.com>
-- Maintainer:   Isak Samsten
-- License:      GPL-3.0

-- Clear hlgroups and set colors_name {{{
vim.cmd.hi("clear")
vim.g.colors_name = "dragon"
-- }}}

-- Palette {{{
-- stylua: ignore start
local c_autumnGreen
local c_autumnRed
local c_autumnYellow
local c_carpYellow
local c_dragonAqua
local c_dragonAsh
local c_dragonBg0
local c_dragonBg1
local c_dragonBg2
local c_dragonBg3
local c_dragonBg4
local c_dragonBg5
local c_dragonBlue0
local c_dragonBlue1
local c_dragonGray0
local c_dragonGray1
local c_dragonGray2
local c_dragonGreen0
local c_dragonGreen1
local c_dragonOrange0
local c_dragonOrange1
local c_dragonPink
local c_dragonRed
local c_dragonTeal
local c_dragonViolet
local c_dragonFg0
local c_dragonFg1
local c_dragonFg2
local c_katanaGray
local c_lotusBlue
local c_lotusGray
local c_lotusRed0
local c_lotusRed1
local c_lotusRed2
local c_roninYellow
local c_springBlue
local c_springGreen
local c_springViolet
local c_sumiInk6
local c_waveAqua0
local c_waveAqua1
local c_waveBlue0
local c_waveBlue1
local c_waveRed
local c_winterBlue
local c_winterBlue1
local c_winterGreen
local c_winterGreen1
local c_winterRed
local c_winterRed1
local c_winterYellow

if vim.go.bg == 'dark' then
  c_autumnGreen   = '#809E74'
  c_autumnRed     = '#EF6C6F'
  c_autumnYellow  = '#dca561'
  c_carpYellow    = '#c8ae81'
  c_dragonAqua    = '#95aeac'
  c_dragonAsh     = '#959795'
  c_dragonBg0     = '#0d0c0c'
  c_dragonBg1     = '#181616'
  c_dragonBg2     = '#201d1d'
  c_dragonBg3     = '#282727'
  c_dragonBg4     = '#393836'
  c_dragonBg5     = '#625e5a'
  c_dragonBlue0   = '#7A9AA9'
  c_dragonBlue1   = '#8ba4b0'
  c_dragonGray0   = '#a6a69c'
  c_dragonGray1   = '#9e9b93'
  c_dragonGray2   = '#8E9796'
  c_dragonGreen0  = '#87a987'
  c_dragonGreen1  = '#9ca98f'
  c_dragonOrange0 = '#b6927b'
  c_dragonOrange1 = '#b98d7b'
  c_dragonPink    = '#a292a3'
  c_dragonRed     = '#D0807A'
  c_dragonTeal    = '#949fb5'
  c_dragonViolet  = '#8C95AA'
  c_dragonFg0     = '#d1d4d1'
  c_dragonFg1     = '#b4b3a7'
  c_dragonFg2     = '#a09f95'
  c_katanaGray    = '#8D9898'
  c_lotusBlue     = '#9fb5c9'
  c_lotusGray     = '#716e61'
  c_lotusRed0     = '#F7676B'
  c_lotusRed1     = '#FF5E5E'
  c_lotusRed2     = '#d9a594'
  c_roninYellow   = '#ff9e3b'
  c_springBlue    = '#7fb4ca'
  c_springGreen   = '#98bb6c'
  c_springViolet  = '#938aa9'
  c_sumiInk6      = '#54546d'
  c_waveAqua0     = '#6a9589'
  c_waveAqua1     = '#7aa89f'
  c_waveBlue0     = '#223249'
  c_waveBlue1     = '#2d4f67'
  c_waveRed       = '#e46876'
  c_winterBlue    = '#252535'
  c_winterBlue1    = '#36364e'
  c_winterGreen   = '#2e322d'
  c_winterGreen1  = '#424841'
  c_winterRed     = '#43242b'
  c_winterRed1    = '#643640'
  c_winterYellow  = '#322e29'
else
  c_autumnGreen   = '#68660A'
  c_autumnRed     = '#B53040'
  c_autumnYellow  = '#875823'
  c_carpYellow    = '#debe97'
  c_dragonAqua    = '#52685C'
  c_dragonAsh     = '#626262'
  c_dragonBg0     = '#f9f9f9'
  c_dragonBg1     = '#ffffff'
  c_dragonBg2     = '#efefef'
  c_dragonBg3     = '#e8e8e8'
  c_dragonBg4     = '#d8d8d8'
  c_dragonBg5     = '#b0b0b0'
  c_dragonBlue0   = '#476776'
  c_dragonBlue1   = '#436778'
  c_dragonGray0   = '#65625C'
  c_dragonGray1   = '#65625D'
  c_dragonGray2   = '#5B6463'
  c_dragonGreen0  = '#87a987'
  c_dragonGreen1  = '#516936'
  c_dragonOrange0 = '#8A5638'
  c_dragonOrange1 = '#825c45'
  c_dragonPink    = '#6E5E6F'
  c_dragonRed     = '#B03932'
  c_dragonTeal    = '#445f96'
  c_dragonViolet  = '#373e50'
  c_dragonFg0     = '#1b1b1b'
  c_dragonFg1     = '#303030'
  c_dragonFg2     = '#636363'
  c_katanaGray    = '#5A6565'
  c_lotusBlue     = '#9fb5c9'
  c_lotusGray     = '#716e61'
  c_lotusRed0     = '#BA2A2E'
  c_lotusRed1     = '#C11D1D'
  c_lotusRed2     = '#d9a594'
  c_roninYellow   = '#c87b2e'
  c_springBlue    = '#7fb4ca'
  c_springGreen   = '#98bb6c'
  c_springViolet  = '#938aa9'
  c_sumiInk6      = '#e0e0ee'
  c_waveAqua0     = '#69827b'
  c_waveAqua1     = '#7aa89f'
  c_waveBlue0     = '#223249'
  c_waveBlue1     = '#2d4f67'
  c_waveRed       = '#e46876'
  c_winterBlue    = '#f2f2fa'
  c_winterBlue1    = '#ceceec'
  c_winterGreen   = '#eaede8'
  c_winterGreen1   = '#d2d8ce'
  c_winterRed     = '#f2e0e3'
  c_winterRed1    = '#e3bcc3'
  c_winterYellow  = '#f0ede9'
end
-- stylua: ignore end
-- }}}

-- Terminal colors {{{
-- stylua: ignore start
if vim.go.bg == 'dark' then
  vim.g.terminal_color_0  = c_dragonBg0
  vim.g.terminal_color_1  = c_dragonRed
  vim.g.terminal_color_2  = c_dragonGreen1
  vim.g.terminal_color_3  = c_carpYellow
  vim.g.terminal_color_4  = c_dragonBlue1
  vim.g.terminal_color_5  = c_dragonPink
  vim.g.terminal_color_6  = c_dragonAqua
  vim.g.terminal_color_7  = c_dragonFg1
  vim.g.terminal_color_8  = c_dragonBg4
  vim.g.terminal_color_9  = c_waveRed
  vim.g.terminal_color_10 = c_dragonGreen0
  vim.g.terminal_color_11 = c_autumnYellow
  vim.g.terminal_color_12 = c_springBlue
  vim.g.terminal_color_13 = c_springViolet
  vim.g.terminal_color_14 = c_waveAqua1
  vim.g.terminal_color_15 = c_dragonFg0
  vim.g.terminal_color_16 = c_dragonOrange0
  vim.g.terminal_color_17 = c_dragonOrange1
else
  vim.g.terminal_color_0  = c_dragonBg1
  vim.g.terminal_color_1  = c_dragonRed
  vim.g.terminal_color_2  = c_dragonGreen1
  vim.g.terminal_color_3  = c_autumnYellow
  vim.g.terminal_color_4  = c_dragonBlue1
  vim.g.terminal_color_5  = c_springViolet
  vim.g.terminal_color_6  = c_dragonAqua
  vim.g.terminal_color_7  = c_dragonBg5
  vim.g.terminal_color_8  = c_dragonBg3
  vim.g.terminal_color_9  = c_waveRed
  vim.g.terminal_color_10 = c_dragonGreen0
  vim.g.terminal_color_11 = c_carpYellow
  vim.g.terminal_color_12 = c_springBlue
  vim.g.terminal_color_13 = c_sumiInk6
  vim.g.terminal_color_14 = c_waveAqua1
  vim.g.terminal_color_15 = c_dragonFg0
  vim.g.terminal_color_16 = c_dragonOrange0
  vim.g.terminal_color_17 = c_dragonOrange1
end
-- stylua: ignore end
--- }}}

-- Highlight groups {{{1
local hlgroups = {
  -- UI {{{2
  ColorColumn = { bg = c_dragonBg2 },
  Conceal = { bold = true, fg = c_dragonGray2 },
  CurSearch = { link = "IncSearch" },
  Cursor = { bg = c_dragonFg0, fg = c_dragonBg1 },
  CursorColumn = { link = "CursorLine" },
  CursorIM = { link = "Cursor" },
  CursorLine = { bg = c_dragonBg2, ctermfg = "White" },
  CursorLineNr = { fg = c_dragonGray0, bg = c_dragonBg2, bold = true },
  DebugPC = { bg = c_winterRed },
  DiffAdd = { bg = c_winterGreen },
  DiffChange = { bg = c_winterBlue },
  DiffDelete = { fg = c_winterRed1, bg = c_winterRed },
  DiffText = { bg = c_sumiInk6 },
  Directory = { fg = c_dragonBlue1 },
  EndOfBuffer = { fg = c_dragonBg1 },
  ErrorMsg = { fg = c_lotusRed1 },
  FloatBorder = { fg = c_dragonBg3, bg = c_dragonBg3 },
  FloatFooter = { bg = c_dragonBg3, fg = c_dragonBg5 },
  FloatTitle = { bg = c_dragonBg3, fg = c_dragonGray2, bold = true },
  FoldColumn = { fg = c_dragonBg5 },
  Folded = { bg = c_winterBlue, fg = c_dragonAsh },
  Ignore = { link = "NonText" },
  IncSearch = { bg = c_carpYellow, fg = c_waveBlue0 },
  LineNr = { fg = c_dragonBg5 },
  MatchParen = { bg = c_dragonBg4 },
  ModeMsg = { fg = c_dragonFg2, bold = true },
  MoreMsg = { fg = c_dragonBlue0 },
  MsgArea = { fg = c_dragonFg1 },
  MsgSeparator = { bg = c_dragonBg1 },
  NonText = { fg = c_dragonBg5 },
  Normal = { bg = c_dragonBg1, fg = c_dragonFg0 },
  NormalFloat = { bg = c_dragonBg3, fg = c_dragonFg1 },
  NormalNC = { link = "Normal" },
  Pmenu = { bg = c_dragonBg3, fg = c_dragonFg1 },
  PmenuSbar = { bg = c_dragonBg4 },
  PmenuSel = { bg = c_dragonBg4, fg = "NONE", bold = true },
  PmenuThumb = { bg = c_dragonBg5 },
  PmenuBorder = { link = "FloatBorder" },
  Question = { link = "MoreMsg" },
  QuickFixLine = { bg = "NONE", bold = true },
  Search = { bg = c_dragonBg4 },
  SignColumn = { fg = c_dragonGray2 },
  SpellBad = { undercurl = true, sp = c_dragonRed },
  SpellCap = { undercurl = true },
  SpellLocal = { undercurl = true },
  SpellRare = { undercurl = true },
  StatusLine = { bg = c_dragonBg3, fg = c_dragonFg1 },
  StatusLineNC = { bg = c_dragonBg3, fg = c_dragonBg5 },
  StatusColumnSeparator = { fg = c_dragonBg3 },
  Substitute = { bg = c_autumnRed, fg = c_dragonFg0 },
  TabLine = { link = "StatusLineNC" },
  TabLineFill = { link = "Normal" },
  TabLineSel = { link = "StatusLine" },
  TermCursor = { fg = c_dragonBg1, bg = c_dragonRed },
  TermCursorNC = { fg = c_dragonBg1, bg = c_dragonAsh },
  Title = { bold = true, fg = c_dragonBlue1 },
  Underlined = { fg = c_dragonTeal, underline = true },
  VertSplit = { link = "WinSeparator" },
  Visual = { bg = c_dragonBg4 },
  VisualNOS = { link = "Visual" },
  WarningMsg = { fg = c_roninYellow },
  Whitespace = { fg = c_dragonBg4 },
  WildMenu = { bg = c_dragonBg4, fg = "NONE" },
  WinBar = { bg = "NONE", fg = c_dragonFg1 },
  WinBarNC = { link = "WinBar" },
  WinSeparator = { fg = c_dragonBg4, bg = c_dragonBg1 },
  lCursor = { link = "Cursor" },
  -- }}}2

  -- Syntax {{{2
  Boolean = { fg = c_dragonOrange0, bold = true },
  Character = { link = "String" },
  Comment = { fg = c_dragonAsh },
  Constant = { fg = c_dragonOrange0 },
  Delimiter = { fg = c_dragonGray1 },
  Error = { fg = c_lotusRed1 },
  Exception = { fg = c_dragonRed },
  Float = { link = "Number" },
  Function = { fg = c_dragonBlue1 },
  Identifier = { fg = c_dragonFg0 },
  Keyword = { fg = c_dragonViolet },
  Number = { fg = c_dragonPink },
  Operator = { fg = c_dragonRed },
  PreProc = { fg = c_dragonRed },
  Include = { link = "PreProc" },
  Special = { fg = c_dragonTeal },
  SpecialKey = { fg = c_dragonGray2 },
  Statement = { fg = c_dragonViolet },
  String = { fg = c_dragonGreen1 },
  Todo = { fg = c_dragonBg0, bg = c_dragonBlue0, bold = true },
  Type = { fg = c_dragonAqua },
  -- }}}2

  -- Treesitter syntax {{{2
  ["@attribute"] = { link = "Constant" },
  ["@constructor"] = { fg = c_dragonTeal },
  ["@constructor.lua"] = { fg = c_dragonViolet },
  ["@keyword.exception"] = { bold = true, fg = c_dragonRed },
  ["@keyword.import"] = { link = "Include" },
  ["@keyword.luap"] = { link = "@string.regexp" },
  ["@keyword.operator"] = { bold = true, fg = c_dragonRed },
  ["@keyword.return"] = { fg = c_dragonRed, italic = true },
  ["@module"] = { fg = c_dragonOrange0 },
  ["@operator"] = { link = "Operator" },
  ["@punctuation.bracket"] = { fg = c_dragonGray1 },
  ["@punctuation.delimiter"] = { fg = c_dragonGray1 },
  ["@markup.list"] = { fg = c_dragonTeal },
  ["@string.escape"] = { fg = c_dragonOrange0 },
  ["@string.regexp"] = { fg = c_dragonOrange0 },
  ["@markup.link.label.symbol"] = { fg = c_dragonFg0 },
  ["@tag.attribute"] = { fg = c_dragonFg0 },
  ["@tag.delimiter"] = { fg = c_dragonGray1 },
  ["@comment.error"] = { bg = c_lotusRed1, fg = c_dragonFg0, bold = true },
  ["@diff.delta"] = { link = "DiffChanged" },
  ["@diff.minus"] = { link = "DiffRemoved" },
  ["@diff.plus"] = { link = "DiffAdded" },
  ["@markup.emphasis"] = { italic = true },
  ["@markup.environment"] = { link = "Keyword" },
  ["@markup.environment.name"] = { link = "String" },
  ["@markup.raw"] = { link = "String" },
  ["@comment.info"] = { bg = c_waveAqua1, fg = c_waveBlue0, bold = true },
  ["@markup.quote"] = { link = "@variable.parameter" },
  ["@markup.strong"] = { bold = true },
  ["@markup.heading"] = { link = "Function" },
  ["@markup.heading.1.markdown"] = { fg = c_dragonRed },
  ["@markup.heading.2.markdown"] = { fg = c_dragonRed },
  ["@markup.heading.3.markdown"] = { fg = c_dragonRed },
  ["@markup.heading.4.markdown"] = { fg = c_dragonRed },
  ["@markup.heading.5.markdown"] = { fg = c_dragonRed },
  ["@markup.heading.6.markdown"] = { fg = c_dragonRed },
  ["@markup.heading.1.marker.markdown"] = { link = "Delimiter" },
  ["@markup.heading.2.marker.markdown"] = { link = "Delimiter" },
  ["@markup.heading.3.marker.markdown"] = { link = "Delimiter" },
  ["@markup.heading.4.marker.markdown"] = { link = "Delimiter" },
  ["@markup.heading.5.marker.markdown"] = { link = "Delimiter" },
  ["@markup.heading.6.marker.markdown"] = { link = "Delimiter" },
  ["@comment.todo.checked"] = { fg = c_dragonAsh },
  ["@comment.todo.unchecked"] = { fg = c_dragonRed },
  ["@markup.link.label.markdown_inline"] = { link = "htmlLink" },
  ["@markup.link.url.markdown_inline"] = { link = "htmlString" },
  ["@comment.warning"] = { bg = c_roninYellow, fg = c_waveBlue0, bold = true },
  ["@variable"] = { fg = c_dragonFg0 },
  ["@variable.builtin"] = { fg = c_dragonRed, italic = true },
  -- }}}

  -- LSP semantic {{{2
  ["@lsp.mod.readonly"] = { link = "Constant" },
  ["@lsp.mod.typeHint"] = { link = "Type" },
  ["@lsp.type.builtinConstant"] = { link = "@constant.builtin" },
  ["@lsp.type.comment"] = { fg = "NONE" },
  ["@lsp.type.macro"] = { fg = c_dragonPink },
  ["@lsp.type.magicFunction"] = { link = "@function.builtin" },
  ["@lsp.type.method"] = { link = "@function.method" },
  ["@lsp.type.namespace"] = { link = "@namespace" },
  ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  ["@lsp.type.selfParameter"] = { link = "@variable.builtin" },
  ["@lsp.type.variable"] = { fg = "NONE" },
  ["@lsp.typemod.function.builtin"] = { link = "@function.builtin" },
  ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.function.readonly"] = { bold = true, fg = c_dragonBlue1 },
  ["@lsp.typemod.keyword.documentation"] = { link = "Special" },
  ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.operator.controlFlow"] = { link = "@keyword.exception" },
  ["@lsp.typemod.operator.injected"] = { link = "Operator" },
  ["@lsp.typemod.string.injected"] = { link = "String" },
  ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
  ["@lsp.typemod.variable.global"] = { link = "Constant" },
  ["@lsp.typemod.variable.injected"] = { link = "@variable" },
  ["@lsp.typemod.variable.static"] = { link = "Constant" },
  -- }}}

  -- LSP {{{2
  LspCodeLens = { fg = c_dragonAsh },
  LspInfoBorder = { link = "FloatBorder" },
  LspReferenceRead = { link = "LspReferenceText" },
  LspReferenceText = { bg = c_winterYellow },
  LspReferenceWrite = { bg = c_winterYellow },
  LspSignatureActiveParameter = { fg = c_roninYellow },
  -- }}}

  -- Diagnostic {{{2
  DiagnosticError = { fg = c_dragonRed },
  DiagnosticHint = { fg = c_dragonAqua },
  DiagnosticInfo = { fg = c_dragonBlue1 },
  DiagnosticOk = { fg = c_dragonGreen1 },
  DiagnosticWarn = { fg = c_carpYellow },
  DiagnosticFloatingError = { fg = c_dragonRed },
  DiagnosticFloatingWarn = { fg = c_carpYellow },
  DiagnosticFloatingInfo = { fg = c_dragonBlue1 },
  DiagnosticFloatingHint = { fg = c_dragonAqua },
  DiagnosticFloatingOk = { fg = c_dragonGreen1 },
  DiagnosticFloatingSuffix = { fg = c_dragonFg2 },
  DiagnosticSignError = { fg = c_dragonRed, bold = true },
  DiagnosticSignHint = { fg = c_dragonAqua, bold = true },
  DiagnosticSignInfo = { fg = c_dragonBlue1, bold = true },
  DiagnosticSignWarn = { fg = c_carpYellow, bold = true },
  DiagnosticUnderlineError = { sp = c_dragonRed, undercurl = true },
  DiagnosticUnderlineHint = { sp = c_dragonAqua, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c_dragonBlue1, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c_carpYellow, undercurl = true },
  DiagnosticVirtualTextError = { bg = c_winterRed, fg = c_dragonRed },
  DiagnosticVirtualTextHint = { bg = c_winterGreen, fg = c_dragonAqua },
  DiagnosticVirtualTextInfo = { bg = c_winterBlue, fg = c_dragonBlue1 },
  DiagnosticVirtualTextWarn = { bg = c_winterYellow, fg = c_carpYellow },
  -- }}}

  -- Filetype {{{2
  -- Git
  gitHash = { fg = c_dragonAsh },

  -- Sh/Bash
  bashSpecialVariables = { link = "Constant" },
  shAstQuote = { link = "Constant" },
  shCaseEsac = { link = "Operator" },
  shDeref = { link = "Special" },
  shDerefSimple = { link = "shDerefVar" },
  shDerefVar = { link = "Constant" },
  shNoQuote = { link = "shAstQuote" },
  shQuote = { link = "String" },
  shTestOpr = { link = "Operator" },

  -- HTML
  htmlBold = { bold = true },
  htmlBoldItalic = { bold = true, italic = true },
  htmlH1 = { fg = c_dragonRed, bold = true },
  htmlH2 = { fg = c_dragonRed, bold = true },
  htmlH3 = { fg = c_dragonRed, bold = true },
  htmlH4 = { fg = c_dragonRed, bold = true },
  htmlH5 = { fg = c_dragonRed, bold = true },
  htmlH6 = { fg = c_dragonRed, bold = true },
  htmlItalic = { italic = true },
  htmlLink = { fg = c_lotusBlue, underline = true },
  htmlSpecialChar = { link = "SpecialChar" },
  htmlSpecialTagName = { fg = c_dragonViolet },
  htmlString = { link = "String" },
  htmlTagName = { link = "Tag" },
  htmlTitle = { link = "Title" },

  -- Markdown
  markdownBold = { bold = true },
  markdownBoldItalic = { bold = true, italic = true },
  markdownCode = { fg = c_dragonGreen1 },
  markdownCodeBlock = { fg = c_dragonGreen1 },
  markdownError = { link = "NONE" },
  markdownEscape = { fg = "NONE" },
  markdownH1 = { link = "htmlH1" },
  markdownH2 = { link = "htmlH2" },
  markdownH3 = { link = "htmlH3" },
  markdownH4 = { link = "htmlH4" },
  markdownH5 = { link = "htmlH5" },
  markdownH6 = { link = "htmlH6" },
  markdownListMarker = { fg = c_autumnYellow },

  -- Checkhealth
  healthError = { fg = c_lotusRed0 },
  healthSuccess = { fg = c_springGreen },
  healthWarning = { fg = c_roninYellow },
  helpHeader = { link = "Title" },
  helpSectionDelim = { link = "Title" },

  -- Qf
  qfFileName = { link = "Directory" },
  qfLineNr = { link = "lineNr" },
  -- }}}

  -- Plugins {{{2
  -- TODO: change to blink
  -- nvim-cmp
  CmpCompletion = { link = "Pmenu" },
  CmpCompletionBorder = { link = "FloatBorder" },
  CmpCompletionSbar = { link = "PmenuSbar" },
  CmpCompletionSel = { bg = c_waveBlue1, fg = "NONE" },
  CmpCompletionThumb = { link = "PmenuThumb" },
  CmpDocumentation = { link = "NormalFloat" },
  CmpDocumentationBorder = { link = "FloatBorder" },
  CmpItemAbbr = { fg = c_dragonFg2 },
  CmpItemAbbrDeprecated = { fg = c_dragonAsh, strikethrough = true },
  CmpItemAbbrMatch = { fg = c_dragonRed },
  CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
  CmpItemKindClass = { link = "Type" },
  CmpItemKindConstant = { link = "Constant" },
  CmpItemKindConstructor = { link = "@constructor" },
  CmpItemKindCopilot = { link = "String" },
  CmpItemKindDefault = { fg = c_katanaGray },
  CmpItemKindEnum = { link = "Type" },
  CmpItemKindEnumMember = { link = "Constant" },
  CmpItemKindField = { link = "@variable.member" },
  CmpItemKindFile = { link = "Directory" },
  CmpItemKindFolder = { link = "Directory" },
  CmpItemKindFunction = { link = "Function" },
  CmpItemKindInterface = { link = "Type" },
  CmpItemKindKeyword = { link = "@keyword" },
  CmpItemKindMethod = { link = "Function" },
  CmpItemKindModule = { link = "@keyword.import" },
  CmpItemKindOperator = { link = "Operator" },
  CmpItemKindProperty = { link = "@property" },
  CmpItemKindReference = { link = "Type" },
  CmpItemKindSnippet = { fg = c_dragonTeal },
  CmpItemKindStruct = { link = "Type" },
  CmpItemKindText = { fg = c_dragonFg2 },
  CmpItemKindTypeParameter = { link = "Type" },
  CmpItemKindValue = { link = "String" },
  CmpItemKindVariable = { fg = c_lotusRed2 },
  CmpItemMenu = { fg = c_dragonAsh },
  CmpGhostText = { link = "NonText" },

  -- gitsigns
  GitSignsAdd = { fg = c_autumnGreen },
  GitSignsChange = { fg = c_carpYellow },
  GitSignsDelete = { fg = c_lotusRed0 },
  GitSignsDeletePreview = { bg = c_winterRed },

  -- fugitive
  DiffAdded = { fg = c_autumnGreen },
  DiffChanged = { fg = c_autumnYellow },
  DiffDeleted = { fg = c_autumnRed },
  DiffNewFile = { fg = c_autumnGreen },
  DiffOldFile = { fg = c_autumnRed },
  DiffRemoved = { fg = c_autumnRed },
  fugitiveHash = { link = "gitHash" },
  fugitiveHeader = { link = "Title" },
  fugitiveStagedModifier = { fg = c_autumnGreen },
  fugitiveUnstagedModifier = { fg = c_autumnYellow },
  fugitiveUntrackedModifier = { fg = c_dragonAqua },

  -- telescope
  TelescopeMatching = { fg = c_dragonRed, bold = true },
  TelescopeNormal = { fg = c_dragonFg2, bg = c_dragonBg3 },
  TelescopePreviewNormal = { bg = c_dragonBg2 },
  TelescopePreviewBorder = { fg = c_dragonBg2, bg = c_dragonBg2 },
  TelescopeBorder = { bg = c_dragonBg3, fg = c_dragonBg3 },
  TelescopePromptNormal = { bg = c_dragonBg3 },
  TelescopePromptBorder = { fg = c_dragonBg3, bg = c_dragonBg3 },
  TelescopeResultsClass = { link = "Structure" },
  TelescopeResultsField = { link = "@keyword.member" },
  TelescopeResultsMethod = { link = "Function" },
  TelescopeResultsStruct = { link = "Structure" },
  TelescopeResultsVariable = { link = "@variable" },
  TelescopeSelection = { link = "CursorLine" },
  TelescopeSelectionCaret = { link = "CursorLineNr" },
  TelescopeTitle = { fg = c_dragonRed },

  IblIndent = { fg = c_dragonBg3 },
  IblScope = { fg = c_dragonBg5 },
  -- IndentBlanklineSpaceChar = { link = "IndentBlanklineChar" },
  -- IndentBlanklineSpaceCharBlankline = { link = "IndentBlanklineChar" },

  MiniIndentscopeSymbol = { link = "IndentBlanklineChar" },

  MiniFilesBorder = { link = "FloatBorder" },
  MiniFilesBorderModified = { link = "FloatBorder" },
  MiniFilesTitleFocused = { fg = c_autumnGreen, bg = c_dragonBg3 },
  MiniFilesTitle = { fg = c_dragonBlue0, bg = c_dragonBg3 },
  MiniFilesNormal = { fg = c_dragonFg0, bg = c_dragonBg3 },
  -- MiniFilesFile = { fg = a.fg, bg = a.float },
  -- MiniFilesDirectory = { fg = b.blue, bg = a.float },
  MiniFilesCursorLine = { link = "PmenuSel" },

  MiniPickBorder = { link = "FloatBorder" },
  MiniPickBorderBusy = { link = "FloatBorder" },
  MiniPickBorderText = { link = "MiniPickHeader" },
  MiniPickHeader = { fg = c_dragonBlue0, bg = c_dragonBg3 },
  MiniPickMatchCurrent = { link = "PmenuSel" },
  MiniPickMatchMarked = { fg = c_dragonTeal },
  MiniPickMatchRanges = { fg = c_dragonRed, bold = true },
  MiniPickNormal = { fg = c_dragonFg1, bg = c_dragonBg3 },
  MiniPickPreviewLine = { fg = c_dragonRed, bg = c_winterRed, bold = true },
  MiniPickPreviewRegion = { fg = c_dragonRed, bg = c_winterRed, bold = true },
  MiniPickPrompt = { bg = c_dragonBg3 },

  MiniClueBorder = { link = "FloatBorder" },
  MiniClueSeparator = { link = "WinSeparator" },
  MiniClueTitle = { link = "MiniFilesTitle" },
  MiniClueDescGroup = { fg = c_dragonTeal },
  WhichKeySeparator = { link = "WinSeparator" },

  -- nvim-dap-ui
  DebugBreakpoint = { fg = c_dragonRed },
  DebugBreakpointLine = { fg = c_dragonRed },
  DebugStopped = { fg = c_carpYellow },
  DebugStoppedLine = { fg = c_carpYellow },
  DebugLogPoint = { fg = c_dragonBlue0 },
  DebugLogPointLine = { fg = c_dragonBlue0 },

  DapUIBreakpointsCurrentLine = { bold = true, fg = c_dragonFg0 },
  DapUIBreakpointsDisabledLine = { link = "Comment" },
  DapUIBreakpointsInfo = { fg = c_dragonBlue0 },
  DapUIBreakpointsPath = { link = "Directory" },
  DapUIDecoration = { fg = c_sumiInk6 },
  DapUIFloatBorder = { link = "FloatBorder" },
  DapUILineNumber = { fg = c_dragonTeal },
  DapUIModifiedValue = { bold = true, fg = c_dragonTeal },
  DapUIPlayPause = { fg = c_dragonGreen1 },
  DapUIRestart = { fg = c_dragonGreen1 },
  DapUIScope = { link = "Special" },
  DapUISource = { fg = c_dragonRed },
  DapUIStepBack = { fg = c_dragonTeal },
  DapUIStepInto = { fg = c_dragonTeal },
  DapUIStepOut = { fg = c_dragonTeal },
  DapUIStepOver = { fg = c_dragonTeal },
  DapUIStop = { fg = c_lotusRed0 },
  DapUIStoppedThread = { fg = c_dragonTeal },
  DapUIThread = { fg = c_dragonFg0 },
  DapUIType = { link = "Type" },
  DapUIUnavailable = { fg = c_dragonAsh },
  DapUIWatchesEmpty = { fg = c_lotusRed0 },
  DapUIWatchesError = { fg = c_lotusRed0 },
  DapUIWatchesValue = { fg = c_dragonFg0 },

  NeotestPassed = { fg = c_dragonGreen1 },
  NeotestRunning = { fg = c_carpYellow },
  NeotestFailed = { fg = c_lotusRed0 },
  NeotestSkipped = { fg = c_roninYellow },
  NeotestNamespace = { link = "Keyword" },
  NeotestFile = { link = "Normal" },
  NeotestDir = { link = "Directory" },
  NeotestIndent = { link = "WinSeparator" },
  NeotestExpandMarker = { link = "NeotestIndent" },
  NeotestWinSelect = { fg = c_dragonBlue0, bold = true },
  NeotestFocused = { bold = true },
  NeotestAdapterName = { fg = c_autumnGreen, bold = true },
  NeotestMarked = { fg = c_dragonBlue0, bold = true },
  NeotestTarget = { fg = c_dragonRed },
  NeotestWatching = { link = "NeotestSkipped" },

  -- lazy.nvimo
  LazyProgressTodo = { fg = c_dragonBg5 },

  RenderMarkdownH1Bg = { link = "markdownH1" },
  RenderMarkdownH2Bg = { link = "markdownH2" },
  RenderMarkdownH3Bg = { link = "markdownH3" },
  RenderMarkdownH4Bg = { link = "markdownH4" },
  RenderMarkdownH5Bg = { link = "markdownH5" },
  RenderMarkdownH6Bg = { link = "markdownH6" },
  RenderMarkdownCode = { bg = c_dragonBg3 },

  ConflictingOursHeader = { bg = c_winterGreen1, fg = c_dragonFg2 },
  ConflictingTheirsHeader = { bg = c_winterBlue1, fg = c_dragonFg2 },
  ConflictingDelimiter = { fg = c_dragonFg2 },

  SiaSplitResponse = { bg = c_winterBlue },
  SiaUser = { bg = c_winterGreen, fg = c_dragonGreen1, bold = true },
  SiaAssistant = { bg = c_winterRed, fg = c_dragonRed, bold = true },
  -- SiaInlineResponse = { bg = c_winterGreen },
  -- SiaInlineReplace = { bg = c_winterRed },
  -- SiaInlineMessage = { fg = c_dragonRed },

  -- -- statusline
  -- StatusLineGitAdded = { bg = c_dragonBg3, fg = c_dragonGreen1 },
  -- StatusLineGitChanged = { bg = c_dragonBg3, fg = c_carpYellow },
  -- StatusLineGitRemoved = { bg = c_dragonBg3, fg = c_dragonRed },
  -- StatusLineHeader = { bg = c_dragonBg5, fg = c_dragonFg1 },
  -- StatusLineHeaderModified = { bg = c_dragonRed, fg = c_dragonBg1 },

  -- -- glance.nvim
  -- GlanceBorderTop = { fg = c_dragonBg3 },
  -- GlanceIndent = { link = "None" },
  -- GlanceListBorderBottom = { link = "GlanceBorderTop" },
  -- GlanceListCount = { bg = c_dragonPink, fg = c_dragonBg1 },
  -- GlanceListCursorLine = { bg = c_dragonBg4 },
  -- GlanceListMatch = { bg = c_dragonBg5 },
  -- GlanceListNormal = { bg = c_dragonBg3, fg = c_dragonFg0 },
  -- GlancePreviewBorderBottom = { link = "GlanceBorderTop" },
  -- GlancePreviewNormal = { bg = c_dragonBg2, fg = c_dragonFg0 },
  -- GlanceWinBarFilename = { bg = c_dragonBg3, fg = c_dragonFg1 },
  -- GlanceWinBarFilepath = { bg = c_dragonBg3, fg = c_dragonAsh },
  -- GlanceWinBarTitle = { bg = c_dragonBg3, fg = c_dragonFg1, bold = true },
  -- }}}
}
-- }}}1

-- Highlight group overrides {{{1
if vim.go.bg == "light" then
  hlgroups.CursorLine = { bg = c_dragonBg0 }
  hlgroups.CursorLineNr = { bg = c_dragonBg0, bold = true }
  hlgroups.QuickFixLine = { bg = "NONE", bold = true }
  hlgroups.FloatBorder = { bg = c_dragonBg0, fg = c_dragonBg0 }
  hlgroups.NormalFloat = { bg = c_dragonBg0 }
  hlgroups.DiagnosticSignWarn = { fg = c_autumnYellow }
  hlgroups.DiagnosticUnderlineWarn = { sp = c_autumnYellow, undercurl = true }
  hlgroups.DiagnosticVirtualTextWarn = { bg = c_winterYellow, fg = c_autumnYellow }
  hlgroups.DiagnosticWarn = { fg = c_autumnYellow }

  hlgroups.TelescopeBorder = { bg = c_dragonBg0, fg = c_dragonBg0 }
  hlgroups.TelescopeMatching = { fg = c_dragonRed, bold = true }
  hlgroups.TelescopeNormal = { fg = c_dragonFg0, bg = c_dragonBg0 }
  hlgroups.TelescopePromptBorder = { fg = c_dragonBg0, bg = c_dragonBg0 }
  hlgroups.TelescopePromptNormal = { bg = c_dragonBg0 }
  hlgroups.TelescopePreviewNormal = { bg = c_dragonBg2 }
  hlgroups.TelescopePreviewBorder = { fg = c_dragonBg2, bg = c_dragonBg2 }

  hlgroups.MiniPickBorder = { bg = c_dragonBg0, fg = c_dragonBg0 }
  hlgroups.MiniPickNormal = { fg = c_dragonFg0, bg = c_dragonBg0 }
  hlgroups.MiniPickPrompt = { bg = c_dragonBg0 }
  hlgroups.MiniPickHeader = { fg = c_dragonBlue0, bg = c_dragonBg0 }
  -- hlgroups.MiniPickMatchCurrent = { bg = c_dragonFg0, fg = c_dragonBg0 }

  hlgroups.MiniFilesTitleFocused = { fg = c_autumnGreen, bg = c_dragonBg0, bold = true }
  hlgroups.MiniFilesTitle = { fg = c_dragonBlue0, bg = c_dragonBg0, bold = true }
  hlgroups.MiniFilesNormal = { fg = c_dragonFg0, bg = c_dragonBg0 }

  hlgroups.RenderMarkdownCode = { bg = c_dragonBg0 }

  hlgroups.IncSearch = { bg = c_autumnYellow, fg = c_dragonBg0, bold = true }
  hlgroups.Keyword = { fg = c_dragonRed }
  hlgroups.ModeMsg = { fg = c_dragonRed, bold = true }
  hlgroups.Pmenu = { bg = c_dragonBg0, fg = c_dragonFg1 }
  hlgroups.PmenuSbar = { bg = c_dragonBg2 }
  hlgroups.PmenuSel = { fg = "NONE", bg = "#f4f4f4", bold = true }
  hlgroups.PmenuThumb = { bg = c_dragonBg4 }
  hlgroups.Search = { bg = c_dragonBg3 }
  hlgroups.StatusLine = { bg = c_dragonBg0 }
  hlgroups.Visual = { bg = c_dragonBg3 }
  hlgroups["@variable.parameter"] = { link = "Identifier" }
end
-- }}}1

-- Set highlight groups {{{1
for hlgroup_name, hlgroup_attr in pairs(hlgroups) do
  vim.api.nvim_set_hl(0, hlgroup_name, hlgroup_attr)
end
-- }}}1

-- vim:ts=2:sw=2:sts=2:fdm=marker:fdl=0
