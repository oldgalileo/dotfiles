local use_local = false

local base_config = {
    quit_map = "q",
    retry_map = "<C-R>",
    display_mode = "split",
    show_prompt = false,
    show_model = true,
    no_auto_close = false,
    debug = true
}

-- Explain the plot of Hitchhiker's Guide to the Galaxy
-- using verse inspired by Walt Whitman

return {
    {
        "naripok/gen.nvim",
        cmd = "Gen",
        config = function()
            if use_local then
                require('gen').setup(vim.tbl_deep_extend("force", {
                    model = "llama3",
                    host = "localhost",
                    port = "11434",
                    command = function(options)
                        return "curl --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
                    end,
                    init = function(options) pcall(io.popen, "ollama serve >/dev/null 2>&1 &") end,
                }, base_config))
            else
                require('gen').setup(vim.tbl_deep_extend("force", {
                    model = "gpt-4-1106-preview",
                    host = "api.openai.com",
                    -- Temperature and top_p selected from this post:
                    -- > https://www.reddit.com/r/ChatGPT/comments/126sr15/gpt_api_analyzing_which_temperature_and_top_p/
                    body = { max_tokens = nil, temperature = 0.7, top_p = 0.5, stop = nil },
                    command = function(options)
                        local api_key = os.getenv("OPENAI_API_KEY")
                        return 'curl --no-buffer --silent ' ..
                                    '-H "Content-Type: application/json" ' ..
                                    '-H "Authorization: Bearer ' .. api_key .. '" ' ..
                                    '-X POST https://' .. options.host .. '/v1/chat/completions ' ..
                                    '-d $body'
                    end,
                    init = nil
                }, base_config))
            end
        end,
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim"
        }
    }
}
