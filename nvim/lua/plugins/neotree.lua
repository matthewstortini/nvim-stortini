return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,

  config = function()
    -- We always pass an explicit root via `dir=...`, so don't bind Neo-tree to cwd.
    require("neo-tree").setup({
      filesystem = {
        bind_to_cwd = false,
      },
    })

    --------------------------------------------------------------------------
    -- Helpers
    --------------------------------------------------------------------------

    -- Current buffer's file path, or nil if [No Name]
    local function curfile()
      local f = vim.api.nvim_buf_get_name(0)
      return (f and f ~= "") and vim.fs.normalize(f) or nil
    end

    local HOME = vim.fs.normalize(vim.loop.os_homedir())

    -- True if `path` is under $HOME
    local function under_home(path)
      return path == HOME or path:sub(1, #HOME + 1) == (HOME .. "/")
    end

    -- Open Neo-tree rooted at `dir` revealing/expanding anything
    local function open_root(dir)
      dir = vim.fn.fnameescape(vim.fs.normalize(dir))
      vim.cmd("Neotree filesystem left dir=" .. dir)
    end

    --------------------------------------------------------------------------
    -- Folder-view commands (no auto-expansion)
    --------------------------------------------------------------------------

    -- fv: smart root (git repo root if present; else $HOME if under home; else /)
    local function fv()
      local f = curfile()
      if not f then
        return open_root(HOME)
      end

      local git = vim.fs.root(f, { ".git" })
      if git then
        return open_root(git)
      end

      if under_home(f) then
        return open_root(HOME)
      end

      return open_root("/") -- file outside home + not in git => show whole FS
    end

    -- gfv: git root (error if not in a repo)
    local function gfv()
      local f = curfile()
      if not f then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
      end

      local git = vim.fs.root(f, { ".git" })
      if not git then
        vim.notify("Not in a git repo", vim.log.levels.ERROR)
        return
      end

      open_root(git)
    end

    -- dfv: directory containing current file (or $HOME if no file)
    local function dfv()
      local f = curfile()
      if not f then
        return open_root(HOME)
      end
      open_root(vim.fs.dirname(f))
    end

    -- hfv: $HOME root (no expansion)
    local function hfv()
      open_root(HOME)
    end

    -- rfv: filesystem root "/" (no expansion)
    local function rfv()
      open_root("/")
    end

    --------------------------------------------------------------------------
    -- Keymaps (all end with "fv"; no Shift needed)
    --------------------------------------------------------------------------
    vim.keymap.set("n", "<leader>fv", fv, { desc = "Folder view (smart)", nowait = true })
    vim.keymap.set("n", "<leader>gfv", gfv, { desc = "Folder view (git root)", nowait = true })
    vim.keymap.set("n", "<leader>dfv", dfv, { desc = "Folder view (file dir)", nowait = true })
    vim.keymap.set("n", "<leader>hfv", hfv, { desc = "Folder view ($HOME)", nowait = true })
    vim.keymap.set("n", "<leader>rfv", rfv, { desc = "Folder view (/)", nowait = true })
  end,
}
