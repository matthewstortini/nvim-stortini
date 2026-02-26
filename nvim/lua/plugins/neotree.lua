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
        bind_to_cwd = true,
        window = {
          mappings = {
            ["u"] = "noop",
          },
        },
      },
    })

    local function git_root_or_nil()
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      if git_root and git_root ~= "" and vim.v.shell_error == 0 then
        return git_root
      end
      return nil
    end

    vim.keymap.set("n", "<leader>nt", function()
      local root = git_root_or_nil()
      if root then
        vim.cmd("lcd " .. vim.fn.fnameescape(root))
        vim.cmd("Neotree filesystem reveal left dir=" .. vim.fn.fnameescape(root))
      else
        vim.cmd("Neotree filesystem reveal left dir=" .. vim.fn.fnameescape(vim.fn.expand("~")))
      end
    end)
  end,
}
