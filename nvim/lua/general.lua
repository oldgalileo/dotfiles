vim.g.mapleader = " "

vim.opt.syntax = "enable"

vim.opt.wrap = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.background = "dark"
vim.opt.showtabline = 4

vim.opt.mouse = 'a'

vim.opt.timeoutlen = 500

-- Disable cruft in :terminal
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")
