return {
	{
		'kyazdani42/nvim-tree.lua',
        lazy = false,
        opts = {
            actions = {
                open_file = {
                    resize_window = ture
                }
            }
        },
        config = function(_, opts)
            require("nvim-tree").setup(opts)
        end,
	},
}
