require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.integrations.telescope"] = {},
        ["core.highlights"] = {},
        ["core.norg.concealer"] = {
            config = {
                icon_preset = "diamond",
                dim_code_blocks = false,
            },
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    org = "~/org/",
                },
                autodetect = true,
                autochdir = true,
            }
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
    }
}
