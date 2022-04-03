local pkg = {}

pkg.nnoremap = function(lhs, rhs, silent)
	vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true, silent = silent })
end

pkg.inoremap = function(lhs, rhs)
	vim.api.nvim_set_keymap("i", lhs, rhs, { noremap = true })
end

pkg.vnoremap = function(lhs, rhs)
	vim.api.nvim_set_keymap("v", lhs, rhs, { noremap = true })
end

pkg.tnoremap = function(lhs, rhs)
	vim.api.nvim_set_keymap("t", lhs, rhs, { noremap = true })
end

return pkg
