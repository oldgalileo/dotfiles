if vim.fn.has("mac") == 1 then
    require("nvim-treesitter.install").compilers = { "clang" }
end

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main"
    },
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main"
    },
}

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        "rust",
        "lua",
        "bash",
        "json",
        "jsonc",
        "nix",
        "norg",
        "norg_table",
        "norg_meta",
        "go",
        "cpp",
        "c",
    },
    highlight = {
        enable = true,
    },
    indent = { enable = true },
    autopairs = { enable = true },
})

