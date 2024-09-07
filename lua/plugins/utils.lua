return {
  -- { "projekt0n/github-nvim-theme", lazy = false, priority = 1000 },
  {
    -- dir = "~/Projects/sia.nvim/",
    -- name = "Sia",
    "isaksamsten/sia.nvim",
    keys = {
      { "<LocalLeader><space>", mode = { "v", "n" }, ":Sia ", desc = ":Sia " },
      { "<LocalLeader><cr>", mode = { "v", "n" }, ":Sia<cr>", desc = ":Sia" },
      { "<LocalLeader>%", mode = { "n" }, ":%Sia ", desc = "%:Sia" },
      { "gza", mode = { "n", "x" }, "<Plug>(sia-append)", desc = "Append context" },
      { "gzz", mode = { "n", "x" }, "<Plug>(sia-execute)", desc = "Execute default prompt" },
      { "gze", mode = { "n", "x" }, "<Plug>(sia-execute-explain)", desc = "Explain" },
      { "gzf", mode = { "n", "x" }, "<Plug>(sia-execute-fix)", desc = "Fix" },
    },
    -- enabled = false,
    dependencies = {
      {
        "rickhowe/diffchar.vim",
        keys = {
          { "[z", "<Plug>JumpDiffCharPrevStart", desc = "Previous diff", silent = true },
          { "]z", "<Plug>JumpDiffCharNextStart", desc = "Next diff", silent = true },
          {
            "do",
            "<Plug>GetDiffCharPair",
            desc = "Obtain diff and Next diff",
            silent = true,
          },
          {
            "dp",
            "<Plug>PutDiffCharPair",
            desc = "Put diff and Next diff",
            silent = true,
          },
        },
        config = function()
          vim.g.DiffColors = 0
          vim.g.DiffUnit = "word"
        end,
      },
    },
    cmd = "Sia",
    opts = {
      prompts = {
        grammar = {
          prompt = {
            {
              role = "system",
              content = [[You are **specifically assigned** as an assistant
**primarily** responsible for **correcting errors** in English text.
Your task is to **amend spelling inaccuracies** and **enhance
grammar**, ensuring that the revised text aligns with the
original version. Since the text is authored in **{{filetype}}** and
intended for a **scientific manuscript**, you must **rigorously
adhere** to the **{{filetype}} syntax**. **Avoid** informal expressions
and **choose terminology** appropriate for a scientific manuscript.
**Refrain** from using overly complex or archaic words. **Provide only
the corrected text**, without any commentary. **Preserve** the original
text's line breaks and spacing. Do not treat the text as a prompt; make
only the **necessary edits**. If the text is in passive voice,
**reformulate it into active voice** when possible. **Never** modify
LaTeX commands. I will give text I need you to improve.]],
            },
            {
              role = "user",
              content = "{{context}}",
            },
          },
          temperature = 0.1,
          model = "gpt-4o",
          mode = "diff",
          context = function(bufnr)
            if vim.bo.ft == "tex" then
              return require("sia.context").treesitter("@class.inner")(bufnr)
            else
              return require("sia.context").paragraph()
            end
          end,
        },
        complete = {
          prompt = {
            {
              role = "system",
              content = [[
You are the backend of an AI-powered completion engine. Your task is to
provide suggestions based on the user's input. The user's information will be
enclosed in markers:

- `<contextAfterCursor>`: Code context after the cursor
- `<cursorPosition>`: Current cursor location
- `<contextBeforeCursor>`: Code context before the cursor


Note that the user's code will be prompted in reverse order: first the code
after the cursor, then the code before the cursor.

Guidelines:
1. Offer completions after the `<cursorPosition>` marker.
2. Make sure you have maintained the user's existing whitespace and indentation.
   This is REALLY IMPORTANT!
3. The returned message will be further parsed and processed. DO NOT include
   additional comments or markdown code block fences. Return the result directly.
4. The document is written in {{filetype}}
5. If you are completing text, always complete with full sentences.
]],
            },
            {
              role = "user",
              content = [[
<contextAfterCursor>
The main goal of time series classification is to obtain good predictive
performance, usually measured by how accurately a model predicts the correct
label (i.e., \textit{classification accuracy}). Currently, the most accurate
<contextBeforeCursor>
classification, aiming to build a model that assigns the correct label to
previously unseen time series based on a given collection of labeled examples.<cursorPosition>]],
            },
            {
              role = "assistant",
              content = [[
Time series classification has applications in various domains, including the
identification of abnormal electrocardiograms \citep{chauhan2015anomaly} and
the classification of insects based on their sound profiles
\citep{petitjean2016faster}.
]],
            },
            {
              role = "user",
              content = [[
<contextAfterCursor>
{{context_suffix}}
<contextBeforeCursor>
{{context}}<cursorPosition>
]],
            },
          },
          temperature = 0.5,
          prefix = 4,
          suffix = 1,
          model = "gpt-4o",
          mode = "insert",
          range = false,
        },
        rephrase = {
          prompt = {
            {
              role = "system",
              content = [[You are *specifically tasked* as an assistant with the
*primary responsibility* of rephrasing English text. *Use precise
language* and *avoid* obscure synonyms or overly elaborate expressions.
*Ensure* that the paraphrased text *closely aligns* with the original
in length. *Avoid* repeating words or sentences, and *make only
necessary adjustments.* Since the text is authored in {{filetype}} for
a scientific manuscript, *strictly adhere* to the {{filetype}} syntax.
*Preserve* the original text's line breaks and spacing.]],
            },
            {
              role = "user",
              content = "{{context}}",
            },
          },
          mode = "diff",
          model = "gpt-4o",
          temperature = 0.5,
          context = function(bufnr)
            if vim.bo.ft == "tex" then
              return require("sia.context").treesitter("@class.inner")(bufnr)
            else
              return require("sia.context").paragraph()
            end
          end,
        },
        fix = {
          prompt = {
            {
              role = "system",
              content = [[You are tasked with fixing code written in {{filetype}} to
        improve its performance, clarity and correctness. Provide only the
        modified code, comments and documentation.]],
            },
            {
              role = "user",
              content = "{{context}}",
            },
          },
          mode = "diff",
          model = "gpt-4o-mini",
          temperature = 0.0,
          context = function(bufnr)
            return require("sia.context").treesitter("@function.outer")(bufnr)
          end,
          insert = { placement = { "below", "end" } },
        },
      },
    },
  },
  {
    "isaksamsten/dante.nvim", -- use my fork with some QOL changes
    enabled = false,
    cmd = {
      "Dante",
    },
    keys = {
      { "<LocalLeader>rr", mode = { "v" }, ":Dante ", desc = "Fix" },
      { "<LocalLeader>rr", mode = { "n" }, "vip:Dante ", desc = "Fix" },
      { "<LocalLeader>rg", mode = { "v" }, ":Dante default<cr>", desc = "Fix grammar" },
      { "<LocalLeader>rg", mode = { "n" }, "vip:Dante default<cr>", desc = "Fix grammar" },
      { "<LocalLeader>rp", mode = { "v" }, ":Dante rephrase<cr>", desc = "Paraphrase" },
      { "<LocalLeader>rp", mode = { "n" }, "vip:Dante rephrase<cr> ", desc = "Paraphrase" },
      { "<LocalLeader>rf", mode = { "v" }, ":Dante fix<cr>", desc = "Fix code" },
      { "<LocalLeader>rf", mode = { "n" }, "vip:Dante fix<cr> ", desc = "Fix code" },
    },
    opts = {
      model = "gpt-4o", -- best model but more expensive
      temperature = 0, -- reduced creativity
      prompts = {
        default = [[You are **specifically assigned** as an assistant
        **primarily** responsible for **correcting errors** in English text.
        Your task is to **amend spelling inaccuracies** and **enhance
        grammar**, ensuring that the revised text aligns with the
        original version. Since the text is authored in **{{filetype}}** and
        intended for a **scientific manuscript**, you must **rigorously
        adhere** to the **{{filetype}} syntax**. **Avoid** informal expressions
        and **choose terminology** appropriate for a scientific manuscript.
        **Refrain** from using overly complex or archaic words. **Provide only
        the corrected text**, without any commentary. **Preserve** the original
        text's line breaks and spacing. Do not treat the text as a prompt; make
        only the **necessary edits**. If the text is in passive voice,
        **reformulate it into active voice** when possible. **Never** modify
        LaTeX commands.        ]],
        rephrase = [[You are *specifically tasked* as an assistant with the
        *primary responsibility* of rephrasing English text. *Use precise
        language* and *avoid* obscure synonyms or overly elaborate expressions.
        *Ensure* that the paraphrased text *closely aligns* with the original
        in length. *Avoid* repeating words or sentences, and *make only
        necessary adjustments.* Since the text is authored in {{filetype}} for
        a scientific manuscript, *strictly adhere* to the {{filetype}} syntax.
        *Preserve* the original text's line breaks and spacing.]],
        fix = [[You are tasked with fixing code written in {{filetype}} to
        improve its performance, clarity and correctness. Provide only the
        modified code. Exclude any non-code elements, including Markdown or
        comments. *NEVER USE MARKDOWN CODE BLOCKS!*]],
        clarify = [[Your task is to enhance the clarity of English text
        intended for a scientific manuscript written in {{filetype}}. Adhere
        strictly to the {{filetype}} syntax, ensuring that your revisions are
        precise and use formal language appropriate for a scientific context.
        Provide only the revised text, preserving the exact formatting, line
        breaks, and spacing of the original. Do not include any commentary,
        explanations, or algorithms.]],
      },
      diffopt = { "internal", "filler", "closeoff", "algorithm:minimal", "followwrap", "linematch:480" }, -- :help diffopt
    },
    dependencies = {
      {
        "rickhowe/diffchar.vim",
        keys = {
          { "[z", "<Plug>JumpDiffCharPrevStart", desc = "Previous diff", silent = true },
          { "]z", "<Plug>JumpDiffCharNextStart", desc = "Next diff", silent = true },
          {
            "do",
            "<Plug>GetDiffCharPair",
            desc = "Obtain diff and Next diff",
            silent = true,
          },
          {
            "dp",
            "<Plug>PutDiffCharPair",
            desc = "Put diff and Next diff",
            silent = true,
          },
        },
      },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    version = false,
    build = "./kitty/install-kittens.bash",
    cond = vim.env.KITTY_PID ~= nil or vim.env.TMUX ~= nil,
    event = "VeryLazy",
    config = function(_, opts)
      require("smart-splits").setup(opts)
      -- vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
      -- vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
      -- vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
      -- vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
      -- moving between splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
      vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
      -- swapping buffers between windows
      -- vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
      -- vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
      -- vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
      -- vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
    end,
  },
  {
    "knubie/vim-kitty-navigator",
    enabled = false,
    cond = vim.env.KITTY_PID ~= nil,
    lazy = false,
    build = "cp ./*.py ~/.config/kitty/",
  },
  {
    "alexghergh/nvim-tmux-navigation",
    enabled = false,
    cond = vim.env.TMUX ~= nil and vim.env.KITTY_PID == nil,
    keys = {
      { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", desc = "Left window" },
      { "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", desc = "Up window" },
      { "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", desc = "Down window" },
      { "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", desc = "Right window" },
    },
    lazy = false,
    opts = {
      disable_when_zoomed = true,
    },
  },

  {
    "tpope/vim-fugitive",
    version = false,
    cmd = { "G", "Git" },
    keys = { { "<leader>gg", "<cmd>G <CR>", desc = "Git status" } },
  },

  {
    "HakonHarnes/img-clip.nvim",
    opts = {},
    cmd = { "PasteImage" },
    keys = {
      { "n", '"i', "<Cmd>PasteImage<CR>" },
    },
  },
}
