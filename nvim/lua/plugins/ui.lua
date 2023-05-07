return {
    {
        "tanvirtin/monokai.nvim",
        lazy = false,
        priority = 1000,
        config = function(_, opts)
            require('monokai').setup({
                palette = require('monokai').pro
            })
        end
    },
    {
        "nvim-lua/plenary.nvim",
        cmd = {
            "PlenaryBustedFile",
            "PlenaryBustedDirectory"
        },
        lazy = true
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                lazy = true,
            },

        },
        cmd = "Telescope",
        opts = function()
            local Ta = require("telescope.actions")
            return {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = Ta.move_selection_better,
                            ["<C-k>"] = Ta.move_selection_worse,
                            ["<C-q>"] = Ta.send_to_qflist,
                            ["<Esc>"] = Ta.close,
                        },
                    },
                },
            }
        end,
        lazy = true,
        config = function(_, opts)
            local Ts = require("telescope")
            Ts.load_extension("fzf")
            Ts.setup(opts)
        end
    }
}
