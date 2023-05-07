vim.g.mapleader = " "
vim.g.oscyank_term = "default"

vim.opt.syntax = "enable"

vim.opt.splitright = true

vim.opt.wrap = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.background = "dark"
vim.opt.showtabline = 4

vim.opt.mouse = 'a'

vim.opt.timeoutlen = 500

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

vim.opt.pumheight = 30

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
-- vim.cmd([[
-- set signcolumn=yes
-- autocmd CursorHold * lua require('lspsaga.showdiag'):show_diagnostics({ line = true, arg = "++unfocus" })
-- ]])


-- Disable cruft in :terminal
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")
