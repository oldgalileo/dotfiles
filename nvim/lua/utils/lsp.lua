local lsp_proto = require('vim.lsp.protocol')

local pkg = {}

---@param ft string
---@param command string
pkg.setup_auto_format = function(ft, command)
    if not command then
        command = "lua vim.lsp.buf.formatting_sync()"
    end
    vim.cmd(string.format("autocmd BufWritePre *.%s %s", ft, command))
end

pkg.callback_intermediate = function(handler)
    return function(...)
        local config_or_client_id = select(4, ...)
        local is_new = type(config_or_client_id) ~= "number"
        if is_new then
            handler(...)
        else
            local err = select(1, ...)
            local method = select(2, ...)
            local result = select(3, ...)
            local client_id = select(4, ...)
            local bufnr = select(5, ...)
            local config = select(6, ...)
            handler(
                err,
                result,
                { method = method, client_id = client_id, bufnr = bufnr },
                config
            )
        end
    end
end

pkg.function_kinds = {
    Function = true,
    Method = true,
}

pkg.extract_symbols = function(items, _result)
    local result = _result or {}
    for _, item in ipairs(items) do
        local kind = lsp_proto.SymbolKind[item.kind] or 'Unknown'
        local name = item.name
        local range = nil
        if item.location then
            range = item.location.range
        elseif item.range then
            range = item.range
        end
        if range then
            range.start.line = range.start.line + 1
            range['end'].line = range['end'].line + 1
        end

        table.insert(result, {
            range = range,
            kind = kind,
            name = name,
        })

        if item.children then
            pkg.extract_symbols(item.children, result)
        end
    end

    return result
end

pkg.get_current_function = function()
    local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = nil, -- get em all
    }

    local functions = {}
    local executed = false

    local function symbol_handler(_, result)
        local function_symbols = vim.tbl_filter(function(value) 
            return pkg.function_kinds[value.kind]
        end, pkg.extract_symbols(result))
        functions = function_symbols
        executed = true
    end

    vim.lsp.buf_request(0, "textDocument/documentSymbol", params, pkg.callback_intermediate(symbol_handler))

    vim.wait(10000, function() return executed end)

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    for i = #functions, 1, -1 do
        local sym = functions[i]
        if sym.range and
            cursor_pos[1] >= sym.range.start.line and
            cursor_pos[1] <= sym.range['end'].line
        then
            print(sym.name)
            return sym.name
        end
    end
end

pkg.run_function = function(function_name)
    local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = nil, -- get em all
    }

    print("now we start with... " .. function_name)
    
    local function runnables_handler(_, result)
        result = vim.tbl_filter(function(value)
            return vim.startswith(value.label, "test " .. function_name)
        end, result)

        if vim.tbl_count(result) < 1 then
            print("failed to find test function '" .. function_name .. "'")
            return
        end

        for i, value in ipairs(result) do
            if value.args.cargoArgs[1] == "run" then
                ret[i].args.cargoArgs[1] = "build"
            elseif value.args.cargoArgs[1] == "test" then
                table.insert(result[i].args.cargoArgs, 2, "--no-run")
            end
        end

        print("starting... " .. vim.inspect(result[1].args))
        require('rust-tools.dap').start(result[1].args)
    end

    vim.lsp.buf_request(0, "experimental/runnables", params, pkg.callback_intermediate(runnables_handler))
end

return pkg
