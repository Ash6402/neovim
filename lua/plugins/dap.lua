return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
        "mason-org/mason.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        require("nvim-dap-virtual-text").setup({})
        dapui.setup()

        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                command = vim.fn.exepath("codelldb"),
                args = {"--port", "${port}"},
            }
        }

        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp

        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)

        vim.keymap.set("n", "<F1>", dap.continue)
        vim.keymap.set("n", "<F2>", dap.step_over)
        vim.keymap.set("n", "<F3>", dap.step_into)
        vim.keymap.set("n", "<F4>", dap.step_out)
        vim.keymap.set("n", "<F6>", dap.step_back)
        vim.keymap.set("n", "<F7>", dap.restart)
        vim.keymap.set("n", "<leader><F7>", dap.terminate)

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end
}
