return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-vim-test",
            "vim-test/vim-test",
            "nvim-neotest/neotest-go",
            "haydenmeade/neotest-jest",
            "nvim-neotest/neotest-python",
        },
        keys = {
            {
                "<Leader>tn",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run nearest test",
            },
            {
                "<Leader>tf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                    require("neotest").summary.open()
                end,
                desc = "Run all tests in file",
            },
            {
                "<Leader>ta",
                function()
                    require("neotest").run.run(vim.fn.getcwd())
                    require("neotest").summary.open()
                end,
                desc = "Run all tests in suite",
            },
        },
        config = function()
            local neotest = require("neotest")

            neotest.setup({
                icons = {
                    failed = "󰅚",
                    passed = "󰗡",
                    running = "󰐍",
                    unknown = "󰘥",
                },
                adapters = {
                    require("neotest-go"),
                    require("neotest-jest"),
                    require("neotest-python"),
                    require("neotest-vim-test")({
                        ignore_filetypes = {
                            "go",
                            "python",
                        },
                    }),
                },
            })

            vim.keymap.set("n", "<Leader>tu", function()
                neotest.summary.toggle()
            end, { desc = "Toggle testing UI" })
        end,
    },
}
