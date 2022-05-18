-- * Overview:
-- Packer for plugin management:
-- ```shell
-- $ mkdir -p ~/.local/share/nvim/site/pack/packer/start;
-- $ git clone --depth 1 https://github.com/wbthomason/packer.nvim \
--     ~/.local/share/nvim/site/pack/packer/start/packer.nvim;
-- ````
-- ** Inspiration
-- - https://github.com/elken/nvim/blob/master/init.lua
-- - https://github.com/simrat39/dotfiles/blob/master/nvim/.config/nvim/init.lua

vim.g.lspservers_to_install = { 'gopls', 'rust_analyzer' }

require('plugins') -- lua/plugins.lua
require('general') -- lua/general.lua

require('config/cmp')
require('config/lspinstall')
require('config/lspconfig')
require('config/rust-tools')
require('config/symbols-outline')
require('config/telescope')
require('config/trouble')
require('config/nvim-tree')
require('config/treesitter')
require('config/ayu')

require('config/org')

local vs = require('utils.vimscript') -- lua/vimscript.lua

-- * Mappings

-- More ergonomic terminal escaping
vs.tnoremap("hh", "<C-\\><C-n>")

-- Use alt + hjkl to resize windows
vs.nnoremap("<M-j>", ":resize -2<CR>")
vs.nnoremap("<M-k>", ":resize +2<CR>")
vs.nnoremap("<M-h>", ":vertical resize -2<CR>")
vs.nnoremap("<M-l>", ":vertical resize +2<CR>")

-- ** Telescope
vs.nnoremap("<Leader>f", '<cmd>lua require("telescope.builtin").find_files()<CR>', true)
vs.nnoremap("<Leader>g", '<cmd>lua require("telescope.builtin").git_files()<CR>', true)
vs.nnoremap("<Leader>r", '<cmd>lua require("telescope.builtin").live_grep()<CR>', true)
vs.nnoremap("<Leader>b", '<cmd>lua require("telescope.builtin").buffers()<CR>', true)
vs.nnoremap("<C-_>", '<cmd>lua require("utils.telescope").search_in_buffer()<CR>', true)

vs.inoremap(
  "<C-f>",
  '<Esc> :lua require("utils/telescope").search_in_buffer()<CR>'
)

-- ** LSP
vs.nnoremap("<C-s>", '<cmd>lua vim.lsp.buf.hover()<CR>', true)
vs.nnoremap("gd", '<cmd>lua vim.lsp.buf.definition()<CR>', true)
vs.nnoremap("ga", '<cmd>lua vim.lsp.buf.code_action()<CR>', true)
vs.nnoremap("ge", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", true)
vs.nnoremap("gE", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", true)
vs.nnoremap("<C-space>", "<cmd>lua vim.lsp.buf.hover()<CR>", true)
vs.vnoremap("<C-space>", "<cmd>RustHoverRange<CR>")

vs.nnoremap("gr", '<cmd>Trouble quickfix<CR>', true)

-- ** General
vs.nnoremap("<Leader>s", '<cmd>SymbolsOutline<CR>')

-- WhichKey
vs.nnoremap("<leader>", ":WhichKey '<Space>'<CR>", true)
vs.nnoremap("g", ":WhichKey 'g'<CR>", true)

-- TAB in normal mode will move to text buffer
vs.nnoremap("<TAB>", ":bnext<CR>")
-- SHIFT-TAB will go back
vs.nnoremap("<S-TAB>", ":bprevious<CR>")
-- Escape redraws the screen and removes any search highlighting.
vs.nnoremap("<esc>", ":noh<return><esc>")

vs.nnoremap("vv", "<C-w>v", silent)
vs.nnoremap("vs", "<C-w>s", silent)
vs.nnoremap(",,", "<C-w><C-w>", silent)
