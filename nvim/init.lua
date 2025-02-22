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

_G.Dotfiles = {
    icons = require('utils.icons'),
    format = require('utils.format'),
    lsp = require('utils.lsp'),
    vimscript = require('utils.vimscript'),
    telescope = require('utils.telescope')
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('general') -- lua/general.lua
require("lazy").setup("plugins")

local vs = Dotfiles.vimscript -- lua/utils/vimscript.lua
local wk = require('which-key')

-- * Mappings

-- More ergonomic terminal escaping
vs.tnoremap("hh", "<C-\\><C-n>")

-- Use alt + hjkl to resize windows
-- TODO: These don't work :sob:
vs.nnoremap("<M-j>", ":resize -2<CR>")
vs.nnoremap("<M-k>", ":resize +2<CR>")
vs.nnoremap("<M-h>", ":vertical resize -2<CR>")
vs.nnoremap("<M-l>", ":vertical resize +2<CR>")

wk.register({
    ["<C-f>"] = { function() require("hop").hint_char1({ current_line_only = false }) end, "Fancy Motion" },
    ["<C-t>"] = { function() require("hop").hint_char2({ current_line_only = false }) end, "Fancy Motion (double char)" },
})

-- ** Telescope
wk.register({
    ["<Leader>"] = {
        f = { function() require("telescope.builtin").find_files() end, "Find Files" },
        g = { function() require("telescope.builtin").git_files() end, "Find Git Files" },
        r = { function() require("telescope").extensions.live_grep_args.live_grep_args() end, "Live Grep (with args)" },
        b = { function() require("telescope.builtin").buffers() end, "Buffers" },
        u = { function() require("telescope.builtin").lsp_references() end, "LSP References" },
    },
    ["<C-_>"] = { function() require("utils.telescope").search_in_buffer() end, "Search Current Buffer" },
})
wk.register({
    ["<C-_>"] = { function() require("utils.telescope").search_in_buffer() end, "Search Current Buffer (Insert Mode)" },
}, { mode = "i" })

-- ** LSP
wk.register({
    ["<C-s>"] = { "<cmd>Lspsaga hover_doc<CR>", "Hover" },
    g = {
        h = { "<cmd>Lspsaga lsp_finder<CR>", "LSP Finder" },
        d = { "<cmd>Lspsaga peek_definition<CR>", "Definition" },
        D = { function() vim.lsp.buf.declaration() end, "Declaration" },
        a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
        r = { function() vim.lsp.buf.references() end, "References" },
        e = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Goto Prev Diagnostic" },
        E = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Goto Next Diagnostic" },
    },
})

-- *** DAP
-- TODO: Use the `wk.register( { ... }, { buffer = ??? })` functionality to do DAP-only/Rust-only bindings
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
        s = { "<cmd>SymbolsOutline<CR>", "Symbol Outline" }
    },
}, { mode = "n", noremap = true })

wk.register({
    ["<Leader>dv"] = { function() require('dapui').eval() end, "Debugger eval" },
}, { mode = "v" })

vs.nnoremap("L", ':DapStepInto<CR>', true)
vs.nnoremap("H", ':DapStepOut<CR>', true)
vs.nnoremap("J", ':DapStepOver<CR>', true)

-- ** General
vs.nnoremap("<Leader>s", "<cmd>SymbolsOutline<CR>")

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

wk.register({
    ["f"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true}) end, "Search Char (Forward)" },
    ["F"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true}) end, "Search Char (Backward)"},
    ["t"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, "Search To Char (Forward)"},
    ["T"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 }) end, "Search To Char (Backward)"},
}, { mode = "n" })
wk.register({
    ["f"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true}) end, "Search Char (Forward)"},
    ["F"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true}) end, "Search Char (Backward)"},
    ["t"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, "Search To Char (Forward)"},
    ["T"] = { function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 }) end, "Search To Char (Backward)"},
}, { mode = "v" })
