vim.o.background = 'dark'
local colors = require('ayu.colors')
colors.generate()

require('ayu').setup({
	overrides = {
		IncSearch = { fg = colors.fg }
	}
})

require('ayu').colorscheme()
