# nvim-stortini

Personal Neovim configuration with a wrapper script for portable, repo-local use.

This setup is meant to be run through the `bin/nvim-stortini` wrapper rather than by pointing your main `~/.config/nvim` directly at this repository. The wrapper creates a private Neovim environment under the repository, sets `NVIM_APPNAME`, sets XDG config/data/state/cache directories under a repo-local `.nvim/`, and then symlinks the repository's `nvim/` directory into that environment before launching Neovim.

## Why this repo exists

This configuration is set up so it can be cloned anywhere and used without touching an existing global Neovim setup. That makes it convenient on shared machines, lab machines, temporary development environments, or when you want to keep this configuration isolated from any other Neovim config you may already have.

## Companion repos

This configuration is intended to pair well with:

- [tmux-stortini](https://github.com/matthewstortini/tmux-stortini) for tmux configuration
- [wezterm](https://github.com/matthewstortini/wezterm-stortini) for terminal configuration

In particular, this Neovim config includes `vim-tmux-navigator`, so using it alongside the companion tmux config gives a consistent split/pane navigation workflow across Neovim and tmux.

## Repository layout

```text
.
├── bin/
│   └── nvim-stortini
├── nvim/
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
│       ├── custom/
│       └── plugins/
└── README.md
```

## Requirements

The wrapper currently expects these executables to be available:

- `nvim`
- `rg`
- `fd`
- `git`
- `make`
- `tree-sitter`

Some plugin functionality also depends on external language tools. For example:

- `clangd` for C/C++ LSP
- `clang-format` for C/C++ formatting
- `stylua` for Lua formatting

The Mason configuration installs some of these automatically when possible, but having a working compiler/toolchain environment still matters.

## Installation

Clone the repository:

```bash
git clone https://github.com/matthewstortini/nvim-stortini.git
cd nvim-stortini
```

Run the wrapper directly:

```bash
./bin/nvim-stortini
```

Or put `bin/` on your `PATH` and run:

```bash
nvim-stortini
```

## How the wrapper works

The wrapper script:

1. Locates the repository root
2. Sets `NVIM_APPNAME=nvim-stortini`
3. Creates repo-local XDG directories under `.nvim/`
4. Symlinks the repository's `nvim/` directory into the XDG config tree
5. Launches Neovim with that isolated configuration

This means plugin installs, caches, lockfiles, Mason data, parser downloads, and other runtime files live under the repository-local `.nvim/` area rather than mixing into your default Neovim environment.

## Fonts and icons

This configuration uses `nvim-web-devicons` to display filetype icons in places like Neo-tree, Telescope, and status lines. To render these icons correctly, a **Nerd Font** is recommended.

Nerd Fonts can be downloaded from:

https://www.nerdfonts.com/

Download and install any Nerd Font you prefer, then configure your terminal to use it.

The companion WezTerm configuration in this ecosystem is set up to use:

- `Iosevka Nerd Font Mono`
- `JetBrainsMono` as a fallback

If you want the same appearance, install **Iosevka Nerd Font Mono** from the Nerd Fonts website and set your terminal font accordingly.

If you do not use the companion WezTerm config, any Nerd Font should work as long as your terminal is actually set to use it.

## `compile_commands.json` and C/C++ support

This config enables `clangd` for C and C++.

For good diagnostics, completion, include-path resolution, and jump-to-definition behavior in C/C++ projects, it is best to have a compilation database available in the relevant project or package root:

- `compile_commands.json`
- or `compile_flags.txt`

If your project does not provide one, `clangd` often has to guess compiler flags and include paths, which can lead to incorrect diagnostics or incomplete indexing.

For CMake projects, a common way to generate `compile_commands.json` is:

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B build
```

Then either keep the file where `clangd` can find it or symlink it into the package root if your build system writes it somewhere else.

## Custom commands

This configuration includes a few custom commands that are specific to this repo.

### `:TemplatePaste`

Expands the most recently yanked line (register `0`) into multiple lines by applying position-wise replacements.

Open the command prompt quickly with:

```vim
<leader>TP
```

Syntax:

```vim
:TemplatePaste target {a,b,c} [target2 {x,y,z} ...]
```

Example:

Suppose the last yanked line is:

```lua
vim.keymap.set("n", "<C-h>", ":TmuxNavigatorLeft<CR>")
```

Run:

```vim
:TemplatePaste C-h {C-j,C-k,C-l} Left {Down,Up,Right}
```

Result:

```lua
vim.keymap.set("n", "<C-j>", ":TmuxNavigatorDown<CR>")
vim.keymap.set("n", "<C-k>", ":TmuxNavigatorUp<CR>")
vim.keymap.set("n", "<C-l>", ":TmuxNavigatorRight<CR>")
```

This is useful for generating repeated boilerplate where each line differs in a structured way.

### `:TemplateReplace`

Applies the same kind of position-wise replacements, but to an existing range of lines in place.

Open the command prompt quickly with:

```vim
<leader>TR
```

It works in:

- normal mode with an explicit range
- visual mode over a selected line range

Syntax:

```vim
:[range]TemplateReplace target {a,b,c} [target2 {x,y,z} ...]
```

Example with a visual selection over 3 lines:

```vim
:TemplateReplace C-h {C-j,C-k,C-l} Left {Down,Up,Right}
```

This is useful when you already pasted a block and want to transform each selected line differently but with one structured command.

### `:E<Space>` convenience expansion

In command-line mode, typing:

```vim
:E<Space>
```

expands to:

```vim
:e /path/to/current/buffer/
```

using the directory of the current buffer, or the current working directory if the buffer has no path.

This makes it faster to open nearby files relative to the file you are already editing.

## Key behaviors and useful mappings

The exact mappings live in the configuration files, but the main workflow pieces are summarized below.

### Navigation (Neovim + tmux)

Pane navigation is shared between Neovim and tmux using
`vim-tmux-navigator`, so the same keys work across both environments.

- `Ctrl-h` — move to pane/split on the left
- `Ctrl-j` — move to pane/split below
- `Ctrl-k` — move to pane/split above
- `Ctrl-l` — move to pane/split on the right

This allows seamless movement between Neovim splits and tmux panes.

---

### Telescope (search and navigation)

Telescope is used for file discovery and project searching.

- `<leader>ff` — find files
- `<leader>fg` — search text in project (live grep)
- `<leader>fb` — switch buffers
- `<leader>fr` — recent files

These commands provide the primary interface for navigating files and searching within projects.

---

### Neo-tree (file browser)

Neo-tree provides a file browser that can be opened rooted at several useful locations.

- `<leader>fv` — smart folder view (Git root if present, otherwise `$HOME` or `/`)
- `<leader>gfv` — open at Git repository root
- `<leader>dfv` — open at directory of current file
- `<leader>hfv` — open at home directory
- `<leader>rfv` — open at filesystem root `/`

This approach avoids relying on the current working directory and instead provides explicit browsing contexts.

---

### LSP navigation and actions

Language Server Protocol functionality is provided through `nvim-lspconfig` and related plugins.

Navigation:

- `gd` — go to definition
- `gD` — go to declaration
- `gr` — list references
- `gi` — go to implementation
- `gy` — go to type definition

Information:

- `K` — show hover documentation

Code actions:

- `ca` — code actions
- `cr` — rename symbol

---

### Other useful commands

- `lf` — format the current buffer using the configured formatter or LSP
- `td` — toggle diagnostics display for the current buffer

## Plugin overview

### Core / plugin management

- **lazy.nvim** — plugin manager used to bootstrap and load the rest of the configuration

### UI and appearance

- **everforest-nvim** — colorscheme; configured here with transparent background highlights
- **alpha-nvim** — startup/dashboard screen with quick actions
- **lualine.nvim** — statusline
- **nvim-web-devicons** — file icons used by multiple UI plugins; benefits from a Nerd Font

### Navigation and file browsing

- **telescope.nvim** — fuzzy finder for files, grep, buffers, and oldfiles
- **telescope-fzf-native.nvim** — native sorter extension for faster Telescope matching
- **neo-tree.nvim** — file explorer/sidebar
- **plenary.nvim** — support library used by several plugins
- **nui.nvim** — UI dependency used by Neo-tree
- **vim-tmux-navigator** — seamless movement between Neovim splits and tmux panes

### Editing helpers

- **vim-abolish** — coercion and structured substitution helpers
- **nvim-treesitter** — syntax highlighting and indentation based on Treesitter parsers

### Completion and snippets

- **nvim-cmp** — completion menu engine
- **cmp-nvim-lsp** — LSP completion source for `nvim-cmp`
- **LuaSnip** — snippet engine
- **cmp_luasnip** — LuaSnip completion source
- **friendly-snippets** — community snippet collection

### LSP, formatting, and tool installation

- **mason.nvim** — installs external tools such as language servers and formatters
- **mason-lspconfig.nvim** — bridges Mason with `nvim-lspconfig`
- **nvim-lspconfig** — LSP client configuration (`lua_ls` and `clangd` are configured here)
- **none-ls.nvim** — exposes external tools such as `stylua` and `clang-format` through the LSP-style formatting interface

### Git integration

- **gitsigns.nvim** — Git signs/hunks in the sign column and Git metadata for the statusline

## Current language focus

This configuration is currently tuned most heavily for:

- **Lua** via `lua_ls`, Treesitter, and `stylua`
- **C/C++** via `clangd`, Treesitter, and `clang-format`

Additional language servers, formatters, and linters can be installed running :Mason in vim.

Once installed, they can be configured in the LSP configuration file lsp-config.lua

The configuration is intentionally structured so that adding support for additional languages mainly involves:

1. Installing the language server or formatter via Mason
2. Adding the relevant setup in `lsp-config.lua`

Even without additional language servers, the configuration still works well as a general-purpose editor for text editing, file navigation, and project exploration.

## Notes

- This config is intentionally personal and opinionated.
- The plugin lockfile is committed, so plugin versions are pinned.
- The setup is especially comfortable when paired with the companion tmux and WezTerm repos.
