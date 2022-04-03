require('rust-tools').setup({
	tools = {
		inlay_hints = {
			highlight = 'Comment',
		},
		hover_actions = {
			-- the border that is used for the hover window
			-- see vim.api.nvim_open_win()
			border = {
				{"╭", "FloatBorder"}, {"─", "FloatBorder"},
				{"╮", "FloatBorder"}, {"│", "FloatBorder"},
				{"╯", "FloatBorder"}, {"─", "FloatBorder"},
				{"╰", "FloatBorder"}, {"│", "FloatBorder"}
			},

			-- whether the hover action window gets automatically focused
			auto_focus = false
		},
	},
})
