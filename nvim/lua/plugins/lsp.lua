return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim", -- LSP / DAP installer
            "williamboman/mason-lspconfig.nvim",
            "lspsaga.nvim"
        },
        opts = function ()
            ---@class PluginLspOpts
            return {
                ---@type vim.diagnostic.Opts
                diagnostics = {
                    underline = true,
                    update_in_insert = false,
                    virtual_text = {
                        spacing = 4,
                        source = "if_many",
                        prefix = function(diagnostic)
                            local icons = Dotfiles.icons.diagnostics
                            for d, icon in pairs(icons) do
                                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                                    return icon
                                end
                            end
                            return "●"
                        end,
                    },
                    severity_sort = true,
                    signs = {
                        text = {
                            [vim.diagnostic.severity.ERROR] = Dotfiles.icons.diagnostics.Error,
                            [vim.diagnostic.severity.WARN] = Dotfiles.icons.diagnostics.Warn,
                            [vim.diagnostic.severity.HINT] = Dotfiles.icons.diagnostics.Hint,
                            [vim.diagnostic.severity.INFO] = Dotfiles.icons.diagnostics.Info,
                        }
                    }
                },
                inlay_hints = {
                    enabled = true,
                },
                --- Enable LSP code lens baked into Neovim 0.10.0 and up
                codelens = {
                    enabled = false,
                },
                autoformat = true,
                servers = {
                    -- The Bash LSP requires NPM. To install NPM, run:
                    -- `wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`
                    -- and then do `nvm list-remote` to see which versions are available.
                    -- Finally, `nvm install <version>`
                    -- bashls = {},
                    rust_analyzer = {},
                    rscls = {},
                },
                setup = {},
            }
        end,
        config = function(_, opts)
            require("utils.format").autoformat = opts.autoformat
            local lsp = require("lspconfig")
            local lsp_configs = require("lspconfig.configs")

            if not lsp_configs.rscls then
                lsp_configs.rscls = {
                    default_config = {
                        cmd = { "rscls" },
                        filetypes = { "rust-script" },
                        root_dir = function(fname) return require("lspconfig").util.path.dirname(fname) end,
                    },
                    docs = {
                        description = [[
https://github.com/MiSawa/rscls

rscls, a language server for rust-script
]],
                    },
                }
            end

            vim.filetype.add {
                pattern = {
                    [".*"] = {
                        function(path, bufnr)
                            local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
                            if vim.regex([[^#!.*rust-script]]):match_str(content) ~= nil then return "rust-script" end
                        end,
                        { priority = math.huge },
                    },
                },
            }
            vim.treesitter.language.register("rust", "rust-script")

            -- Setup diagonstics
            for severity, icon in pairs(opts.diagnostics.signs.text) do
                local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
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
