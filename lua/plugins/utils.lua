return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "v" }, "<A-k>", function()
        mc.lineAddCursor(-1)
      end)
      set({ "n", "v" }, "<A-j>", function()
        mc.lineAddCursor(1)
      end)
      set({ "n", "v" }, "<S-A-k>", function()
        mc.lineSkipCursor(-1)
      end)
      set({ "n", "v" }, "<S-A-j>", function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "v" }, "<A-d>", function()
        mc.matchAddCursor(1)
      end)
      set({ "n", "v" }, "<A-s>", function()
        mc.matchSkipCursor(1)
      end)
      set({ "n", "v" }, "<S-A-d>", function()
        mc.matchAddCursor(-1)
      end)
      set({ "n", "v" }, "<S-A-s>", function()
        mc.matchSkipCursor(-1)
      end)

      -- Add all matches in the document
      -- set({ "n", "v" }, "<leader>A", mc.matchAllAddCursors)

      -- You can also add cursors with any motion you prefer:
      -- set("n", "<right>", function()
      --     mc.addCursor("w")
      -- end)
      -- set("n", "<leader><right>", function()
      --     mc.skipCursor("w")
      -- end)

      -- Rotate the main cursor.
      set({ "n", "v" }, "<A-h>", mc.nextCursor)
      set({ "n", "v" }, "<A-l>", mc.prevCursor)

      -- Delete the main cursor.
      set({ "n", "v" }, "<A-x>", mc.deleteCursor)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)

      -- Easy way to add and remove cursors using the main cursor.
      set({ "n", "v" }, "<A-q>", mc.toggleCursor)

      -- Clone every cursor and disable the originals.
      set({ "n", "v" }, "<S-A-q>", mc.duplicateCursors)

      set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      -- bring back cursors if you accidentally clear them
      set("n", "<leader>gv", mc.restoreCursors)

      -- Align cursor columns.
      set("n", "<leader>a", mc.alignCursors)

      -- Split visual selections by regex.
      set("v", "S", mc.splitCursors)

      -- -- Append/insert for each line of visual selections.
      -- set("v", "I", mc.insertVisual)
      -- set("v", "A", mc.appendVisual)

      -- match new cursors within visual selections by regex.
      set("v", "M", mc.matchCursors)

      -- Rotate visual selection contents.
      set("v", "<A-t>", function()
        mc.transposeCursors(1)
      end)
      set("v", "<S-A-t>", function()
        mc.transposeCursors(-1)
      end)

      -- Jumplist support
      set({ "v", "n" }, "<c-i>", mc.jumpForward)
      set({ "v", "n" }, "<c-o>", mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "isaksamsten/melange-nvim",
    -- dir = "~/Projects/melange-nvim/",
    -- name = "melange-nvim",
    config = function()
      vim.g.melange_enable_font_variants = {
        bold = true,
        italic = false,
        underline = true,
        undercurl = true,
        strikethrough = true,
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
  },
  {
    "isaksamsten/conflicting.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "ct",
        mode = "n",
        function()
          require("conflicting").accept_incoming()
        end,
        desc = "Accept change",
      },
      {
        "co",
        mode = "n",
        function()
          require("conflicting").accept_current()
        end,
        desc = "Accept change",
      },
      {
        "cd",
        mode = "n",
        function()
          require("conflicting").diff()
        end,
        desc = "Diff change",
      },
    },
    opts = {},
  },
  {
    -- dir = "~/Projects/sia.nvim/",
    -- name = "Sia",
    "isaksamsten/sia.nvim",
    keys = {
      { "<LocalLeader><cr>", mode = { "v", "n" }, ":Sia<cr>", desc = ":Sia" },
      { "gzt", mode = "n", "<Plug>(sia-toggle)", desc = "Toggle last Sia buffer" },
      { "gza", mode = { "n", "x" }, "<Plug>(sia-add-context)", desc = "Add context" },
      { "gzz", mode = { "n", "x" }, "<Plug>(sia-execute)", desc = "Invoke default prompt" },
      { "gze", mode = { "n", "x" }, "<Plug>(sia-execute-explain)", desc = "Explain code" },
      { "gzg", mode = { "n", "x" }, "<Plug>(sia-execute-grammar)", desc = "Check grammar" },
      { "gzr", mode = { "n", "x" }, "<Plug>(sia-execute-rephrase)", desc = "Rephrase text" },
      { "s", mode = "n", "<Plug>(sia-show-context)", ft = "sia" },
      { "p", mode = "n", "<Plug>(sia-peek-context)", ft = "sia" },
      { "x", mode = "n", "<Plug>(sia-delete-context)", ft = "sia" },
      { "r", mode = "n", "<Plug>(sia-replace-block)", ft = "sia" },
      { "R", mode = "n", "<Plug>(sia-replace-all-blocks)", ft = "sia" },
      { "a", mode = "n", "<Plug>(sia-insert-block-above)", ft = "sia" },
      { "b", mode = "n", "<Plug>(sia-insert-block-below)", ft = "sia" },
      { "<CR>", mode = "n", "<Plug>(sia-reply)", ft = "sia" },
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
    cmd = { "SiaFile", "Sia" },
    opts = function()
      return {
        --- @type table<string, sia.config.Action>
        actions = {
          references = {
            instructions = {
              {
                role = "system",
                content = [[You are a research assistant specialized in querying scientific literature databases. Your task is to assist the user by searching for genuine, high-quality academic papers, summarizing their abstracts, and ranking them based on relevance to the user’s query. You must never fabricate or invent references. Instead, you rely solely on the results provided by the search_research_paper function to generate your outputs.

Your Responsibilities:

1. Generate Accurate Search Queries: Based on the user’s input, carefully craft a query that accurately targets the key concepts, topics, or research areas of interest. Use specific terms, relevant keywords, and synonyms to ensure the search retrieves the most appropriate literature.
2. Retrieve Genuine Papers: You will use the function search_research_paper to retrieve a list of scientific papers from real databases. You must only use the papers returned from this function for your summaries and references.
3. Summarize Abstracts: For each retrieved paper, provide a concise and accurate summary of the abstract, focusing on:
  *	The research objective
  *	Key methods used
  *	Significant findings
  *	Implications of the research
4. Rank the References: Rank the papers based on:
  *	Relevance to the user’s query
  *	The quality of the research (e.g., journal quality, recency, citation count)
  *	The depth of information related to the user’s needs
5. Provide a Clear List of References: Present the references in a structured format that includes:
  *	Title of the paper
  *	Authors
  *	Publication year
  *	Journal name
  *	The concise abstract summary

Important Rules:

*	Never fabricate or invent references. Every reference must be retrieved through the search_research_paper function.
*	Ensure transparency and accuracy in the summaries and rankings.
*	Tailor your search queries and paper selection to meet the user’s specific needs and focus areas.]],
              },
              require("sia.instructions").verbatim(),
            },
            tools = {
              {
                name = "search_research_paper",
                description = "Search for research articles using free text queries",
                required = { "query" },
                parameters = {
                  query = {
                    type = "string",
                    description = "Free text query use space to separate words.",
                  },
                  yearPublished = {
                    type = "string",
                    description = "Expressed as a range [start_year]-, -[end_year], [exact_year], [start_year]-[end_year]",
                  },
                },
                execute = function(args, _, callback)
                  if args.query then
                    local query = args.query
                    if args.yearPublished and args.yearPublished ~= "" then
                      local function parse_year(years)
                        years = string.gsub(years, " ", "")
                        local only_from = string.match(years, "^(%d+)-$")
                        if only_from then
                          return "yearPublished >= " .. only_from
                        end
                        local only_to = string.match(years, "^-(%d+)$")
                        if only_to then
                          return "yearPublished <= " .. only_to
                        end
                        local exact = string.match(years, "^(%d+)$")
                        if exact then
                          return "yearPublished == " .. exact
                        end
                        local from, to = string.match(years, "^(%d+)-(%d+)$")
                        if from and to then
                          return "yearPublished >= " .. from .. " AND yearPublished <= " .. to
                        end

                        return nil
                      end
                      local year_query = parse_year(args.yearPublished)
                      if year_query then
                        query = query .. " AND " .. year_query
                      end
                    end

                    local encoded_query = require("sia.utils").urlencode(query)
                    local url = string.format("https://api.core.ac.uk/v3/search/works/?q=%s&limit=5", encoded_query)
                    local command = {
                      "curl",
                    }
                    local api_key = vim.fn.shellescape(vim.env["CORE_API_KEY"])
                    if api_key then
                      table.insert(command, "-H")
                      table.insert(command, "Authentication: Bearer " .. api_key)
                    end
                    table.insert(command, url)

                    vim.system(command, { text = true }, function(res, _)
                      if res.code == 0 then
                        local status, json = pcall(vim.json.decode, res.stdout, { luanil = { object = true } })
                        if status and json.totalHits > 0 then
                          local messages = { "## " .. query, "" }
                          for _, item in ipairs(json.results) do
                            local doi = item.doi
                            local arxiv = item.arxivId
                            local title = string.gsub(item.title, "\n", " "):gsub("%s+", " ")
                            table.insert(messages, "### " .. title)
                            local authors = {}
                            if item.authors then
                              for _, author in ipairs(item.authors) do
                                local name = string.gsub(author.name, "\n", " ")
                                table.insert(authors, name)
                              end
                            end
                            table.insert(messages, " - **authors:** " .. table.concat(authors or {}, ", "))
                            table.insert(messages, " - **year:** " .. (item.yearPublished or "unknown"))
                            if doi then
                              table.insert(messages, " - **doi:** " .. doi)
                            end
                            if arxiv then
                              table.insert(messages, " - **arxiv:** " .. arxiv)
                            end
                            if item.abstract then
                              table.insert(messages, "#### Abstract")
                              local abstract = string.gsub(item.abstract, "\n", " ")
                              abstract = string.gsub(abstract, "%s+", " ")
                              table.insert(messages, abstract)
                            end
                            table.insert(messages, "")
                          end
                          callback(messages)
                        else
                          callback({ "No research papers found. Please expand your search." })
                        end
                      else
                        callback({ "Failed to search for research papers." })
                      end
                    end)
                  end
                end,
              },
            },
            mode = "split",
            temperature = 0.5,
          },
          write = {
            instructions = {
              {
                role = "system",
                content = [[You are a language model designed to assist researchers in refining scientific texts. You have access to a function called search_research_paper which allows you to retrieve relevant academic papers to improve the accuracy, depth, and clarity of scientific content. Your task is to:

1. Analyze the user’s scientific text for potential improvements in argumentation, references, or clarity.
2. When necessary, call the `search_research_paper` function to retrieve academic papers that provide supporting evidence, clarify concepts, or suggest alternative interpretations.
3. Use the information from the retrieved papers to:
  -	Suggest improvements to the text.
  -	Recommend additional citations or references to increase the credibility of the work.
  -	Correct any inaccuracies or misleading statements.
  - Provide alternative interpretations or perspectives.
  - Expand on the existing arguments with additional evidence or data.
4. Ensure that your suggestions maintain the formal tone and style expected in scientific writing.
5. Do not fabricate data or references.
6. When adding references, make sure to use correct citation tags for latex e.g., \cite{author_year}.
7. If adding new references, provide a code block with BibTex formatted references.

Make sure your suggestions help elevate the scientific rigor and presentation of the work.
]],
              },
              "current_context",
            },
            tools = {
              require("sia.tools").search_research_paper,
            },
            mode = "split",
            temperature = 0.2,
          },
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
      vim.api.nvim_create_autocmd("User", {
        pattern = "SiaEditPost",
        callback = function(args)
          require("conflicting").track(args.data.buf)
        end,
      })
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "sia",
      --   callback = function(ev)
      --     vim.cmd("setlocal nonumber")
      --     -- vim.wo.number = false
      --   end,
      -- })
    end,
  },
  -- {
  --   "mrjones2014/smart-splits.nvim",
  --   version = false,
  --   build = "./kitty/install-kittens.bash",
  --   cond = vim.env.KITTY_PID ~= nil or vim.env.TMUX ~= nil,
  --   event = "VeryLazy",
  --   config = function(_, opts)
  --     require("smart-splits").setup(opts)
  --     -- vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
  --     -- vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
  --     -- vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
  --     -- vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
  --     -- moving between splits
  --     vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
  --     vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
  --     vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
  --     vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
  --     vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
  --     -- swapping buffers between windows
  --     -- vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
  --     -- vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
  --     -- vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
  --     -- vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
  --   end,
  -- },
  {
    "alexghergh/nvim-tmux-navigation",
    -- enabled = false,
    cond = vim.env.TMUX ~= nil,
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
