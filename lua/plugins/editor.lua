return { -- TODO
  { "romainl/vim-cool", event = { "BufReadPre", "BufNewFile" } },
  {
    "echasnovski/mini.comment",
    version = false,
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
  {
    "idanarye/nvim-impairative",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local impairative = require("impairative")

      impairative
        .toggling({
          enable = "[o",
          disable = "]o",
          toggle = "yo",
          show_message = false,
        })
        :option({
          key = "b",
          option = "background",
          values = { [true] = "light", [false] = "dark" },
        })
        :option({
          key = "c",
          option = "cursorline",
        })
        :getter_setter({
          key = "d",
          name = "diff mode",
          get = function()
            return vim.o.diff
          end,
          set = function(value)
            if value then
              vim.cmd.diffthis()
            else
              vim.cmd.diffoff()
            end
          end,
          messages = { [true] = ":diffthis", [false] = ":diffoff" },
        })
        :option({
          key = "h",
          option = "hlsearch",
        })
        :option({
          key = "i",
          option = "ignorecase",
        })
        :option({
          key = "l",
          option = "list",
        })
        :option({
          key = "n",
          option = "number",
        })
        :option({
          key = "r",
          option = "relativenumber",
        })
        :option({
          key = "s",
          option = "spell",
        })
        :option({
          key = "t",
          option = "colorcolumn",
          values = { [true] = "+1", [false] = "" },
        })
        :option({
          key = "u",
          option = "cursorcolumn",
        })
        :option({
          key = "v",
          option = "virtualedit",
          values = { [true] = "all", [false] = "" },
        })
        :option({
          key = "w",
          option = "wrap",
        })
        :getter_setter({
          key = "x",
          name = "Vim's 'cursorline' and 'cursorcolumn' options both",
          get = function()
            return vim.o.cursorline and vim.o.cursorcolumn
          end,
          set = function(value)
            vim.o.cursorline = value
            vim.o.cursorcolumn = value
          end,
          messages = { [true] = ":set cursorline cursorcolumn", [false] = ":set nocursorline nocursorcolumn" },
        })

      impairative
        .operations({
          backward = "[",
          forward = "]",
        })
        :command_pair({
          key = "a",
          backward = "previous",
          forward = "next",
        })
        :command_pair({
          key = "A",
          backward = "first",
          forward = "last",
        })
        :command_pair({
          key = "b",
          backward = "bprevious",
          forward = "bnext",
        })
        :command_pair({
          key = "B",
          backward = "bfirst",
          forward = "blast",
        })
        :command_pair({
          key = "l",
          backward = "lprevious",
          forward = "lnext",
        })
        :command_pair({
          key = "L",
          backward = "lfirst",
          forward = "llast",
        })
        :command_pair({
          key = "<C-l>",
          backward = "lpfile",
          forward = "lnfile",
        })
        :command_pair({
          key = "q",
          backward = "cprevious",
          forward = "cnext",
        })
        :command_pair({
          key = "Q",
          backward = "cfirst",
          forward = "clast",
        })
        :command_pair({
          key = "<C-q>",
          backward = "cpfile",
          forward = "cnfile",
        })
        :command_pair({
          key = "t",
          backward = "tprevious",
          forward = "tnext",
        })
        :command_pair({
          key = "T",
          backward = "tfirst",
          forward = "tlast",
        })
        :command_pair({
          key = "<C-t>",
          backward = "ptprevious",
          forward = "ptnext",
        })
        :unified_function({
          key = "f",
          desc = "jump to the {previous|next} file in the directory tree",
          fun = function(direction)
            local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1] or {}
            if win_info.quickfix == 1 then
              local cmd
              if win_info.loclist == 1 then
                if direction == "backward" then
                  cmd = "lolder"
                else
                  cmd = "lnewer"
                end
              else
                if direction == "backward" then
                  cmd = "colder"
                else
                  cmd = "cnewer"
                end
              end
              local ok, err = pcall(vim.cmd, {
                cmd = cmd,
                count = vim.v.count1,
              })
              if not ok then
                vim.api.nvim_err_writeln(err)
              end
            else
              local it = require("impairative.helpers").walk_files_tree(vim.fn.expand("%"), direction == "backward")
              local path
              path = it:nth(vim.v.count1)
              if path then
                require("impairative.util").jump_to({ filename = path })
              end
            end
          end,
        })
        :jump_in_buf({
          key = "n",
          desc = "jump to the {previous|next} SCM conflict marker or diff/path hunk",
          extreme = {
            key = "N",
            desc = "jump to the {first|last} SCM conflict marker or diff/path hunk",
          },
          fun = require("impairative.helpers").conflict_marker_locations,
        })
        :unified_function({
          key = "<Space>",
          desc = "add blank line(s) {above|below} the current line",
          fun = function(direction)
            local line_number = vim.api.nvim_win_get_cursor(0)[1]
            if direction == "backward" then
              line_number = line_number - 1
            end
            local lines = vim.fn["repeat"]({ "" }, vim.v.count1)
            vim.api.nvim_buf_set_lines(0, line_number, line_number, true, lines)
          end,
        })
        :range_manipulation({
          key = "e",
          line_key = true,
          desc = "exchange the line(s) with [count] lines {above|below} it",
          fun = function(args)
            local target
            if args.direction == "backward" then
              target = args.start_line - args.count1 - 1
            else
              target = args.end_line + args.count1
            end
            vim.cmd({
              cmd = "move",
              range = { args.start_line, args.end_line },
              args = { target },
            })
          end,
        })
        :text_manipulation({
          key = "u",
          line_key = true,
          desc = "{encode|decode} URL",
          backward = require("impairative.helpers").encode_url,
          forward = require("impairative.helpers").decode_url,
        })
        :text_manipulation({
          key = "y",
          line_key = true,
          desc = "{escape|unescape} strings (C escape rules)",
          backward = require("impairative.helpers").encode_string,
          forward = require("impairative.helpers").decode_string,
        })
        :text_manipulation({
          key = "C",
          line_key = true,
          desc = "{escape|unescape} strings (C escape rules)",
          backward = require("impairative.helpers").encode_string,
          forward = require("impairative.helpers").decode_string,
        })
    end,
  },
  -- { "tpope/vim-unimpaired", event = { "BufReadPre", "BufNewFile" } },
  {
    "echasnovski/mini.surround",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = { -- Module mappings. Use `''` (empty string) to disable one.
      custom_surroundings = {
        ["("] = { output = { left = "( ", right = " )" } },
        ["["] = { output = { left = "[ ", right = " ]" } },
        ["{"] = { output = { left = "{ ", right = " }" } },
        ["<"] = { output = { left = "< ", right = " >" } },
      },
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
      },
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.api.nvim_set_keymap("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = true })
      vim.api.nvim_set_keymap("n", "yss", "ys_", { noremap = false })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
