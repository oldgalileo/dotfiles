local lspconfig = require('lspconfig')
local setup_auto_format = require('utils.lsp').setup_auto_format

setup_auto_format("rs")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}

vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
