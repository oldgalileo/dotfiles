local Rust = {}

-- Replace build commands with more standard invocations
Rust.ExecTypes = {
    TEST = "cargo test --no-run --message-format=json --quiet",
    BIN  = "cargo build --message-format=json --quiet",
}

local function parse_executables(cmd)
  local lines = vim.fn.systemlist(cmd)
  local executables = {}

  for _, line in ipairs(lines) do
    -- Attempt to decode the entire JSON line
    local ok, data = pcall(vim.json.decode, line)
    if ok and type(data) == "table" and type(data.executable) == "string" then
      print('found data: ' .. vim.inspect(data))

      -- Cargo's JSON line for a compiled artifact will contain
      -- fields like "package_id", "target" (with "name", "kind"), etc.
      local exe  = data.executable
      local pkg  = data.package_id or "unknown_pkg"
      local t    = data.target or {}
      local tname = t.name or "unknown_target"
      local tkinds = t.kind or {}

      -- Just for clarity, you can join multiple kinds with comma, e.g. {"test", "proc-macro"} → "test, proc-macro"
      local kind_str = table.concat(tkinds, ", ")

      -- Build a nice label for the user to see
      local label = string.format("%s (%s) [%s]", tname, pkg, kind_str)

      table.insert(executables, {
        path  = exe,
        label = label
      })
    end
  end

  if #executables == 0 then
    error("No executables found for command: " .. cmd)
  elseif #executables == 1 then
    return executables[1].path
  else
    -- Multiple executables: prompt the user to pick one
    local choices = { "Select executable to debug:" }
    for i, exe in ipairs(executables) do
      table.insert(choices, string.format("%d: %s\n      %s", i, exe.label, exe.path))
    end

    local choice = vim.fn.inputlist(choices)
    if choice < 1 or choice > #executables then
      error("Invalid selection")
    end

    return executables[choice].path
  end
end

---@param exec_type string  -- One of Rust.ExecTypes
function Rust.run_cargo_build(exec_type)
    return parse_executables(exec_type)
end

-- Convenience wrappers
function Rust.get_test_executable()
    return Rust.run_cargo_build(Rust.ExecTypes.TEST)
end

function Rust.get_bin_executable()
    return Rust.run_cargo_build(Rust.ExecTypes.BIN)
end

Rust.configurations = {
    {
        name = "Debug Test",
        type = "codelldb",
        request = "launch",
        program = Rust.get_test_executable,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
        showDisassembly = "never"
    },
    {
        name = "Debug Bin",
        type = "codelldb",
        request = "launch",
        program = Rust.get_bin_executable,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
        showDisassembly = "never"
    }
}

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "mason.nvim",
        },
        opts = {
            automatic_installation = true,
            ensure_installed = {
                "codelldb"
            },
            handlers = {},
        },
        config = function(_, opts)
            require("mason-nvim-dap").setup(opts)
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" }
            },

            "jay-babu/mason-nvim-dap.nvim",
        },
        opts = {
            adapters = {
                rust = Rust.configurations,
            }
        },
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")

            ---@diagnostic disable-next-line: missing-fields
            dapui.setup({
                -- Set icons to characters that are more likely to work in every terminal.
                --- TODO: Switch to 'utils.icons'
                icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                ---@diagnostic disable-next-line: missing-fields
                controls = {
                    icons = {
                        pause = '⏸',
                        play = '▶',
                        step_into = '⏎',
                        step_over = '⏭',
                        step_out = '⏮',
                        step_back = 'b',
                        run_last = '▶▶',
                        terminate = '⏹',
                        disconnect = '⏏',
                    },
                },
            })

            vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})
            vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close

            for lang, config in pairs(opts.adapters) do
                -- If config is already an array/table with numeric keys, use it directly
                -- Otherwise wrap the single config in a table
                dap.configurations[lang] = type(config[1]) == "table" and config or { config }
            end
        end
    },
}
