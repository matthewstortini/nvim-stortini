return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    require("gitsigns").setup()

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {
          "filename",
          "branch",
          {
            "diff",
            source = function()
              local gs = vim.b.gitsigns_status_dict
              if not gs then
                return nil
              end
              return {
                added = gs.added,
                modified = gs.changed,
                removed = gs.removed,
              }
            end,
          },
          "diagnostics",
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          "filename",
          "branch",
          {
            "diff",
            source = function()
              local gs = vim.b.gitsigns_status_dict
              if not gs then
                return nil
              end
              return {
                added = gs.added,
                modified = gs.changed,
                removed = gs.removed,
              }
            end,
          },
          "diagnostics",
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
