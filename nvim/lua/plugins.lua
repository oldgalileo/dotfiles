vim.cmd([[packadd packer.nvim]])

require('packer').startup(function(use)
    use({ "wbthomason/packer.nvim", opt = true })

	-- General Utility/Fixes
	use("ojroques/vim-oscyank")
	use("antoinemadec/FixCursorHold.nvim")
	use("christoomey/vim-tmux-navigator")
	use("alex-popov-tech/timer.nvim")

	use({
		'AckslD/nvim-whichkey-setup.lua',
		requires = {'liuchengxu/vim-which-key'},
	})
	
	-- LSP Stuff
    use({
        "neovim/nvim-lspconfig",
        requires = { { "williamboman/nvim-lsp-installer" } }
    })
	use({
		"folke/trouble.nvim",
		requires = { { 'kyazdani42/nvim-web-devicons' } }
	})
    -- Used for overriding LSP default UI stuff
    use({
        "RishabhRD/nvim-lsputils",
        requires = { { 'RishabhRD/popfix' } }
    })

	-- Completion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")

	use("windwp/nvim-autopairs")
	use("tpope/vim-surround")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { 
            { "nvim-lua/plenary.nvim" },
            { 'nvim-telescope/telescope-ui-select.nvim' }
        },
	})
    use("nvim-telescope/telescope-ui-select.nvim")
	use({'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

	-- Development
	use("simrat39/symbols-outline.nvim")
	use("simrat39/rust-tools.nvim")

	use("ray-x/lsp_signature.nvim")

	-- Neorg
	use({
        "nvim-treesitter/nvim-treesitter",
        before = "neorg",
        run = ":TSUpdate"
    })
	use({
		"nvim-neorg/neorg",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
			{ "nvim-telescope/telescope.nvim" },
            { "nvim-neorg/neorg-telescope" }
		}
	})

	-- Theme
	use("Shatur/neovim-ayu")

	use({
		'kyazdani42/nvim-tree.lua',
		requires = { { "kyazdani42/nvim-web-devicons" } }
	})
end)


-- From packer.nvim README (setup auto-recompilation after changes to this file):
-- ```lua
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerCompile
--   augroup end
-- ]])
-- ````
