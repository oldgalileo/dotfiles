local actions = require('telescope.actions')
require('telescope').setup({
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_better,
				["<C-k>"] = actions.move_selection_worse,
				["<C-q>"] = actions.send_to_qflist,
				["<Esc>"] = actions.close,
			},
		},
	},
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    }
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
