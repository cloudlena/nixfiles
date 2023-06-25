return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text", config = true },
            {
                "rcarriga/nvim-dap-ui",
                config = function()
                    local dapui = require("dapui")

                    dapui.setup()

                    vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle debugging UI" })
                    vim.keymap.set("n", "<Leader>dK", function()
                        dapui.eval(nil, { enter = true })
                    end, { desc = "Debug symbol under cursor" })
                end,
            },
        },
        cmd = { "DapToggleBreakpoint" },
        keys = {
            {
                "<Leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle breakpoint",
            },
            {
                "<Leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Set breakpoint condition",
            },
        },
        config = function()
            local dap = require("dap")

            vim.fn.sign_define("DapBreakpoint", { text = "󰌖", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "󰌕", texthl = "", linehl = "", numhl = "" })

            vim.keymap.set("n", "<Leader>dd", dap.continue, { desc = "Start/continue debugging" })
            vim.keymap.set("n", "<Leader>dn", dap.step_over, { desc = "Step over" })
            vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step into" })
            vim.keymap.set("n", "<Leader>do", dap.step_out, { desc = "Step out" })
        end,
    },
}
