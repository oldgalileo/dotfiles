return {
    {
        "tanvirtin/monokai.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            palette = require('monokai').pro
        },
        config = function(_, opts)
            require('monokai').setup(opts)
        end
    },
    {
        "kyazdani42/nvim-web-devicons",
        lazy = false,
        priority = 900,
    },
}
