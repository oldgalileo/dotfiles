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

require('general') -- lua/general.lua
require('plugins') -- lua/plugins.lua

require('config/cmp')
require('config/mason')
require('config/lspconfig')
require('config/dap')
require('config/rust-tools')
require('config/symbols-outline')
require('config/telescope')
require('config/trouble')
require('config/nvim-tree')
require('config/treesitter')
require('config/toggleterm')
require('config/octo')
require('config/ayu')

require('config/org')

local vs = require('utils.vimscript') -- lua/vimscript.lua
local wk = require('which-key')

-- * Mappings

-- More ergonomic terminal escaping
vs.tnoremap("hh", "<C-\\><C-n>")

-- Use alt + hjkl to resize windows
vs.nnoremap("<M-j>", ":resize -2<CR>")
vs.nnoremap("<M-k>", ":resize +2<CR>")
vs.nnoremap("<M-h>", ":vertical resize -2<CR>")
vs.nnoremap("<M-l>", ":vertical resize +2<CR>")

-- ** Telescope
wk.register({
    ["<Leader>"] = {
        f = { function() require("telescope.builtin").find_files() end, "Find Files" },
        g = { function() require("telescope.builtin").git_files() end, "Find Git Files" },
        r = { function() require("telescope.builtin").live_grep() end, "Live Grep" },
        b = { function() require("telescope.builtin").buffers() end, "Buffers" },
    },
    ["<C-_>"] = { function() require("utils.telescope").search_in_buffer() end, "Search Current Buffer" },
})
wk.register({
    ["<C-_>"] = { function() require("utils.telescope").search_in_buffer() end, "Search Current Buffer (Insert Mode)" },
}, { mode = "i" })

-- ** LSP
wk.register({
    ["<C-s>"] = { function() vim.lsp.buf.hover() end, "Hover" },
    g = {
        d = { function() vim.lsp.buf.definition() end, "Definition" },
        D = { function() vim.lsp.buf.declaration() end, "Declaration" },
        a = { function() vim.lsp.buf.code_action() end, "Code Action" },
        r = { function() vim.lsp.buf.references() end, "References" },
        e = { function() vim.diagnostic.goto_prev() end, "Goto Prev Diagnostic" },
        E = { function() vim.diagnostic.goto_next() end, "Goto Next Diagnostic" },
    },
})

-- *** DAP
wk.register({
    ["<C-g>"] = { function()
        local ll = require('utils.lsp')
        ll.run_function(ll.get_current_function())
    end, "_which_key_ignore" },
})

wk.register({
    ["<Leader>"] = {
        R = { "<cmd>RustRunnables<CR>", "Rust Runnables" },
        D = { "<cmd>RustDebuggables<CR>", "Rust Debuggables" },
        d = {
            b = { "<cmd>DapToggleBreakpoint<CR>", "Toggle Breakpoint" },
            B = { function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Add conditional breakpoint" },
            d = { function() debug_nearest() end, "Execute debuggable at cursor" },
            i = { function() require('dap.ui.widgets').hover() end, "Debugger inspect" },
            e = { function() require('dap').set_exception_breakpoints({"all"}) end, "Debugger enable exception breakpoints" },
            c = { function() require('dap').terminate() end, "Debugger terminate" },
            v = { function() require('dapui').eval() end, "Debugger eval" },
        },
    },
}, { mode = "n", noremap = true })
wk.register({
    ["<Leader>dv"] = { function() require('dapui').eval() end, "Debugger eval" },
}, { mode = "v" })

vs.nnoremap("L", ':DapStepInto<CR>', true)
vs.nnoremap("H", ':DapStepOut<CR>', true)
vs.nnoremap("J", ':DapStepOver<CR>', true)

-- ** General
vs.nnoremap("<Leader>s", '<cmd>SymbolsOutline<CR>')

-- WhichKey
--vs.nnoremap("<leader>", ":WhichKey '<Space>'<CR>", true)
--vs.nnoremap("g", ":WhichKey 'g'<CR>", true)

-- TAB in normal mode will move to text buffer
vs.nnoremap("<TAB>", ":bnext<CR>")
-- SHIFT-TAB will go back
vs.nnoremap("<S-TAB>", ":bprevious<CR>")
-- Escape redraws the screen and removes any search highlighting.
vs.nnoremap("<esc>", ":noh<return><esc>")

vs.nnoremap("vv", "<C-w>v", silent)
vs.nnoremap("vs", "<C-w>s", silent)
vs.nnoremap(",,", "<C-w><C-w>", silent)
