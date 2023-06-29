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
            {
                { "nvim-telescope/telescope-live-grep-args.nvim" },
            }
        },
        cmd = "Telescope",
        opts = function()
            local Ta = require("telescope.actions")
            local Lga = require("telescope-live-grep-args.actions")
            return {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-q>"] = Ta.send_to_qflist,
                            ["<Esc>"] = Ta.close,
                        },
                    },
                },
                extensions = {
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-k>"] = Lga.quote_prompt({ postfix = " --iglob " }),
                            },
                        } ,
                    },
                }
            }
        end,
        lazy = true,
        config = function(_, opts)
            local Ts = require("telescope")
            Ts.load_extension("fzf")
            Ts.load_extension("live_grep_args")
            Ts.setup(opts)
        end
    }
}
