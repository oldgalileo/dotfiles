local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='🔔', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='⭕️', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='🔵', texthl='', linehl='', numhl=''})

-- CodeLLDB (for Rust)

local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/" -- note that this will error if you provide a non-existent package name
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

dap.adapters.codelldb = function(on_adapter)
    -- This asks the system for a free port
    local tcp = vim.loop.new_tcp()
    tcp:bind('127.0.0.1', 0)
    local port = tcp:getsockname().port
    tcp:shutdown()
    tcp:close()

    -- Start codelldb with the port
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local opts = {
        stdio = {nil, stdout, stderr},
        args = {'--port', tostring(port) }, --, '--liblldb', liblldb_path},
    }
    local handle
    local pid_or_err
    handle, pid_or_err = vim.loop.spawn(codelldb_path, opts, function(code)
        stdout:close()
        stderr:close()
        handle:close()
        if code ~= 0 then
            print("codelldb exited with code", code)
        end
    end)
    if not handle then
        vim.notify("Error running codelldb: " .. tostring(pid_or_err), vim.log.levels.ERROR)
        stdout:close()
        stderr:close()
        return
    end
    vim.notify('codelldb started. pid=' .. pid_or_err)
    stderr:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            vim.schedule(function()
                require("dap.repl").append(chunk)
            end)
        end
    end)
    local adapter = {
        type = 'server',
        host = '127.0.0.1',
        port = port
    }
    -- 💀
    -- Wait for codelldb to get ready and start listening before telling nvim-dap to connect
    -- If you get connect errors, try to increase 500 to a higher value, or check the stderr (Open the REPL)
    vim.defer_fn(function() on_adapter(adapter) end, 500)
end

dap.configurations.rust = {
	{
		-- The first three options are required by nvim-dap
		type = "codelldb",
		request = "launch",
		name = "Launch file",

		-- Options below are for CodeLLDB
		cwd = "${workspaceFolder}",
		program = function()
			local workspaceRoot = require("lspconfig").rust_analyzer.get_root_dir()
			local workspaceName = vim.fn.fnamemodify(workspaceRoot, ":t")

			return vim.fn.input("Path to executable: ", workspaceRoot .. "/target/debug/" .. workspaceName, "file")
		end,
		stopOnEntry = false,
		sourceLanguages = { "rust" },
	},
}
