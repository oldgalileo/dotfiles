return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim", -- LSP / DAP installer
            "williamboman/mason-lspconfig.nvim",
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
            },
            autoformat = true, 
        },
        config = function(_, opts)
            require("utils.format").autoformat = opts.autoformat;

            vim.fn.sign_define("DiagnosticSignError", { text = '', texthl = "Error", numhl = "" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = '', texthl = "Warn", numhl = "" })
            vim.fn.sign_define("DiagnosticSignHint", { text = '', texthl = "Hint", numhl = "" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = '', texthl = "Info", numhl = "" })
        end
    },

    "folke/trouble.nvim",
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            ensure_installed = {
                "stylelua",
                "shfmt",
                "rust-analyzer",
            }
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },

    -- -- Used for overriding LSP default UI stuff
    "glepnir/lspsaga.nvimb,
}
