local Pkg = {}

-- Open git files if possible, if it errors out open normal find files
function Pkg.search_files()
    local opts = {}
    local ok = pcall(require("telescope.builtin").git_files, opts)

    if not ok then
        require("telescope.builtin").find_files(opts)
    end
end

function Pkg.search_in_buffer()
    local actions = require("telescope.actions")
    local opts = {
        attach_mappings = function(_, map)
            map("i", "<C-j>", actions.move_selection_next)
            map("i", "<C-k>", actions.move_selection_previous)

            -- Continue with the other mappings
            return true
        end,
    }
    require("telescope.builtin").current_buffer_fuzzy_find(
        require("telescope.themes").get_dropdown(opts)
    )
end

function Pkg.search_dotfiles()
    local opts = {
        cwd = "~/dotfiles",
    }
    require("telescope.builtin").git_files(opts)
end

return Pkg
