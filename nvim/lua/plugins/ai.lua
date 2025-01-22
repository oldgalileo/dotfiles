local use_local = false

local base_config = {
    quit_map = "q",
    retry_map = "<C-R>",
    display_mode = "split",
    show_prompt = false,
    show_model = true,
    no_auto_close = false,
    debug = true
}

-- Explain the plot of Hitchhiker's Guide to the Galaxy
-- using verse inspired by Walt Whitman

return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        build = "make",
        opts = {
            -- add any opts here
            behaviour = {
                auto_suggestions = true, -- Experimental stage
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
        },
        mappings = {
            suggestion = {
                accept = "<C-l>",
            },
        },

        dependencies = {
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below is optional, make sure to setup it properly if you have lazy=true
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    }
}
