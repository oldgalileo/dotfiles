local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    -- Theme
    {
        "tanvirtin/monokai.nvim",
        lazy = false,
        priority = 1000,
    },
    
	-- General Utility/Fixes
    {
        "phaazon/hop.nvim",
        branch = "v2",
    },
    
    {
        "kyazdani42/nvim-web-devicons",
        lazy = false,
        priority = 900,
    },
	{
		'kyazdani42/nvim-tree.lua',
        lazy = false,
	},
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
    },

    {
        "nvim-lua/plenary.nvim",
        lazy = false,
    },
    {
        "akinsho/toggleterm.nvim",
        lazy = true,
    },
    
    -- Completion
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        ft = "rs",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/vim-vsnip",
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end
    },

	-- General Utility/Fixes
    {
        "ojroques/vim-oscyank",
        cmd = "OSCYank",
    },
	"christoomey/vim-tmux-navigator",
    {
        "folke/which-key.nvim",
        lazy = true,
    },
    {
        "phaazon/hop.nvim",
        lazy = false,
        config = function()
            require("hop").setup({ case_insensitive = false, keys = ".yrkq'lefiuxn;djtcogpab"})
        end
    },
	
	-- LSP Stuff
    "williamboman/mason.nvim", -- LSP / DAP installer
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    "folke/trouble.nvim",

    -- -- Used for overriding LSP default UI stuff
    "glepnir/lspsaga.nvim",

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
        lazy = true,
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        }
    },


	-- Development
    {
        "simrat39/rust-tools.nvim",
        ft = { "rs", "toml" },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        version = nil,
        build = ":TSUpdate",
        config = function(_, opts)
            require("config/treesitter")
        end,
    },
})


-- From packer.nvim README (setup auto-recompilation after changes to this file):
-- ```lua
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerCompile
--   augroup end
-- ]])
-- ````
