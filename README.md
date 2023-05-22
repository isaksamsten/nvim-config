# Isak Samsten's Neovim config

## Installation

Clone the repository

    https://github.com/isaksamsten/nvim-config.git

Start Neovim and sync the plugins with `:Lazy restore`.

## Keybindings

### AI

| Mode    | Keymap | Action                   |
| ------- | ------ | ------------------------ |
| `n`,`v` | `M-a`  | Prompt for AI            |
| `i`     | `M-a`  | Complete using AI        |
| `v`     | `zAc`  | Correct grammar using AI |

### Completion

| Keymap        | Action                             |
| ------------- | ---------------------------------- |
| `C-k`, `Up`   | Select previous                    |
| `C-j`, `Down` | Select next                        |
| `C-Space`     | Complete/Abort                     |
| `Enter`       | Accept selected                    |
| `Tab`         | Confirm, complete and jump snippet |
| `S-Tab`       | Jump snippet backwards             |

### Comments

| Mode | Keymap                  | Actiom            |
| ---- | ----------------------- | ----------------- |
| `n`  | `gc`+`c` or text-object | Add comment       |
| `v`  | `gc`                    | Add comment       |
| `n`  | `C-;`                   | Add documentation |

### Test

| Keymap       | Action             |
| ------------ | ------------------ |
| `M-rr`       | Run current test   |
| `M-rR`       | Run current tests  |
| `M-rd`       | Debug current test |
| `<leader>ot` | Open summary       |
| `<leader>oT` | Open output        |
| `M-rt`       | Reveal output      |

### Debugging

| Keymap      | Action                        |
| ----------- | ----------------------------- |
| `F9`        | Toggle breakpoint             |
| `S-F9`      | Toggle conditional breakpoint |
| `F5`        | Start/Continue                |
| `Ctrl-F5`   | Run last                      |
| `Shift-F5`  | Stop                          |
| `F10`       | Step over                     |
| `F11`       | Step into                     |
| `Shift-F11` | Step out                      |

### LSP

| Keymap         | Action                |
| -------------- | --------------------- |
| `K`            | Hover                 |
| `gd`           | Go to definition      |
| `gD`           | Go to declaration     |
| `gi`           | Go to implementation  |
| `go`           | Go to type definition |
| `gr`           | Go to references      |
| `Ctrl-Enter`   | Rename                |
| `Ctrl-.`       | Code action           |
| `<leader>F`    | Format document       |
| `gq`           | Format range          |
| `Ctrl-,`       | Show diagnostic       |
| `[,`           | Previous diagnostic   |
| `],`           | Next diagnostic       |
| `Ctrl-Shift-P` | Find symbol           |

### Toggle

| Keymap       | Action                |
| ------------ | --------------------- |
| `<leader>uf` | Toggle format on save |
| `<leader>uc` | Toggle conceal        |
| `<leader>ud` | Toggle diagnostics    |
| `<leader>ub` | Toggle Git blame      |

### Sidebar

| Keymap       | Action               |
| ------------ | -------------------- |
| `M-e`        | Focus explorer       |
| `M-b`        | Toggle explorer      |
| `M-,`        | Document diagnostics |
| `M-<`        | Workspace diagnostic |
| `Ctrl-\`     | Terminal             |
| `<leader>ol` | Location list        |
| `<leader>oq` | Quickfix list        |

### Git

| Mode    | Keymap       | Action          |
| ------- | ------------ | --------------- |
| `n`     | `<leader>gg` | Git status      |
| `n`     | `<leader>gv` | File history    |
| `n`     | `<leader>gV` | Branch history  |
| `n`,`v` | `<leader>gs` | Stage           |
| `n`,`v` | `<leader>gs` | Stage           |
| `n`,`v` | `<leader>gr` | Reset           |
| `n`,`v` | `<leader>gr` | Reset           |
| `n`     | `<leader>gS` | Stage buffer    |
| `n`     | `<leader>gR` | Reset buffer    |
| `n`     | `<leader>gb` | Blame line      |
| `n`     | `<leader>gp` | Preview changes |
| `n`     | `<leader>gR` | Reset buffer    |
| `n`     | `<leader>gd` | Diff            |
| `n`     | `<leader>gD` | Diff buffer     |
| `o`,`x` | `ig`         | Select change   |

### Buffers, windows and tabs

| Keymap             | Action        |
| ------------------ | ------------- |
| `C-q`              | Close buffer  |
| `C-h`              | Left window   |
| `C-j`              | South window  |
| `C-k`              | North window  |
| `C-l`              | Right window  |
| `<leader><leader>` | Switch buffer |
| `<leader>-f`       | Find file     |
| `<leader>-s`       | Global search |
| `M-[`              | Previous tab  |
| `M-]`              | Next tab      |
| `M-w`              | Close tab     |
| `M-t`              | New tab       |

Default Keybindings as set by `mini.ai`, `mini.move` and `leap`.

## Screenshots

I use two different themes that I have customized to my liking.

### OneDark

Color scheme: [OneDark Pro](https://github.com/olimorris/onedarkpro.nvim),
Terminal: [Kitty](https://github.com/kovidgoyal/kitty) forked with [better
macOS title bar](https://github.com/isaksamsten/kitty), Font: Meslo LG S

![Debug](./assets/onedark/debug.png)

![Completion](./assets/onedark/complete.png)

![Diagnostics](./assets/onedark/error.png)

![Live search](./assets/onedark/search.png)

![Open files](./assets/onedark/findfile.png)

### Catppuccin

Color scheme: [Catppuccin](https://github.com/catppuccin/nvim),
Terminal: [Kitty](https://github.com/kovidgoyal/kitty) forked with [better
macOS title bar](https://github.com/isaksamsten/kitty), Font: Meslo LG S

![Debug](./assets/catppuccin/debug.png)

![Completion](./assets/catppuccin/complete.png)

![Diagnostics](./assets/catppuccin/error.png)

![Live search](./assets/catppuccin/search.png)

![Open files](./assets/catppuccin/findfile.png)
