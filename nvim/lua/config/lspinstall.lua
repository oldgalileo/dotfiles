require("nvim-lsp-installer").setup({
    ensure_installed = vim.g.lspservers_to_install,
    automatic_installation = true,
})
