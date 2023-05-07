return {
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        opts = {
            actions = {
                open_file = {
                    resize_window = ture
                }
            }
        },
        cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
        event = "User DirOpened",
        config = function(_, opts)
            require("nvim-tree").setup(opts)
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true
    },
}
