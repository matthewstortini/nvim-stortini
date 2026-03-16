# nvim-stortini

Personal Neovim configuration with a wrapper script for portable, repo-local use.

This setup is meant to be run through the `bin/nvim-stortini` wrapper rather than by pointing your main `~/.config/nvim` directly at this repository. The wrapper creates a private Neovim environment under the repository, sets `NVIM_APPNAME`, sets XDG config/data/state/cache directories under a repo-local `.nvim/`, and then symlinks the repository's `nvim/` directory into that environment before launching Neovim.

## Why this repo exists

This configuration is set up so it can be cloned anywhere and used without touching an existing global Neovim setup. That makes it convenient on shared machines, lab machines, temporary development environments, or when you want to keep this configuration isolated from any other Neovim config you may already have.

## Companion repos

This configuration is intended to pair well with the packages:

- https://github.com/matthewstortini/tmux-stortini
- https://github.com/matthewstortini/wezterm-stortini

Together WezTerm, tmux, and Neovim form the terminal workflow this configuration is designed around.

In particular, this setup uses smart-splits.nvim so pane navigation and resizing behave consistently between Neovim splits and tmux panes.

## Repository layout

```
.
|-- bin
|   `-- nvim-stortini
|-- nvim
|   |-- init.lua
|   |-- lazy-lock.json
|   `-- lua
|       |-- custom
|       `-- plugins
`-- README.md
```

## Requirements

The wrapper currently expects these executables to be available:

- nvim
- rg
- fd
- git
- make
- tree-sitter
- node

Some plugin functionality also depends on external language tools. For example:

- clangd for C/C++ LSP
- clang-format for C/C++ formatting
- stylua for Lua formatting

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

---

## Optional convenience setup

To avoid needing to type the full path to the `nvim-stortini` executable when launching this configuration, a convenience script `setup_nvim_environment.sh` is provided.

This script appends the repository's `bin/` directory to your `$PATH` and defines the alias `nv` to launch `nvim-stortini`.

Run the script with the environment file you normally source for shell setup:

```bash
./setup_nvim_environment.sh <your-environment-script>
```

Example:

```bash
./setup_nvim_environment.sh ~/envSetup.sh
```

Reload your environment:

```bash
source ~/envSetup.sh
```

You can now launch Neovim using:

```bash
nv
```

## How the wrapper works

The wrapper script:

1. Locates the repository root
2. Sets NVIM_APPNAME=nvim-stortini
3. Creates repo-local XDG directories under `.nvim/`
4. Symlinks the repository's `nvim/` directory into the XDG config tree
5. Launches Neovim with that isolated configuration

This means plugin installs, caches, lockfiles, Mason data, parser downloads, and other runtime files live under the repository-local `.nvim/` area rather than mixing into your default Neovim environment.

## Fonts and icons

This configuration uses `nvim-web-devicons` to display filetype icons in places like Neo-tree, Telescope, and status lines. To render these icons correctly, a Nerd Font is recommended.

Nerd Fonts can be downloaded from:

https://www.nerdfonts.com/

Download and install any Nerd Font you prefer, then configure your terminal to use it.

The companion WezTerm configuration in this ecosystem is set up to use:

- Iosevka Nerd Font Mono
- JetBrainsMono Nerd Font (fallback)

If you want the same appearance, install Iosevka Nerd Font Mono and configure your terminal to use it.

## compile_commands.json and C/C++ support

This config enables clangd for C and C++.

For good diagnostics, completion, include-path resolution, and jump-to-definition behavior in C/C++ projects, it is best to have a compilation database available in the relevant project root:

- compile_commands.json
- compile_flags.txt

If your project does not provide one, clangd often has to guess compiler flags and include paths.

For CMake projects:

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B build
```

## Custom commands

### :TemplatePaste

Expands the most recently yanked line (register `0`) into multiple lines by applying structured replacements.

Open quickly with:

```
<leader>TP
```

Syntax:

```
:TemplatePaste target {a,b,c} [target2 {x,y,z} ...]
```

### :TemplateReplace

Applies structured replacements to an existing range of lines.

Open quickly with:

```
<leader>TR
```

### :E<Space>

Typing:

```
:E<Space>
```

expands to:

```
:e /path/to/current/buffer/
```

## Key behaviors and useful mappings

### Navigation and resizing (Neovim + tmux)

Resize splits:

```
Alt-h   resize left
Alt-j   resize down
Alt-k   resize up
Alt-l   resize right
```

Move between splits and tmux panes:

```
Ctrl-h  move left
Ctrl-j  move down
Ctrl-k  move up
Ctrl-l  move right
```

These mappings work seamlessly between Neovim splits and tmux panes using smart-splits.nvim.

### Telescope

```
<leader>ff   find files
<leader>fg   search text (live grep)
<leader>fb   switch buffers
<leader>fr   recent files
```

### Neo-tree

```
<leader>fv   open from directory nvim was started in
<leader>gfv  open Git repository root
<leader>dfv  open directory of current file
<leader>hfv  open home directory
<leader>rfv  open filesystem root /
```

### LSP navigation and actions

Navigation:

```
gd        go to definition
gD        go to declaration
gi        go to implementation
gy        go to type definition
gr        list references
<leader>o open source/header from header/source file
```

Hover documentation:

```
K   show documentation
```

Diagnostics:

```
[d   previous diagnostic
]d   next diagnostic
```

Code actions:

```
<leader>ca   code action
<leader>cr   rename symbol
```

### Formatting and diagnostics

```
<leader>lf   format buffer
<leader>td   toggle diagnostics display
```

### Commenting / uncommenting

This configuration includes **Comment.nvim** for quick commenting.

Toggle comment on the current line:

```
gcc
```

Toggle comment using a motion:

```
gc<motion>
```

Examples:

```
gcj     comment this line and the next
gc5j    comment this line and the next five
```

Visual mode:

```
select lines
gc
```

The same command toggles both **comment** and **uncomment**.

### GitHub Copilot

This configuration includes **copilot.vim**.

Copilot starts **disabled by default**.

Toggle Copilot on/off:

```
<leader>cp
```

Accept a Copilot suggestion:

```
Ctrl-y
```

Copilot suggestions appear as inline ghost text. They are separate from the completion popup provided by `nvim-cmp`.

If Copilot is installed but has not been set up yet, run:

```
:Copilot setup
```

This command performs the initial GitHub authentication required for Copilot.

After setup is complete, Copilot can be toggled on and off with `<leader>cp`.

## Plugin overview

### Core / plugin management

- lazy.nvim

### UI and appearance

- everforest-nvim
- alpha-nvim
- lualine.nvim
- nvim-web-devicons

### Navigation and file browsing

- telescope.nvim
- telescope-fzf-native.nvim
- neo-tree.nvim
- plenary.nvim
- nui.nvim
- smart-splits.nvim

### Editing helpers

- vim-abolish
- nvim-treesitter
- Comment.nvim

### Completion and snippets

- nvim-cmp
- cmp-nvim-lsp
- LuaSnip
- cmp_luasnip
- friendly-snippets

### LSP, formatting, and tool installation

- mason.nvim
- mason-lspconfig.nvim
- nvim-lspconfig
- none-ls.nvim

### Git integration

- gitsigns.nvim

### AI assistance

- copilot.vim

## Current language focus

This configuration is currently tuned most heavily for:

- Lua
- C / C++

Tools used include:

- lua_ls
- clangd
- stylua
- clang-format

Additional language servers can be installed with:

```
:Mason
```

## Notes

- This config is intentionally personal and opinionated.
- Plugin versions are pinned via lazy-lock.json.
- It works best when paired with the companion tmux and WezTerm repositories.
