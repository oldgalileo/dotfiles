local Pkg = {}

Pkg.nnoremap = function(lhs, rhs, silent)
	vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true, silent = silent })
end

Pkg.inoremap = function(lhs, rhs)
	vim.api.nvim_set_keymap("i", lhs, rhs, { noremap = true })
end

Pkg.vnoremap = function(lhs, rhs)
	vim.api.nvim_set_keymap("v", lhs, rhs, { noremap = true })
end

Pkg.tnoremap = function(lhs, rhs)
	vim.api.nvim_set_keymap("t", lhs, rhs, { noremap = true })
end

return Pkg
