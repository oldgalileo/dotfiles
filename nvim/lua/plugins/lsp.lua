return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim", -- LSP / DAP installer
            "williamboman/mason-lspconfig.nvim",
            "lspsaga.nvim"
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
            },
            autoformat = true, 
            servers = {
                -- The Bash LSP requires NPM. To install NPM, run:
                -- `wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`
                -- and then do `nvm list-remote` to see which versions are available.
                -- Finally, `nvm install <version>`
                bashls = {},
                rust_analyzer = {}
            },
            setup = {},
        },
        config = function(_, opts)
            require("utils.format").autoformat = opts.autoformat

            vim.fn.sign_define("DiagnosticSignError", { text = '', texthl = "Error", numhl = "" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = '', texthl = "Warn", numhl = "" })
            vim.fn.sign_define("DiagnosticSignHint", { text = '', texthl = "Hint", numhl = "" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = '', texthl = "Info", numhl = "" })

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers 
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(),
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            local Mlsp = require("mason-lspconfig")
            local mlsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    if not vim.tbl_contains(mlsp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            Mlsp.setup({ ensure_installed = ensure_installed })
            Mlsp.setup_handlers({ setup })
        end
    },
    {
        "glepnir/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({})
        end,
        dependencies = {
            {"nvim-tree/nvim-web-devicons"},
            --Please make sure you install markdown and markdown_inline parser
            {"nvim-treesitter/nvim-treesitter"}
        }
    },
    {
        "j-hui/fidget.nvim",
        event = "VimEnter",
        opts = {},
    },
    {
        "simrat39/symbols-outline.nvim",
        event = "LspAttach",
        opts = {},
    },
    "folke/trouble.nvim",
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            ensure_installed = {
                "stylua",
                "shfmt",
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
}
