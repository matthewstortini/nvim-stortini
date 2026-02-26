-- configurations
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")

-- define <leader> as spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- keymapping
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":b#<CR>")
vim.keymap.set("c", "<Space>", function()
  if vim.fn.getcmdtype() ~= ":" then
    return " "
  end
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  if pos == #line + 1 and line:match("^%s*E$") then
    local dir = vim.fn.expand("%:p:h")
    if dir == "" then
      dir = vim.fn.getcwd()
    end
    return vim.api.nvim_replace_termcodes("<C-u>e " .. dir .. "/", true, false, true)
  end
  return " "
end, { expr = true })

-- =========================
-- Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

--local opts = {}

require("lazy").setup("plugins")

