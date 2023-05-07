return {
	"christoomey/vim-tmux-navigator",
    {
        "folke/which-key.nvim",
        lazy = true,
    },
    {
        -- Getting this to work with tmux you _must_ set
        -- `set -s set-clipboard on` in tmux conf
        "ojroques/vim-oscyank",
        commit = "e6298736a7835bcb365dd45a8e8bfe86d935c1f8",
        pin = true,
        cmd = { "OSCYankVisual", "OSCYank" },
        config = function()
            -- use OSCYank to integrate with client clipboard
            -- https://github.com/ojroques/vim-oscyank/issues/25#issuecomment-1098406019
            local function copy(lines, _) vim.fn.OSCYankString(table.concat(lines, "\n")) end
            local function paste() return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') } end

            vim.g.oscyank_term = "default"
            vim.g.clipboard = {
                name = "osc52",
                copy = { ["+"] = copy, ["*"] = copy },
                paste = { ["+"] = paste, ["*"] = paste },
            }
        end
    },
    {
        "phaazon/hop.nvim",
        config = function()
            require("hop").setup({ case_insensitive = false, keys = ".yrkq'lefiuxn;djtcogpab"})
        end
    },

--     {
--         "ojroques/nvim-osc52",
--         cmd = { "OSCYank", "OSCYankVisual", "Yank" },
--         config = function()
--             vim.api.nvim_create_user_command('Yank', function() require("osc52").copy_visual() end, { range = 1 } )
--         end,
--     },
}
