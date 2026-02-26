return {
  "neanias/everforest-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("everforest")
    -- Keep terminal background image visible (transparent UI)
    local function transparent(group)
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
    transparent("Normal")
    transparent("NormalFloat")
    transparent("FloatBorder")
    transparent("SignColumn")
    transparent("EndOfBuffer")
  end
}
