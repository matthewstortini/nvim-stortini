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
    require("neo-tree").setup({
      filesystem = {
        bind_to_cwd = false,
      },
    })

    --------------------------------------------------------------------------
    -- Helpers
    --------------------------------------------------------------------------

    local HOME = vim.fs.normalize(vim.loop.os_homedir())
    local START_DIR = vim.fs.normalize(vim.fn.getcwd(-1, 0))

    local function curfile()
      local f = vim.api.nvim_buf_get_name(0)
      return (f and f ~= "") and vim.fs.normalize(f) or nil
    end

    local function open_root(dir)
      dir = vim.fn.fnameescape(vim.fs.normalize(dir))
      vim.cmd("Neotree filesystem left dir=" .. dir)
    end

    --------------------------------------------------------------------------
    -- Folder-view commands
    --------------------------------------------------------------------------

    -- fv: startup directory only
    local function fv()
      open_root(START_DIR)
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

    -- hfv: $HOME root
    local function hfv()
      open_root(HOME)
    end

    -- rfv: filesystem root "/"
    local function rfv()
      open_root("/")
    end

    --------------------------------------------------------------------------
    -- Keymaps
    --------------------------------------------------------------------------
    vim.keymap.set("n", "<leader>fv", fv, { desc = "Folder view (startup dir)", nowait = true })
    vim.keymap.set("n", "<leader>gfv", gfv, { desc = "Folder view (git root)", nowait = true })
    vim.keymap.set("n", "<leader>dfv", dfv, { desc = "Folder view (file dir)", nowait = true })
    vim.keymap.set("n", "<leader>hfv", hfv, { desc = "Folder view ($HOME)", nowait = true })
    vim.keymap.set("n", "<leader>rfv", rfv, { desc = "Folder view (/)", nowait = true })
  end,
}
