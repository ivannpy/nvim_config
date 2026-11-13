-- Pluging para guías visuales de identación
return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
        require("ibl").setup({
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                char = "│",
                show_start = true,
                show_end = true,
            },
            exclude = {
                filetypes = {
                    "help",
                    "startify",
                    "dashboard",
                    "snacks_dashboard",
                    "snacks_picker_list",
                    "Trouble",
                    "lazy",
                    "alpha",
                    "lspinfo",
                    "checkhealth",
                    "toggleterm",
                    "DressingInput",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                },
            },
        })
    end
}
