return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = nil,
        build = ":TSUpdate",
        config = function(_, opts)
            require("config/treesitter")
        end,
    },
}
