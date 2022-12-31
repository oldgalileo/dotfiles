-- require("dapui").setup({})

 -- local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "extension/" -- note that this will error if you provide a non-existent package name
 -- local codelldb_path = extension_path .. "adapter/codelldb"
 -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

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
    -- dap = {
    --     -- adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
    --     adapter = require("dap").adapters.codelldb,
    -- },
})
