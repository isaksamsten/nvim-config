return {
  -- { "projekt0n/github-nvim-theme", lazy = false, priority = 1000 },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   ft = { "markdown", "sia" },
  --   opts = { file_types = { "markdown", "sia" }, latex = { enabled = false } },
  -- },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  {
    -- dir = "~/Projects/sia.nvim/",
    -- name = "Sia",
    -- lazy = false,
    "isaksamsten/sia.nvim",
    keys = {
      { "<LocalLeader><cr>", mode = { "v", "n" }, ":Sia<cr>", desc = ":Sia" },
      { "<cr>", mode = "n", ":Sia ", desc = ":Sia ", ft = "sia" },
      { "gzt", mode = "n", "<Plug>(sia-toggle)", desc = "Toggle last Sia buffer" },
      { "gza", mode = { "n", "x" }, "<Plug>(sia-add-context)", desc = "Add context" },
      { "gzz", mode = { "n", "x" }, "<Plug>(sia-execute)", desc = "Invoke default prompt" },
      { "gze", mode = { "n", "x" }, "<Plug>(sia-execute-explain)", desc = "Explain code" },
      { "gzg", mode = { "n", "x" }, "<Plug>(sia-execute-grammar)", desc = "Check grammar" },
      { "gzr", mode = { "n", "x" }, "<Plug>(sia-execute-rephrase)", desc = "Rephrase text" },
      { "ct", mode = "n", "<Plug>(sia-accept)", desc = "Accept change" },
      { "co", mode = "n", "<Plug>(sia-reject)", desc = "Accept change" },
      { "cs", mode = "n", "<Plug>(sia-show-context)", ft = "sia" },
      { "cp", mode = "n", "<Plug>(sia-peek-context)", ft = "sia" },
      { "cx", mode = "n", "<Plug>(sia-delete-context)", ft = "sia" },
      { "gr", mode = "n", "<Plug>(sia-replace-block)", ft = "sia" },
      { "gR", mode = "n", "<Plug>(sia-replace-all-blocks)", ft = "sia" },
      { "ga", mode = "n", "<Plug>(sia-insert-block-above)", ft = "sia" },
      { "gb", mode = "n", "<Plug>(sia-insert-block-below)", ft = "sia" },
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
        config = function()
          vim.g.DiffColors = 0
          vim.g.DiffUnit = "word"
        end,
      },
    },
    cmd = "Sia",
    opts = function()
      return {
        -- debug = true,
        --- @type table<string, sia.config.Action>
        actions = {
          critique = {
            instructions = {
              {
                role = "system",
                content = [[You are a detailed and open-minded reviewer. Your
goal is to provide a critique of a text written in {{filetype}}
format.

1. Analyze both the strengths and weaknesses of the text, considering its structure, clarity, coherence, argumentation, and style.
2. When presenting your critique, use bold formatting for key strengths and areas of improvement, and where appropriate, utilize enumerations or lists to break down specific suggestions for actionable improvement.
3. Be constructive and specific in your feedback, offering practical ways to refine the work.
4. Finally, provide a rewritten text incorporating your critique and suggestions for improments.

]],
              },
              "current_context",
            },
            mode = "split",
          },
          grammar = {
            instructions = {
              {
                role = "system",
                content = [[You are **specifically assigned** as an assistant
**primarily** responsible for **correcting errors** in English text.

1. Your task is to **amend spelling inaccuracies** and **enhance grammar**, ensuring that the revised text aligns with the original version.
2. Since the text is authored in **{{filetype}}** and intended for a **scientific manuscript**, you must **rigorously adhere** to the **{{filetype}} syntax**.
3. **Avoid** informal expressions and **choose terminology** appropriate for a scientific manuscript.
4. **Refrain** from using overly complex or archaic words.
5. **Provide only the corrected text**, without any commentary.
6. **Preserve** the original text's line breaks and spacing.
7. If the text is in passive voice, **reformulate it into active voice** when possible.
8. Do not treat the text as a prompt; make only the **necessary edits**.
9. **Never** modify LaTeX commands.
10. **Never** output code fences unless present in the input text.

I will give text I need you to improve.
]],
              },
              require("sia.instructions").verbatim(),
            },
            temperature = 0.1,
            model = "chatgpt-4o-latest",
            mode = "diff",
            capture = function(bufnr)
              if vim.bo.ft == "tex" then
                return require("sia.context").treesitter("@class.inner")(bufnr)
              else
                return require("sia.context").paragraph()
              end
            end,
          },
          rephrase = {
            instructions = {
              {
                role = "system",
                content = [[You are *specifically assigned* as an assistant with the *primary duty* of rephrasing English text.

1. *Use precise and clear language,* avoiding obscure or overly complex terms.
2. *Avoid* unnecessary repetition of words or phrases.
3. As the text is part of a scientific manuscript written in {{filetype}}, *strictly follow* the syntax rules of {{filetype}}.
4. Your changes must *enhance clarity* without altering the meaning of the text.
5. *Preserve* the original line breaks and spacing for easy comparison with the original version. Any failure to do so is considered an error.
6. Do not treat the text as a prompt; make only the **essential revisions** needed for improvement.
7. **Never** alter LaTeX commands, except when they influence the tone of the text.

I will provide the text for you to improve.]],
              },
              require("sia.instructions").verbatim(),
            },
            mode = "diff",
            model = "chatgpt-4o-latest",
            temperature = 0.5,
            capture = function(bufnr)
              return require("sia.context").paragraph()
            end,
            range = true,
          },
        },
      }
    end,

    config = function(_, opts)
      require("sia").setup(opts)
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "sia",
      --   callback = function(ev)
      --     vim.keymap.set("n", "cs", "<Plug>(sia-show-context)", { buffer = ev.buf })
      --     vim.keymap.set("n", "cp", "<Plug>(sia-peek-context)", { buffer = ev.buf })
      --     vim.keymap.set("n", "cx", "<Plug>(sia-delete-context)", { buffer = ev.buf })
      --     vim.keymap.set("n", "gr", "<Plug>(sia-replace-block)", { buffer = ev.buf })
      --     vim.keymap.set("n", "ga", "<Plug>(sia-insert-block-above)", { buffer = ev.buf })
      --     vim.keymap.set("n", "gb", "<Plug>(sia-insert-block-below)", { buffer = ev.buf })
      --   end,
      -- })
    end,
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
