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
                    "neo-tree",
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
